//
//  AddMultiPicViewController.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 16/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "AddMultiPicViewController.h"
#import "MultiPicturesDataSource.h"

@interface AddMultiPicViewController ()<QBImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegateFlowLayout>{
  BOOL _actionSheetAppeared;
}

@end

@implementation AddMultiPicViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.post.Type = PostTypeMake(PostTypeMultiPic);
  [self setNavigationBackgroundColor:[UIColor orangeColor] titleColor:[UIColor whiteColor]];
  self.title = @"Multi Picture";
//  self.title = @"Multi-Picture";
  // Do any additional setup after loading the view.
  self.dataSourcePics = [[MultiPicturesDataSource alloc] initWithViewController:self collectionViewPropertyName:@"collectionViewPics"];
  self.collectionViewPics.dataSource = self.dataSourcePics;
  self.collectionViewPics.delegate = self;
  
  [self.dataSourcePics reloadDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.dataSourcePics reloadCollectionViewData];
  [self.tableViewGetData reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if (_actionSheetAppeared == NO) {
    _actionSheetAppeared = YES;
    [self btnAddPicTapped:nil];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  [collectionView deselectItemAtIndexPath:indexPath animated:YES];
  self.defaultPicIndex = indexPath.item;
  [self.collectionViewPics reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)btnGoTapped:(id)sender {
  
  [self.view endEditing:YES];
  self.totalProgress = 0.0;
  [SVProgressHUD showProgress:self.totalProgress];
  
  self.post.DefaultIndex = [NSNumber numberWithInteger:self.defaultPicIndex];
  self.post.Date = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
  
  NSMutableArray *tasks = @[].mutableCopy;
  for(NSInteger index=0; index<self.dataSourcePics.itemsArray.count; index++) {
    UIImage * image = self.dataSourcePics.itemsArray[index];
    // Save Image To Temp Directory
    NSString * imageName = [NSString stringWithFormat:@"%@.png",[[NSUUID UUID] UUIDString]];
    [Utility saveImage:image withName:imageName inFolder:nil];
    // Save Image To AWS S3
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.bucket = CognitoS3BucketName;
    uploadRequest.key = imageName;
    [self.post setValue:imageName forKey:[NSString stringWithFormat:@"S3Image%ld",(long)index]];
    uploadRequest.body = [Utility urlForImageName:imageName inFolder:FolderUploadImages];
    uploadRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
      NSLog(@"bytesSent: %lld -- totalBytesSent: %lld -- totalBytesExpectedToSend: %lld",bytesSent,totalBytesSent,totalBytesExpectedToSend);
      dispatch_async(dispatch_get_main_queue(), ^{
        self.totalProgress += ((float)bytesSent / (float)totalBytesExpectedToSend);
        [SVProgressHUD showProgress:self.totalProgress/self.dataSourcePics.itemsArray.count];
      });
    };
    // Add Image Upload BFTask to tasks array
    [tasks addObject:[[[AmazonClientManager sharedInstance] transferManager] upload:uploadRequest]];
  }
  // Group completion task is called when all the images are uploaded
  BFTask *groupTask = [BFTask taskForCompletionOfAllTasks:tasks.copy];
  [groupTask continueWithBlock:^id(BFTask *task) {
    // this will be executed after *all* the group tasks have completed
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
    return nil;
  }];
}

#pragma mark UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  UIImage *image = info[UIImagePickerControllerEditedImage];
  [self.dataSourcePics.itemsArray addObject:image];
  [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets {
  for (ALAsset * asset in assets) {
    UIImage * image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
    [self.dataSourcePics.itemsArray addObject:image];
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return self.collectionViewPics.frame.size;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark IBAction
- (IBAction)btnDeletePic:(UIButton *)sender {
  CGRect frame = [sender convertRect:sender.bounds toView:self.collectionViewPics];
  NSIndexPath * indexPath = [self.collectionViewPics indexPathForItemAtPoint:frame.origin];
  [self.dataSourcePics.itemsArray removeObjectAtIndex:indexPath.item];
  if (self.defaultPicIndex>0) {
    self.defaultPicIndex--;
  }
  [self.dataSourcePics reloadCollectionViewData];
}

- (IBAction)btnAddPicTapped:(UIButton *)sender {
  NSArray * buttons = ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) ? @[@"Select Photo From Gallery", @"Take Photo"] : @[@"Select Photo From Gallery"];
  [RMUniversalAlert showActionSheetInViewController:self withTitle:@"Select Picture" message:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:buttons popoverPresentationControllerBlock:nil tapBlock:^(RMUniversalAlert *alert, NSInteger buttonIndex) {
    if(buttonIndex>=2) {
      switch (buttonIndex) {
        case 2:
        {
          QBImagePickerController *imagePickerController = [QBImagePickerController new];
          imagePickerController.delegate = self;
          imagePickerController.allowsMultipleSelection = YES;
          imagePickerController.maximumNumberOfSelection = 5;
          imagePickerController.showsNumberOfSelectedAssets = YES;
          [self presentViewController:imagePickerController animated:YES completion:nil];
          break;
        }
        case 3:
        {
          UIImagePickerController *picker = [[UIImagePickerController alloc] init];
          picker.delegate = self;
          picker.allowsEditing = YES;
          picker.sourceType = UIImagePickerControllerSourceTypeCamera;
          [self presentViewController:picker animated:YES completion:NULL];
          break;
        }
        default:
          break;
      }
    }
  }];
}
@end
