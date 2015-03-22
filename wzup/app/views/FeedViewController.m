//
//  Feed2ViewController.m
//  wzup
//
//  Created by Simen Lie on 26.02.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedTableViewCell.h"
#import "FeedController.h"
#import "StatusModel.h"
#import "UserModel.h"
#import "AuthHelper.h"
#import "StartViewController.h"
#import "ProfileViewController.h"
#import "ApplicationHelper.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "MediaHelper.h"
#import "CircleIndicator.h"
@interface FeedViewController ()

@end
static int const EXPAND_SIZE = 549;
@implementation FeedViewController{
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
    CGFloat horizontalSpaceDefaultIndicator;
    ApplicationHelper *applicationHelper;
    bool availabilityFadeHasStarted;
    NSString* availableText;
    NSString* unAvailableText;
    bool cameraIsShown;
    AVCaptureStillImageOutput * stillImageOutput;
    UIImage *imgTaken;
    AVCaptureSession *session;
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
    FeedTableViewCell *currentCell;
    FeedTableViewCell *cameraCell;
    FeedTableViewCell *userCell;
    NSIndexPath *currentCellsIndexPath;
    NSNumber *available;
    bool frontFacing;
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    UITapGestureRecognizer *flipCameratapGr;
    MediaHelper *mediaHelper;
    CircleIndicator *circleIndicator;
    NSTimer *recordTimer;
    bool hasStoppedRecording;
    MPMoviePlayerController *player;
    bool isPlaying;
    UIRefreshControl *refreshControl;
    
}


- (void)viewDidLoad {
        [super viewDidLoad];
    NSLog(@"------tre--------");
    authHelper = [[AuthHelper alloc] init];
    mediaHelper = [[MediaHelper alloc] init];
    [mediaHelper setMediaDoneSelector:@selector(mediaIsUploaded:) withObject:self];
    self.availabilityView.alpha = 0.0;

    [self showTopBar];
    horizontalSpaceDefault = self.statusButtonHorizontalSpace.constant;
     horizontalSpaceDefaultIndicator = self.indicatorHorizontalSpace.constant;
    screenBound = [[UIScreen mainScreen] bounds];
    screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    self.statusButton.layer.cornerRadius = 25;
    //self.cancelButton.layer.cornerRadius = 25;
    self.cancelButton.hidden = YES;
    self.availabilityView.hidden = YES;
    self.availabilityView.backgroundColor = [UIColor colorWithRed:0.18 green:0.8 blue:0.443 alpha:1];
    refreshControl = [[UIRefreshControl alloc] init];
        self.indicator.hidden = YES;
    
    refreshControl.backgroundColor = [UIColor colorWithRed:0.204 green:0.596 blue:0.859 alpha:1];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(refreshFeed) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    [self startRefreshing];

    
    // Do any additional setup after loading the view.
    feedController = [[FeedController alloc] init];
    applicationHelper = [[ApplicationHelper alloc] init];
    [applicationHelper addAvailableTexts];
    [applicationHelper addUnAvailableTexts];

    
    
    [self getFeed];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
               // feed = [feedController getFeed];
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
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(recordVideo:)];
    [longGesture setMinimumPressDuration:1];
    [_statusButton addGestureRecognizer:longGesture];
    
    
}

-(void)startRefreshing{

    if (self.tableView.contentOffset.y == 0) {
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
            
            self.tableView.contentOffset = CGPointMake(0, -refreshControl.frame.size.height);
            
        } completion:^(BOOL finished){
            
        }];
        
    }
        [refreshControl beginRefreshing];
}


-(void)getFeed{
    [feedController requestFeed:self withSuccess:@selector(feedRecieved:) withError:@selector(feedNotRecieved:)];
}

-(void)refreshFeed{
    [feedController requestFeed:self withSuccess:@selector(feedRecievedFromRefresh:) withError:@selector(feedNotRecieved:)];
}

-(void)feedRecievedFromRefresh:(NSData*) data{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    refreshControl.attributedTitle = attributedTitle;
    [self feedRecieved:data];

}

-(void)feedRecieved:(NSData*) data{
     [refreshControl endRefreshing];
    feed = [feedController getFeed:data];
    [self.tableView reloadData];
    NSLog(@"count: %lu", (unsigned long)[feed count]);
    NSLog(@"Feed recieved");
}

-(void)feedNotRecieved:(NSError *)error{
    NSLog([error localizedDescription]);
}


- (IBAction)cancelStatus:(id)sender {
    NSLog(@"Canceling");
       [self takingPhotoIsDone];
}

-(void)imageIsUploaded{
    NSLog(@"MEDIA SUCCESS IMAGE");
    
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
                             _indicatorHorizontalSpace.constant = horizontalSpaceDefaultIndicator;
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
        float newX2 = _indicatorHorizontalSpace.constant;
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
                _indicatorHorizontalSpace.constant = newX2;
            }
            else {
                _statusButtonHorizontalSpace.constant -= translation.x;
                _indicatorHorizontalSpace.constant -= translation.x;
            }
        }
        else{
            //CHECK right
            if(newX <= 16){
                newX = 16;
                _statusButtonHorizontalSpace.constant = newX;
                      _indicatorHorizontalSpace.constant = newX2;
            }
            else {
                _statusButtonHorizontalSpace.constant -= translation.x;
                      _indicatorHorizontalSpace.constant -= translation.x;
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
            [feedController updateAvailability:available withObject:self withSuccess:@selector(availabilityWasSet:) withError:@selector(availabilityWasNotSet:)];
           // [feedController updateAvailability:available];
        }
        else{
            [gesture setTranslation:CGPointZero inView:label];
        }
    }
  

}

-(void)availabilityWasSet:(NSData * ) data{

}
-(void)availabilityWasNotSet:(NSError * ) error{
    
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
/*
- (void)refresh:(UIRefreshControl *)refreshControl {
    if([feed count] > 0){
    [feed removeObjectAtIndex:0];
    }
    
    feed = [feedController getFeed];
    indexCurrent = nil;
    [self.tableView reloadData];
    [self checkErrors];
    //[refreshControl endRefreshing];

    
}
-(void)checkErrors{
    if([feedController hasError]){
        StartViewController*startController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"startNav"];
        [self presentModalViewController:startController animated:YES];
    };
 } 
 
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [feed count];
}
-(void)initMedia:(NSIndexPath *) indexPath withStatus:(StatusModel *) status withCell:(FeedTableViewCell *) cell{
    if([status getMedia] == nil){
        [status getMedia:self withSelector:@selector(mediaIsDownloaded:) withObject:indexPath];
    }
    else{
        [cell stopImageLoading];
        if([[status getMediaType] intValue] == 1){
            NSLog(@"setter bilde for %@", [[status getUser]getDisplayName]);
            [cell.statusImage setBackgroundColor:[UIColor colorWithPatternImage:[status getCroppedImage]]];
            
        }else{
            [cell.statusImage setBackgroundColor:[UIColor colorWithPatternImage:[cell getThumbnail]]];
        }
    }
}

-(void)mediaIsDownloaded:(NSIndexPath *) indexPath{
    NSLog(@"-----------________indexPATH = %ld", (long)indexPath.row);
    StatusModel *status = [feed objectAtIndex:indexPath.row];
    FeedTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell stopImageLoading];
    if([[status getMediaType] intValue] == 1){
        UIImage *image = [UIImage imageWithData:[status getMedia]];
        image = [self getCroppedImage:image];
        [status setCroppedImage:image];
        //self.playButton.hidden = YES;
        NSLog(@"setter bilde for %@", [[status getUser]getDisplayName]);
        [cell.statusImage setBackgroundColor:[UIColor colorWithPatternImage:image]];
        
    }else{
        [self getVideo:indexPath];
        //[self playVideo:cell];
    }
}

-(void)getVideo:(NSIndexPath *) indexPath{
    StatusModel *status = [feed objectAtIndex:indexPath.row];
    FeedTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSData *data = [status getMedia];
    [cell getVideo:data];

}


- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    isPlaying = NO;
    [player stop];
    [player.view removeFromSuperview];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //NSLog(@"cell creation");
    static NSString *CellIdentifier = @"customCell";
    FeedTableViewCell *cell = (FeedTableViewCell  *)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    //cell=nil;
    if(cell == nil){
        cell = [[FeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customCell"];
        NSLog(@"cell iS NULL----");
    }

    if([feed count] != 0){
        
   
  
        
  
        UITapGestureRecognizer *tapGr;
        tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapGr.numberOfTapsRequired = 1;
        [[cell getTopBar] addGestureRecognizer:tapGr];
        StatusModel *status = [feed objectAtIndex:indexPath.row];
        [cell.statusImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", @"status-icon2.png"]]]];
        
        [self initMedia:indexPath withStatus:status withCell:cell];
        
        
        
                
        cell.statusLabel.text = [status getBody];
        
        
        //SEL setImageSelector = @selector(setMediaToCell:);
        //[status getMedia:self withSelector:setImageSelector withObject:cell];
        
        
        
        
        cell.nameLabel.text = [[status getUser] getDisplayName];
        if([[status getUser] getId ] == [[authHelper getUserId] intValue]){
            //[feedController setLoading:[cell uploadImageIndicatorLabel]];
           // [feedController setImageDone:[cell tickImage]];
            //[feedController setSelector:littleSelector withObject:self];
            
            
            cell.statusLabel.text = @"";
            
         
            //Init tap gesture
            UITapGestureRecognizer *tapGr;
            tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addCaption:)];
            tapGr.numberOfTapsRequired = 1;
            [[cell bottomBar] addGestureRecognizer:tapGr];
            
            
            NSLog(@"------------auth: %@ model: %d", [authHelper getUserId ], [[status getUser] getId ]);
            if(imgTaken == nil && cameraIsShown){
                NSLog(@"visier kam");
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
      
        CGSize size = CGSizeMake(screenWidth, EXPAND_SIZE);
    
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        
        dispatch_async(queue, ^{
            UIImage * image = [[UIImage alloc] init];
            if([status getMedia] == nil){
                image =  [UIImage imageNamed:@"status-icon2.png"];
            }else{
                image = [UIImage imageWithData:[status getMedia]];
                
                //image =  [UIImage imageNamed:@"testBilde.jpg"];
            }
            //image = [self imageByScalingAndCroppingForSize:size img:image];
            dispatch_sync(dispatch_get_main_queue(), ^{
                if(hasStoppedRecording){
                    if([[status getUser] getId ] == [[authHelper getUserId] intValue]){
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
                        
                        //[cell.statusImage setBackgroundColor:[UIColor colorWithPatternImage:[self imageByScalingAndCroppingForSize:size img:imgTaken]]];
                    }
                  
                }
                
               // [cell.statusImage setBackgroundColor:[UIColor colorWithPatternImage:image]];
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
/*
-(void)setMediaToCell:(FeedTableViewCell *)cell{
    NSLog(@"-------MEDIA TO CELL______");
    CGSize size = CGSizeMake(screenWidth, EXPAND_SIZE);
    NSLog(@"setting media");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    StatusModel *status = [feed objectAtIndex:indexPath.row];
    NSLog(@"media is downloaded here ---");
    UIImage * image = [[UIImage alloc] init];
    [cell stopImageLoading];
    if([status getMedia] == nil){
        image =  [UIImage imageNamed:@"status-icon2.png"];
    }else{
        image = [UIImage imageWithData:[status getMedia]];
    }
    image = [self imageByScalingAndCroppingForSize:size img:image];
    if([[status getMediaType] integerValue] == 1){
     [cell.statusImage setBackgroundColor:[UIColor colorWithPatternImage:image]];
    }
   
}
*/
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
        return EXPAND_SIZE;
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

-(void)statusWasSaved:(NSData *) data{

}

-(void)statusWasNotSaved:(NSError *) error{
    
}

-(void) saveStatus{
    NSString *status = [currentCell editStatusTextField].text;
    [currentCell editStatusTextField].hidden = YES;
    [currentCell statusLabel].text = status;
    [feedController updateStatus:status withObject:self withSuccess:@selector(statusWasSaved:) withError:@selector(statusWasNotSaved:)];
   // [feedController updateStatus:status];
   
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
    
    StatusModel *status = [feed objectAtIndex:path.row];
    if([[status getMediaType] intValue] != 1){
        FeedTableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
        if(shouldExpand){
            [cell playVideo];
        }else{
            [cell stopVideo];
        }
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

-(void)decrementSpin{
    [circleIndicator incrementSpin];
    if(circleIndicator.percent == 100){
        //STOP RECORDING
        [self stopRecording];
    }
}

-(void)stopRecording{
    if(!hasStoppedRecording){
        //NSLog(@"");
        [mediaHelper StartStopRecording];
        [recordTimer invalidate];
        [self closeCamera];
        [circleIndicator removeFromSuperview];
        circleIndicator.percent = 0;
        hasStoppedRecording = YES;
        //shouldExpand = NO;
               _tableView.scrollEnabled = YES;
        self.cancelButton.hidden = YES;
        [_tableView reloadData];
    }
}


-(void)recordVideo:(UILongPressGestureRecognizer *) recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        // Long press detected, start the timer
        if(cameraIsShown){
            NSLog(@"starter filme her");
             hasStoppedRecording = NO;
            circleIndicator = [[CircleIndicator alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
            [self.indicatorView addSubview:circleIndicator];
            [circleIndicator setIndicatorWithMaxTime:2];
            recordTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(decrementSpin) userInfo:nil repeats:YES];
            //YES == front camera
            [session stopRunning];
            [captureVideoPreviewLayer removeFromSuperlayer];
            [mediaHelper setView:cameraCell.statusImage];
            [mediaHelper initaliseVideo];
            [mediaHelper CameraToggleButtonPressed:NO];
            [mediaHelper StartStopRecording];
            
            
        }
        
    }
    
    
    else
    {
        if (recognizer.state == UIGestureRecognizerStateCancelled
            || recognizer.state == UIGestureRecognizerStateFailed
            || recognizer.state == UIGestureRecognizerStateEnded)
        {
            // Long press ended, stop the timer
            if(cameraIsShown){
                [self stopRecording];
            }
        }
    }


}

- (IBAction)addStatus:(id)sender {
    if(!cameraIsShown){
        
        cameraIsShown = YES;
       [feedController requestUpload];
       // [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
                                     _indicatorHorizontalSpace.constant += 130;
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
           [feedController requestUser:self withSuccess:@selector(userWasReturned:) withError:@selector(userWasNotReturned:)];
            UserModel* user = [[UserModel alloc] init];
            user.Id = [[authHelper getUserId] intValue];
            
            StatusModel *status = [[StatusModel alloc] init];
            [status setUser:user];
           
            currentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [feed insertObject:status atIndex:0];
           // userCell = [self.tableView cellForRowAtIndexPath:0];
        }
        
        [self.tableView reloadData];
        NSLog(@"feed was reloaded");
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
                                     _indicatorHorizontalSpace.constant = 6;
                                     [self.view layoutIfNeeded];
                                 }
                                 completion:^(BOOL finished){
                                     
                                 }];
            });
        });
    }
}
-(void)userWasReturned:(NSData *) data{
    UserModel* user = [feedController getUser:data];
    
    StatusModel *status = [feed objectAtIndex:0];
    [status setUser:user];
   // [self.tableView reloadData];

}
-(void)userWasNotReturned:(NSError *) error{
    
}
-(void)closeCamera{
    cameraIsShown = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [UIView animateWithDuration:0.3f
                                  delay:0.0f
                                options: UIViewAnimationOptionCurveLinear
                             animations:^{
                                 
                                 _statusButtonHorizontalSpace.constant = horizontalSpaceDefault;
                                 _indicatorHorizontalSpace.constant = 6;
                                 [self.view layoutIfNeeded];
                             }
                             completion:^(BOOL finished){
                                 
                             }];
        });
    });
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

-(void)mediaIsUploaded:(NSNumber*) percentUploaded{
    NSLog(@"downloaded: %@", percentUploaded);
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    UILabel *loadingLabel = [currentCell uploadImageIndicatorLabel];
    
    if(loadingLabel != nil){
        loadingLabel.hidden = NO;
        double width = ([percentUploaded longLongValue]* screenWidth)/100 ;
        CGRect frame = loadingLabel.frame;
        NSLog(@"%f", width);
        frame.size.width = width;
        loadingLabel.frame = frame;
        [loadingLabel setNeedsDisplay];
    }
    if([percentUploaded  longLongValue] == 100){
        loadingLabel.hidden = YES;
        [feedController SetStatusWithMedia:self withSuccess:@selector(statusIsSuccess:) withError:@selector(statusIsNotSuccess:)];
        
    }
    
    
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
                [feedController setSelector:@selector(mediaIsUploaded:) withObject:self];
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

-(void)imageDownloading:(NSNumber *) percentUploaded{
 
}

-(void)statusIsSuccess:(NSData *) data{
    NSLog(@"Status is set");
      [self imageIsUploaded];
}

-(void)statusIsNotSuccess:(NSError *) error{
    
}

-(void)takingPhotoIsDone{
    
    _tableView.scrollEnabled = YES;
    
    cameraIsShown = false;
    //feed = [feedController getFeed];
    
    self.cancelButton.hidden = YES;
    if(_statusButtonHorizontalSpace.constant != horizontalSpaceDefault){
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             _statusButtonHorizontalSpace.constant = horizontalSpaceDefault;
                             _indicatorHorizontalSpace.constant = 6;
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished){
                             [self removeCameraView];
                         }];
       [_tableView reloadData];
        
    }
    
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
                         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                         FeedTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                         
                         UIImage *image = [UIImage imageWithData:[[feed objectAtIndex:0] getMedia]];
                         image = [self getCroppedImage:image];
                         
                         //self.playButton.hidden = YES;
                         [cell.statusImage setBackgroundColor:[UIColor colorWithPatternImage:image]];
                         
                         
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
