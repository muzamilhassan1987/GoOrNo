//
//  ProfileViewController.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 11/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "ProfileViewController.h"
#import "FriendsDataSource.h"
#import "InterestsDataSource.h"
#import "Constants.h"
#import "GNUser.h"
#import "InterestTableView.h"
#import "FriendsCollectionView.h"
#import <UIImageView+WebCache.h>
#import <APAddressBook.h>
#import <APContact.h>
#import <CoreLocation/CoreLocation.h>

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, InterestTableViewDelegate>
{
    __weak IBOutlet InterestTableView *interesTableView;
    __weak IBOutlet FriendsCollectionView *friendsCollectionView;
    NSMutableArray *contactsArray;
    NSMutableArray *selectedCategories;
    
    
}
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
    [self setBackButton];
    [self addSaveButtonInNavigationBar];
    
    selectedCategories = [NSMutableArray arrayWithArray:[[[ApplicationData sharedInstance] currentUser].Favorites componentsSeparatedByString:@","]];
    
    interesTableView.dataSource = interesTableView;
    interesTableView.delegate   = interesTableView;
    interesTableView.delegateController = self;
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(60, 60)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize = CGSizeMake(friendsCollectionView.frame.size.width, 40);

    
    [friendsCollectionView setCollectionViewLayout:flowLayout];
    
    friendsCollectionView.dataSource = friendsCollectionView;
    friendsCollectionView.delegate = friendsCollectionView;
    
    [self performSelector:@selector(setupProfileDetails) withObject:nil afterDelay:0.1];
    
    [self getAllContacts];
}

-(void) saveButtonPressed:(id) sender {
    
    NSString *categories = [selectedCategories count] == 0 ? @"" : [selectedCategories componentsJoinedByString:@","];
    [[ApplicationData sharedInstance] currentUser].Favorites = categories;
    [[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] save:[ApplicationData sharedInstance].currentUser];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) setupProfileDetails {
    
    [self.lblNameGender setText:[self textForProperty: [[[ApplicationData sharedInstance] currentUser] Name]]];
    [self.lblEmail setText:[self textForProperty:[[[ApplicationData sharedInstance] currentUser] Email]]];
    [self.lblHomeTown setText:[self textForProperty:[[[ApplicationData sharedInstance] currentUser] City]]];
    [self.lblBirthday setText:@"Birthday"];
    [self.lblMobile setText:[self textForProperty:[[[ApplicationData sharedInstance] currentUser] Phone]]];
    
    [_imgProfilePic.layer setCornerRadius:_imgProfilePic.frame.size.height / 2.0];
    [_imgProfilePic setClipsToBounds:YES];
    [_imgProfilePic sd_setImageWithURL:[NSURL URLWithString:CognitoS3ImagePath([[[ApplicationData sharedInstance] currentUser] Image])]
                      placeholderImage:nil];
    
    [self getCurrentLocation];

}

-(NSString *) textForProperty:(NSString *) property {
    
    return property.length == 0 ? @"-" : property;
}

#pragma mark InterestTableView delegate

-(void) interestDidSelect:(GNCategory *)category {
    
    if ([selectedCategories containsObject:category.CategoryID]) {
        [selectedCategories removeObject:category.CategoryID];
    }
    else {
        [selectedCategories addObject:category.CategoryID];
    }
    interesTableView.selectedCategories = selectedCategories;
}

-(void) getCurrentLocation {
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    if ([[UIDevice currentDevice] systemVersion].doubleValue >= 8.0) {
        
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

#pragma mark CLLocationManager delegate

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    if ([locations count] > 0) {
        
        [self.locationManager stopUpdatingLocation];
        self.locationManager = nil;
        
        CLGeocoder* reverseGeocoder = [[CLGeocoder alloc] init];
        if (reverseGeocoder) {
            [reverseGeocoder reverseGeocodeLocation:[locations firstObject] completionHandler:^(NSArray *placemarks, NSError *error) {
                CLPlacemark* placemark = [placemarks firstObject];
                if (placemark) {

                    NSString *city = [placemark.addressDictionary objectForKey:(NSString*)kABPersonAddressCityKey];
                    NSLog(@"City:%@", city);
                    [self.lblHomeTown setText:city];
                }
            }];
        }
    }
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"err:%@",[error localizedDescription]);
}

-(IBAction)addPhotoButtonPressed:(id)sender {
    
    NSArray * buttons = ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) ? @[@"Choose from Gallery", @"Take Photo"] : @[@"Choose from Gallery"];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    [RMUniversalAlert showActionSheetInViewController:self
                                            withTitle:@"Select Picture"
                                              message:nil
                                    cancelButtonTitle:@"Cancel"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:buttons
                   popoverPresentationControllerBlock:nil
                                             tapBlock:^(RMUniversalAlert *alert, NSInteger buttonIndex) {
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

#pragma mark UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    [self.imgProfilePic setImage:chosenImage];
    
    [Utility saveImage:chosenImage withName:@"profileimage.png" inFolder:NSTemporaryDirectory()];
    [self uploadImage:chosenImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void) uploadImage:(UIImage *) image {
    
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.bucket = CognitoS3BucketName;
    uploadRequest.key = [NSString stringWithFormat:@"%@.png",[[NSUUID UUID] UUIDString]];
    [[[ApplicationData sharedInstance] currentUser] setImage: uploadRequest.key];
    uploadRequest.body = [Utility urlForImageName:@"profileimage.png" inFolder:FolderUploadImages];
    
    uploadRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            self.totalProgress = ((float)totalBytesSent / (float)totalBytesExpectedToSend);
//            [SVProgressHUD showProgress:self.totalProgress];
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
            [[[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] save:[[ApplicationData sharedInstance] currentUser]]
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
                     dispatch_async(dispatch_get_main_queue(), ^{

                     });
                 }
                 return nil;
             }];
        }
        return nil;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void) getAllContacts {
    
    APAddressBook *addressBook = [[APAddressBook alloc] init];
    addressBook.fieldsMask = APContactFieldEmails | APContactFieldPhones | APContactFieldFirstName | APContactFieldLastName;
    addressBook.filterBlock = ^BOOL(APContact *contact)
    {
        return contact.phones.count > 0 || contact.emails.count > 0;
    };
    // don't forget to show some activity
    [addressBook loadContacts:^(NSArray *contacts, NSError *error)
    {
        // hide activity
        if (!error)
        {
            NSLog(@"contacts:%@", contacts);
            contactsArray = [NSMutableArray new];
            [self queryAppUsersWithContacts:contacts];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }
    }];
}


-(void) queryAppUsersWithContacts:(NSArray *) contacts {
    
    NSMutableArray *phoneNumbers = [NSMutableArray new];
    
    AWSDynamoDBCondition *condition = [AWSDynamoDBCondition new];
    AWSDynamoDBAttributeValue *attribute = [AWSDynamoDBAttributeValue new];
    
    attribute.S = @"111000";
    [phoneNumbers addObject:attribute];
    for (APContact *contact in contacts) {
        
        if ([contact.phones count] > 0) {
            AWSDynamoDBAttributeValue *attribute = [AWSDynamoDBAttributeValue new];
            
            attribute.S = [Utility trimSpacesAndCharactersFromPhoneNumber:[contact.phones firstObject]];
            [phoneNumbers addObject:attribute];
        }
        
    }
    
    condition.comparisonOperator = AWSDynamoDBComparisonOperatorIN;
    condition.attributeValueList = phoneNumbers;
    NSDictionary *dictionary = @{@"Phone" : condition};
    
    
    AWSDynamoDBScanExpression *expression = [AWSDynamoDBScanExpression new];
    expression.scanFilter = dictionary;
    expression.limit = @(100);
    
    
    [[[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] scan:[GNUser class]
                                                            expression:expression]
     continueWithBlock:^id(BFTask *task) {
         
         if (task.error) {
             [SVProgressHUD showErrorWithStatus:[task.error localizedDescription]];
         }
         if (task.exception) {
             [SVProgressHUD showErrorWithStatus:[task.exception reason]];
         }
         if (task.result) {
             
             NSLog(@"result users:%@", task.result);
             AWSDynamoDBPaginatedOutput *output = task.result;
             for (GNUser *user in output.items) {
                 
                 [contactsArray insertObject:user atIndex:0];
             }
             [friendsCollectionView performSelectorOnMainThread:@selector(reloadWithData:)
                                                     withObject:contactsArray
                                                  waitUntilDone:true];
         }
         return task;
     }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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
