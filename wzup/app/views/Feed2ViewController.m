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
- (void)viewDidLoad {
    
    authHelper = [[AuthHelper alloc] init];
    self.availabilityView.alpha = 0.0;
    [super viewDidLoad];
    horizontalSpaceDefault = self.statusButtonHorizontalSpace.constant;
    screenBound = [[UIScreen mainScreen] bounds];
    screenSize = screenBound.size;
    screenWidth = screenSize.width;
    self.statusButton.layer.cornerRadius = 25;
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
    
    [self fadeInAvailabilityView];
    UILabel *label = (UILabel *)gesture.view;
    CGPoint translation = [gesture translationInView:label];
    float newX = _statusButtonHorizontalSpace.constant;
    
    //NSLog(@"gesture point %f",  translation.x);
    if(newX > 150){
        //Change availability
        self.availabilityView.backgroundColor = [UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1];
        _statusText.text = unAvailableText;
    }else{
        //Change availability
        
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
    }
    else{
      [gesture setTranslation:CGPointZero inView:label];
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
    CGPoint tapLocation = [sender locationInView:self.tableView];
    NSIndexPath *tapIndexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
    
    
    ProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    StatusModel *statusmodel = [feed objectAtIndex:tapIndexPath.row];
    [vc setProfile:[statusmodel getBody]];
    // OR myViewController *vc = [[myViewController alloc] init];
    
    // any setup code for *vc
    
    [self.navigationController pushViewController:vc animated:YES];
    // do any setup you need for myNewVC
    
    
}

- (void)refresh:(UIRefreshControl *)refreshControl {
   
    [feed removeObjectAtIndex:0];
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
       
        cell.nameLabel.text = [[status getUser] getUsername];
        if([[status getUser] getId ] == [[authHelper getUserId] intValue]){
            NSLog(@"------------auth: %@ model: %d", [authHelper getUserId ], [[status getUser] getId ]);
            if(imgTaken == nil && cameraIsShown){
                shouldExpand = true;
                indexCurrent = indexPath;
                [cell.statusImage setBackgroundColor:nil];
                [self initializeCamera:cell.statusImage];
              
            }
           
        }
        cell.profilePicture.image = [UIImage imageNamed:[status getImgPath]];
        //NSLog([status getImgPath]);
        cell.statusImg = [status getImgPath];
      
        CGSize size = CGSizeMake(screenWidth, 500);
        UIImage * image = [UIImage imageNamed:[status getImgPath]];
        image = [self imageByScalingAndCroppingForSize:size img:image];
        //[cell.statusImage setBackgroundColor:[UIColor colorWithPatternImage:nil]];
        NSLog(@"--IMG setting %@", [status getImgPath]);
        [cell.statusImage setBackgroundColor:[UIColor colorWithPatternImage:image]];
        [cell setAvailability:[[status getUser] getAvailability]];
        if(imgTaken != nil){
             if([[status getUser] getId ] == [[authHelper getUserId] intValue]){
               
                shouldExpand = false;
               // session.stopRunning;
                 
                [cell.statusImage setBackgroundColor:[UIColor colorWithPatternImage:[self imageByScalingAndCroppingForSize:size img:imgTaken]]];
            }
            
        }
    }
   
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    //NSLog(@"row for height");
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



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)path
// or it must be some other method
{
    
    NSIndexPath *oldIndex = indexCurrent;
    
    indexCurrent = path;

    if(indexCurrent == oldIndex){
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
       imgTaken = nil;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                [UIView animateWithDuration:0.3f
                                      delay:0.0f
                                    options: UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     
                                     _statusButtonHorizontalSpace.constant += 130;
                                     [self.view layoutIfNeeded];
                                 }
                                 completion:^(BOOL finished){
                                     
                                 }];
            });
            
        });
        
       
        StatusModel *tempStatus = [feed objectAtIndex:0];
         if([[tempStatus getUser] getId ] == [[authHelper getUserId] intValue]){
         
         }else{
             StatusModel *status = [[StatusModel alloc] init];
             UserModel *user = [[UserModel alloc] init];
             [user setUsername:@"simenlie"];
             [user setId:[[authHelper getUserId] intValue]];
             [status setUser:user];
             
             [feed insertObject:status atIndex:0];
         }
     
        [self.tableView reloadData];
        cameraIsShown = YES;
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
    captureVideoPreviewLayer.frame = cameraView.bounds;

    [cameraView.layer addSublayer:captureVideoPreviewLayer];

    
    UIView *view = cameraView;
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CGRect bounds = [view bounds];
        [captureVideoPreviewLayer setFrame:bounds];
        
        NSArray *devices = [AVCaptureDevice devices];
        AVCaptureDevice *frontCamera;
        AVCaptureDevice *backCamera;
        
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
        
        
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
        if (!input) {
            NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [session addInput:input];
        
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
            //UIImage *imgTaken = [UIImage imageWithData:imageData];
            imgTaken = [UIImage imageWithData:imageData];
           //[feed removeObjectAtIndex:0];
            [session stopRunning];
            [captureVideoPreviewLayer removeFromSuperlayer];
            [_tableView reloadData];
            
            //[self processImage:[UIImage imageWithData:imageData]];
        }

    }];
}



@end
