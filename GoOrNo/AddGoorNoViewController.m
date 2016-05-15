//
//  AddGoorNoViewController.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 13/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "AddGoorNoViewController.h"

@interface AddGoorNoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
  BOOL _actionSheetAppeared;
}

@property (weak, nonatomic) IBOutlet UIButton *btnSelectedImage;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleAddPicture;

@end

@implementation AddGoorNoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.post.Type = PostTypeMake(PostTypeGoNo);
  // Do any additional setup after loading the view.
  [self setNavigationBackgroundColor:[UIColor cyanColor] titleColor:[UIColor whiteColor]];
  self.title = @"Go or No";
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if (_actionSheetAppeared == NO) {
    _actionSheetAppeared = YES;
    [self btnSelectImageTapped:self.btnSelectedImage];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)btnSelectImageTapped:(id)sender {
    
  NSArray * buttons = ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) ? @[@"Select Photo From Gallery", @"Take Photo"] : @[@"Select Photo From Gallery"];
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  picker.delegate = self;
  picker.allowsEditing = YES;
  [RMUniversalAlert showActionSheetInViewController:self withTitle:@"Select Picture" message:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:buttons popoverPresentationControllerBlock:nil tapBlock:^(RMUniversalAlert *alert, NSInteger buttonIndex) {
    if(buttonIndex>=2) {
      switch (buttonIndex) {
        case 2:
          picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
          break;
        case 3:
          picker.sourceType = UIImagePickerControllerSourceTypeCamera;
          
        default:
          break;
      }
      [self presentViewController:picker animated:YES completion:NULL];
    }
  }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  
  UIImage *chosenImage = info[UIImagePickerControllerEditedImage];

  [self.btnSelectedImage setTitle:@"" forState:UIControlStateNormal];
  self.lblTitleAddPicture.text = @"";
  [self.btnSelectedImage setImage:chosenImage forState:UIControlStateNormal];
  [Utility saveImage:chosenImage withName:ImageNameGoOrNo inFolder:FolderUploadImages];
  [picker dismissViewControllerAnimated:YES completion:NULL];
  
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  
  [picker dismissViewControllerAnimated:YES completion:NULL];
  
}

- (void)btnGoTapped:(id)sender {
  [self.view endEditing:YES];
  [SVProgressHUD showProgress:0.0];
  
  // Save Image To AWS S3
  [super btnGoTapped:sender];
  
  AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
  uploadRequest.bucket = CognitoS3BucketName;
  uploadRequest.key = [NSString stringWithFormat:@"%@.png",[[NSUUID UUID] UUIDString]];
  self.post.S3Image0 = uploadRequest.key;
  uploadRequest.body = [Utility urlForImageName:ImageNameGoOrNo inFolder:FolderUploadImages];
  uploadRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    dispatch_async(dispatch_get_main_queue(), ^{
      self.totalProgress = ((float)totalBytesSent / (float)totalBytesExpectedToSend);
      [SVProgressHUD showProgress:self.totalProgress];
    });
  };
  
  [[[[AmazonClientManager sharedInstance] transferManager] upload:uploadRequest] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
    if (task.error) {
      if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
        switch (task.error.code) {
          case AWSS3TransferManagerErrorCancelled:
          case AWSS3TransferManagerErrorPaused:
            break;
          default:
            NSLog(@"Error: %@", task.error);
            dispatch_async(dispatch_get_main_queue(), ^{
              [SVProgressHUD showErrorWithStatus:task.error.localizedDescription];
            });
            break;
        }
      } else {
        // Unknown error.
        NSLog(@"Error: %@", task.error);
        dispatch_async(dispatch_get_main_queue(), ^{
          [SVProgressHUD showErrorWithStatus:task.error.localizedDescription];
        });
      }
    }
    if (task.result) {
      AWSS3TransferManagerUploadOutput *uploadOutput = task.result;
      // The file uploaded successfully.
      [[[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] save:self.post]
       continueWithBlock:^id(BFTask *task) {
         if (task.error) {
           NSLog(@"The request failed. Error: [%@]", task.error);
           dispatch_async(dispatch_get_main_queue(), ^{
             [SVProgressHUD showErrorWithStatus:task.error.localizedDescription];
           });
         }
         if (task.exception) {
           NSLog(@"The request failed. Exception: [%@]", task.exception);
           dispatch_async(dispatch_get_main_queue(), ^{
             [SVProgressHUD showErrorWithStatus:@"Failed. Exception occured"];
           });
         }
         if (task.result) {
           //Do something with the result.
             NSMutableArray *deviceTokens = [NSMutableArray new];
             
             NSArray *ids = [self.post.InvitedUsers componentsSeparatedByString:@","];
             for (NSString *uid in ids) {
                 
                 GNUser *user = [self.selectedUsers objectForKey:uid];
                 if(user.DeviceToken != nil)
                     [deviceTokens addObject:user.DeviceToken];
                 
                 GNNotification *notification = [[GNNotification alloc] init];
                 notification.InviteeID = uid;
                 notification.NotificationID = [[NSUUID UUID] UUIDString];
                 notification.InviterName = [[[ApplicationData sharedInstance] currentUser] Name];
                 notification.PostID = self.post.PostID;
                 [[[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] save:notification] continueWithBlock:^id(BFTask *task) {
                     
                     return task;
                 }];
                 
                 
             }
             
             NSMutableDictionary *apnsParams = [NSMutableDictionary dictionary];
             NSString *message = [NSString stringWithFormat:@"%@ invited you to suggest on his ruling", [[ApplicationData sharedInstance].currentUser Name]];
             
             NSData *data = [NSJSONSerialization dataWithJSONObject:deviceTokens options:0 error:nil];
             NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             [apnsParams setObject:str forKey:@"deviceTokens"];
             [apnsParams setObject:message forKey:@"message"];
             [apnsParams setObject:@{@"UserID" : [[ApplicationData sharedInstance].currentUser UserID],
                                     @"PostID" : [self.post PostID]} forKey:@"arguments"];
             
             [self performSelectorOnMainThread:@selector(sendNotificationToUsersWithParameters:)
                                    withObject:apnsParams
                                 waitUntilDone:true];
             
           dispatch_async(dispatch_get_main_queue(), ^{
             [SVProgressHUD showSuccessWithStatus:@"Saved"];
             [self.navigationController popViewControllerAnimated:YES];
           });
         }
         return nil;
       }];
    }
    return nil;
  }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
