//
//  Feed2ViewController.m
//  wzup
//
//  Created by Simen Lie on 26.02.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "Feed2ViewController.h"
#import "Feed2TableViewCell.h"
#import "FeedController.h"
#import "StatusModel.h"
#import "UserModel.h"
#import "AuthHelper.h"
#import "StartViewController.h"
#import "ProfileViewController.h"
#import "ApplicationHelper.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface Feed2ViewController ()

@end

@implementation Feed2ViewController
NSIndexPath *indexCurrent;
NSMutableArray *feed;
AuthHelper *authHelper;
FeedController* feedController;
UIView *oldView;
BOOL shouldExpand;
CGRect screenBound;
CGSize screenSize;
CGFloat screenWidth;
CGFloat screenHeight;
CGFloat horizontalSpaceDefault;
ApplicationHelper *applicationHelper;
bool availabilityFadeHasStarted;
NSString* availableText;
NSString* unAvailableText;
bool cameraIsShown;
AVCaptureStillImageOutput * stillImageOutput;
UIImage *imgTaken;
AVCaptureSession *session;
AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
Feed2TableViewCell *currentCell;
Feed2TableViewCell *cameraCell;
NSIndexPath *currentCellsIndexPath;
NSNumber *available;
SEL littleSelector;
bool frontFacing;
AVCaptureDevice *frontCamera;
AVCaptureDevice *backCamera;
UITapGestureRecognizer *flipCameratapGr;
- (void)viewDidLoad {
    littleSelector = @selector(imageIsUploaded);
    authHelper = [[AuthHelper alloc] init];
    self.availabilityView.alpha = 0.0;
    [super viewDidLoad];
    [self showTopBar];
    horizontalSpaceDefault = self.statusButtonHorizontalSpace.constant;
    screenBound = [[UIScreen mainScreen] bounds];
    screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    self.statusButton.layer.cornerRadius = 25;
    //self.cancelButton.layer.cornerRadius = 25;
    self.cancelButton.hidden = YES;
    self.availabilityView.hidden = YES;
    self.availabilityView.backgroundColor = [UIColor colorWithRed:0.18 green:0.8 blue:0.443 alpha:1];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    // Do any additional setup after loading the view.
    feedController = [[FeedController alloc] init];
    applicationHelper = [[ApplicationHelper alloc] init];
    [applicationHelper addAvailableTexts];
    [applicationHelper addUnAvailableTexts];

    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                feed = [feedController getFeed];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            self.tableView.tableHeaderView = nil;
            [self.tableView reloadData];
        });
        
    });
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(labelDragged:)];

    [_statusButton addGestureRecognizer:gesture];
    
    
    
}
- (IBAction)cancelStatus:(id)sender {
    NSLog(@"Canceling");
       [self takingPhotoIsDone];
}

-(void)imageIsUploaded{
    NSLog(@"METHOD HERE");
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         //swish out
                         [currentCell tickImage].hidden = NO;
                         [currentCell tickImage].alpha = 0.9;
                         
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.3f
                                               delay:0.5f
                                             options: UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              //[currentCell tickImage].hidden = NO;
                                              [currentCell tickImage].alpha = 0.0;
                                              
                                          }
                                          completion:^(BOOL finished){
                                              shouldExpand = NO;
                                              [_tableView beginUpdates];
                                              [_tableView endUpdates];
                                          }];
                     }];
}

-(void)fadeInAvailabilityView{

 
    if(!availabilityFadeHasStarted){
        availableText = [applicationHelper getAvailableText];
        unAvailableText =[applicationHelper getUnAvailableText];
        self.availabilityView.hidden = NO;
        availabilityFadeHasStarted = YES;
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.availabilityView.alpha = 0.9;
                             //[self.view layoutIfNeeded];
                         }
                         completion:nil];
    }
}

-(void)fadeOutAvailabilityView{
    
    
    if(availabilityFadeHasStarted){
        availabilityFadeHasStarted = NO;
        
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.availabilityView.alpha = 1.0;
                             
                         }
                         completion:^(BOOL finished){
                             _statusButtonHorizontalSpace.constant = horizontalSpaceDefault;
                             [UIView animateWithDuration:0.4f
                                                   delay:0.4f
                                                 options: UIViewAnimationOptionCurveLinear
                                              animations:^{
                                                  self.availabilityView.alpha = 0.0;
                                                  self.availabilityView.hidden = NO;
                                                  _statusButton.alpha = 1;
                                              }
                                              completion:nil];
                         }];
        
        
        
        
    }
}

- (void)labelDragged:(UIPanGestureRecognizer *)gesture
{
    if(!cameraIsShown){
        [self fadeInAvailabilityView];
        UILabel *label = (UILabel *)gesture.view;
        CGPoint translation = [gesture translationInView:label];
        float newX = _statusButtonHorizontalSpace.constant;
        
        //NSLog(@"gesture point %f",  translation.x);
        if(newX > 150){
            //Change availability
            available = [NSNumber numberWithInt:1];
            self.availabilityView.backgroundColor = [UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1];
            _statusText.text = unAvailableText;
            
            
        }else{
            //Change availability to available
            available = [NSNumber numberWithInt:0];
            _statusText.text = availableText;
            self.availabilityView.backgroundColor = [UIColor colorWithRed:0.18 green:0.8 blue:0.443 alpha:1];
        }
        
        if(translation.x < 0){
            //CHECK left
            //NSLog(@"constraint is %f", _statusButtonHorizontalSpace.constant);
            
            if(newX>= 300){
                newX = 300;
                _statusButtonHorizontalSpace.constant = newX;
            }
            else {
                _statusButtonHorizontalSpace.constant -= translation.x;
            }
        }
        else{
            //CHECK right
            if(newX <= 16){
                newX = 16;
                _statusButtonHorizontalSpace.constant = newX;
            }
            else {
                _statusButtonHorizontalSpace.constant -= translation.x;
                //NSLog(@"constraint is %f", _statusButtonHorizontalSpace.constant);
            }
        }
        if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled)
        {
            // _statusButton.hidden = YES;
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            [self fadeOutStatusButton];
            //_statusButton.alpha= 0;
            [self fadeOutAvailabilityView];
            [feedController updateAvailability:available];
        }
        else{
            [gesture setTranslation:CGPointZero inView:label];
        }
    }
  

}

-(void)fadeOutStatusButton{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         _statusButton.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                    
                     }];

}

-(void)handleTap:(UITapGestureRecognizer *) sender{
    if(!cameraIsShown){
        CGPoint tapLocation = [sender locationInView:self.tableView];
        NSIndexPath *tapIndexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
        
        
        ProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
        StatusModel *statusmodel = [feed objectAtIndex:tapIndexPath.row];
        [vc setProfile:statusmodel];
        // OR myViewController *vc = [[myViewController alloc] init];
        
        // any setup code for *vc
        
        [self.navigationController pushViewController:vc animated:YES];
        // do any setup you need for myNewVC
    }

    
    
}

-(void)flipCamera:(UITapGestureRecognizer *) sender{
    if(cameraIsShown){
        [session stopRunning];
        [captureVideoPreviewLayer removeFromSuperlayer];
        [_tableView reloadData];
        frontFacing = frontFacing ? NO : YES;
        [self initializeCamera:cameraCell.statusImage];
    }

  
    
    
}

-(void)addCaption:(UITapGestureRecognizer *) sender{
    NSLog(@"Adding capture");
    
    
    
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    if([feed count] > 0){
    [feed removeObjectAtIndex:0];
    }
    
    feed = [feedController getFeed];
    indexCurrent = nil;
    [self.tableView reloadData];
    [self checkErrors];
    [refreshControl endRefreshing];
    
}
-(void)checkErrors{
    if([feedController hasError]){
        StartViewController*startController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"startNav"];
        [self presentModalViewController:startController animated:YES];
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [feed count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //NSLog(@"cell creation");
    static NSString *CellIdentifier = @"customCell";
    Feed2TableViewCell *cell = (Feed2TableViewCell  *)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    //cell=nil;
    if(cell == nil){
        cell = [[Feed2TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customCell"];
       
    }
    if([feed count] != 0){
        UITapGestureRecognizer *tapGr;
        tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapGr.numberOfTapsRequired = 1;
        [[cell getTopBar] addGestureRecognizer:tapGr];
        StatusModel *status = [feed objectAtIndex:indexPath.row];
        cell.statusLabel.text = [status getBody];
       
        cell.nameLabel.text = [[status getUser] getDisplayName];
        if([[status getUser] getId ] == [[authHelper getUserId] intValue]){
            [feedController setLoading:[cell uploadImageIndicatorLabel]];
            [feedController setImageDone:[cell tickImage]];
            [feedController setSelector:littleSelector withObject:self];
            
            
            cell.statusLabel.text = @"";
            
         
            //Init tap gesture
            UITapGestureRecognizer *tapGr;
            tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addCaption:)];
            tapGr.numberOfTapsRequired = 1;
            [[cell bottomBar] addGestureRecognizer:tapGr];
            
            
            NSLog(@"------------auth: %@ model: %d", [authHelper getUserId ], [[status getUser] getId ]);
            if(imgTaken == nil && cameraIsShown){
                shouldExpand = true;
                indexCurrent = indexPath;
                [cell.statusImage setBackgroundColor:nil];
                
                flipCameratapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipCamera:)];
                flipCameratapGr.numberOfTapsRequired = 1;
                flipCameratapGr.cancelsTouchesInView = NO;
                [[cell statusImage] addGestureRecognizer:flipCameratapGr];
                cameraCell = cell;
                [self initializeCamera:cell.statusImage];
              
            }
           
        }
        //cell.profilePicture.image = [UIImage imageNamed:[status getImgPath]];
        cell.profilePicture.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", @"status-icon2.png"]];
        
        //NSLog([status getImgPath]);
        cell.statusImg = [status getImgPath];
      
        CGSize size = CGSizeMake(screenWidth, 500);
    
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        
        dispatch_async(queue, ^{
            UIImage * image = [[UIImage alloc] init];
            if([status getMedia] == nil){
                image =  [UIImage imageNamed:@"status-icon2.png"];
            }else{
                image = [UIImage imageWithData:[status getMedia]];
                
                //image =  [UIImage imageNamed:@"testBilde.jpg"];
            }
            image = [self imageByScalingAndCroppingForSize:size img:image];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [cell stopImageLoading];
                [cell.statusImage setBackgroundColor:[UIColor colorWithPatternImage:image]];
                if(imgTaken != nil){
                    NSLog(@"setting image ---------");
                    if([[status getUser] getId ] == [[authHelper getUserId] intValue]){
                        NSLog(@"setting image22 ---------");
                        //shouldExpand = false;
                        // session.stopRunning;
                        
                        [[cell statusImage] removeGestureRecognizer:flipCameratapGr];
                        
                        cell.profilePicture.image = [UIImage imageNamed:@"testBilde.jpg"];
                        cell.statusLabel.text = @"Tap to add caption";
                        
                        currentCell = cell;
                        currentCellsIndexPath = indexPath;
                        [currentCell editStatusTextField].text = @"";
                        [currentCell editStatusTextField].hidden = NO;
                        [currentCell editStatusTextField].delegate = self;
                        [[currentCell editStatusTextField] addTarget:self
                                                              action:@selector(textFieldDidChange:)
                                                    forControlEvents:UIControlEventEditingChanged];
                        [[NSNotificationCenter defaultCenter] addObserver:self
                                                                 selector:@selector(keyboardWillShow:)
                                                                     name:UIKeyboardWillShowNotification
                                                                   object:nil];
                        
                        [cell.statusImage setBackgroundColor:[UIColor colorWithPatternImage:[self imageByScalingAndCroppingForSize:size img:imgTaken]]];
                    }
                }
                [cell setNeedsLayout];
            });
        });
        //image = [self imageByScalingAndCroppingForSize:size img:image];
        //[cell.statusImage setBackgroundColor:[UIColor colorWithPatternImage:nil]];
      //  NSLog(@"--IMG setting %@", [status getImgPath]);
        //[cell.statusImage setBackgroundColor:[UIColor colorWithPatternImage:image]];
        [cell setAvailability:[[status getUser] getAvailability]];
        
    }
   
    return cell;
}

-(void)textFieldDidChange:(UITextField *) textField{
    //[self showLoginButton];
    if(textField.text.length > 39){
    
    }
    NSLog(@"%lu", (unsigned long)textField.text.length);
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 65) ? NO : YES;
    
    
}

-(void)keyboardWillShow:(NSNotification *)note {
    NSLog(@"tets");
    [currentCell statusLabel].text = @"";
    NSLog(@"here2");
    shouldExpand = NO;
    [_tableView beginUpdates];
    
    
    [_tableView endUpdates];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"row for height");
    if ([indexPath isEqual:indexCurrent] && shouldExpand)
    {
        return 500;
    }
    else if([indexPath isEqual:indexCurrent]){
        return 231;
    }
    else {
        return 231;
    }

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == [currentCell editStatusTextField]){
        [[currentCell editStatusTextField] resignFirstResponder];
        [self saveStatus];
        return NO;
    }
 
    return YES;
}

-(void) saveStatus{
    NSString *status = [currentCell editStatusTextField].text;
    [currentCell editStatusTextField].hidden = YES;
    [currentCell statusLabel].text = status;
    [feedController updateStatus:status];
   
    //self.tickImage.hidden = YES;
    //self.tickImage.alpha = 0.0;
    
    [UIView animateWithDuration:0.3f
                          delay:0.5f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         //swish out
                         [currentCell captionTick].hidden = NO;
                         [currentCell captionTick].alpha = 0.5;
                        
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.3f
                                               delay:0.5f
                                             options: UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              //swish out
                                              [currentCell captionTick].alpha = 0.0;
                                              
                                          }
                                          completion:^(BOOL finished){
                                              //currentCell = nil;
                                              //currentCellsIndexPath = nil;
                                              
                                          }];
                         
                     }];
    //[feed removeObjectAtIndex:0];
    //[self.tableView reloadData];
    //currentCell = nil;
    //currentCellsIndexPath = nil;
    //[_tableView reloadData];
    NSLog(@"saving");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)path
// or it must be some other method
{
    NSLog(@"testerer");
    if(!cameraIsShown){
        NSIndexPath *oldIndex = indexCurrent;
        
        indexCurrent = path;
        
        if(cameraIsShown){
            
        }
        else if(indexCurrent == oldIndex){
            //indexCurrent = nil;
            if(shouldExpand){
                shouldExpand = false;
            }else{
                shouldExpand = true;
            }
            
        }else{
            shouldExpand = true;
        }
        
        [tableView beginUpdates];
        
        
        [tableView endUpdates];
    }
  

    
}

-(void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize img:(UIImage *) sourceImage
{
    NSLog(@"----SCALING IMAGE");
    // NSLog(@"THE size is width: %f height: %f", targetSize.width, targetSize.height);
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        
        //NSLog(@"fit height %f", targetSize.width);
        scaleFactor = widthFactor; // scale to fit height
        
        
        
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = 0;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = 0;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addStatus:(id)sender {
    if(!cameraIsShown){
        cameraIsShown = YES;
        [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        //Prepare for taking picture with camera
        _tableView.scrollEnabled = NO;
        
       imgTaken = nil;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                [UIView animateWithDuration:0.3f
                                      delay:0.0f
                                    options: UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     self.cancelButton.hidden = NO;
                                     self.cancelButton.alpha = 0.7;
                                     _statusButtonHorizontalSpace.constant += 130;
                                     [self.view layoutIfNeeded];
                                 }
                                 completion:^(BOOL finished){
                                     
                                 }];
            });
            
        });
        
        NSLog(@"error testing");
        StatusModel *tempStatus = nil;
        if([feed count] > 0){
            tempStatus = [feed objectAtIndex:0];
        }
        
         if([[tempStatus getUser] getId ] == [[authHelper getUserId] intValue]){
         
         }else{
             NSLog(@"error testing2");
             UserModel* user = [feedController getUser];
             // NSLog(@"Username is: %@", [test getUsername]);
             StatusModel *status = [[StatusModel alloc] init];
             [status setUser:user];
             
             [feed insertObject:status atIndex:0];
         }
     
        [self.tableView reloadData];
        
    }
    else if(cameraIsShown){
    //Take picture
        
        [self capImage];
         cameraIsShown = NO;
         
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                [UIView animateWithDuration:0.3f
                                      delay:0.0f
                                    options: UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     
                                     _statusButtonHorizontalSpace.constant = horizontalSpaceDefault;
                                     [self.view layoutIfNeeded];
                                 }
                                 completion:^(BOOL finished){
                                     
                                 }];
            });
        });
    }
}

- (void) initializeCamera:(UIView *) cameraView {
    
    session = [[AVCaptureSession alloc] init];
    
    
    session.sessionPreset = AVCaptureSessionPresetPhoto;
    
        captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
    
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CGRect rect = cameraView.bounds;
    rect.size.height = 480;
    cameraView.bounds = rect;
    NSLog(@"height: %f",cameraView.bounds.size.height);
    captureVideoPreviewLayer.frame = cameraView.bounds;

    //[cameraView.layer addSublayer:captureVideoPreviewLayer];
    [cameraView.layer insertSublayer:captureVideoPreviewLayer atIndex:0];
    

    
    UIView *view = cameraView;
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CGRect bounds = [view bounds];
        [captureVideoPreviewLayer setFrame:bounds];
        
        NSArray *devices = [AVCaptureDevice devices];
        
        for (AVCaptureDevice *device in devices) {
            
            NSLog(@"Device name: %@", [device localizedName]);
            
            if ([device hasMediaType:AVMediaTypeVideo]) {
                
                if ([device position] == AVCaptureDevicePositionBack) {
                    NSLog(@"Device position : back");
                    backCamera = device;
                }
                else {
                    NSLog(@"Device position : front");
                    frontCamera = device;
                }
            }
        }
        //DEnne biten inn i annen kode
        NSError *error = nil;
        AVCaptureDeviceInput *input;
        if(frontFacing){
            input = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
        }else{
            input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
        }
        
        if (!input) {
            NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [session addInput:input];
        //SLUTT BIt I KODE HER
        stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
        [stillImageOutput setOutputSettings:outputSettings];
        
        [session addOutput:stillImageOutput];
        
        [session startRunning];
        
    });
    
  
    
}

- (void) capImage { //method to capture image from AVCaptureSession video feed
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        
        if (videoConnection) {
            break;
        }
    }
    
    NSLog(@"about to request a capture from: %@", stillImageOutput);
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        if (imageSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];

            imgTaken = [UIImage imageWithData:imageData];
            CGRect cropRect = CGRectMake(0 ,0 ,480 ,640);
            UIGraphicsBeginImageContextWithOptions(cropRect.size, self.view, 1.0f);
            [imgTaken drawInRect:cropRect];
            UIImage * customScreenShot = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        NSData* data = UIImagePNGRepresentation(customScreenShot);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [feedController sendImageToServer:data];
                
                
            });
            //UIImage *imgTaken = [UIImage imageWithData:imageData];
            
           //[feed removeObjectAtIndex:0];
     
            [session stopRunning];
            [captureVideoPreviewLayer removeFromSuperlayer];
           _tableView.scrollEnabled = YES;
             self.cancelButton.hidden = YES;
           [_tableView reloadData];
            //[self processImage:[UIImage imageWithData:imageData]];
        }

    }];
}

-(void)takingPhotoIsDone{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _tableView.scrollEnabled = YES;
        
        cameraIsShown = false;
    
        //shouldExpand = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.cancelButton.hidden = YES;
            if(_statusButtonHorizontalSpace.constant != horizontalSpaceDefault){
                [UIView animateWithDuration:0.3f
                                      delay:0.0f
                                    options: UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     
                                     _statusButtonHorizontalSpace.constant = horizontalSpaceDefault;
                                     [self.view layoutIfNeeded];
                                 }
                                 completion:^(BOOL finished){
                                     [self removeCameraView];
                                 }];
                [_tableView reloadData];
                
            }
        });
        
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [session stopRunning];
        [captureVideoPreviewLayer removeFromSuperlayer];
    });
    
}
-(void)removeCameraView{
    shouldExpand = NO;
    [UIView animateWithDuration:0.2f
                          delay:0.7f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         //swish out
                         CGRect frame = currentCell.frame;
                         //frame.origin.y -= frame.size.height;
                         //currentCell.frame = frame;
                         CGRect frame2 = _tableView.frame;
                         frame2.origin.y -= frame.size.height;
                         frame2.size.height += frame.size.height;
                         _tableView.frame = frame2;
                     }
                     completion:^(BOOL finished){
                         [feed removeObjectAtIndex:0];
                         CGRect frame = currentCell.frame;
                         CGRect frame2 = _tableView.frame;
                         frame2.origin.y += frame.size.height;
                         frame2.size.height -= frame.size.height;
                         _tableView.frame = frame2;
                         [self.tableView reloadData];
                         [currentCell tickImage].hidden = YES;
                         [currentCell tickImage].alpha = 0.0;
                         currentCell = nil;
                         currentCellsIndexPath = nil;
                     }];

}


@end
