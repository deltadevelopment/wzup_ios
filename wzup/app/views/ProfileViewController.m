//
//  ProfileViewController.m
//  wzup
//
//  Created by Simen Lie on 26/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileController.h"
#import "followersTableViewController.h"
#import "MediaHelper.h"
#import "UIHelper.h"



@interface ProfileViewController ()

@end
static int const EXPAND_SIZE = 540;
static int const DESPAND_SIZE = 211;
@implementation ProfileViewController
ProfileController *profileController;
StatusModel *status;
NSUInteger NumberOfFollowers;
NSUInteger NumberOfFollowings;
bool isExpanded;
bool isOwnProfile = YES;
bool isFollowee;
bool isPlaying;
MediaHelper *mediaHelper;
MPMoviePlayerController *player;
- (void)viewDidLoad {
    mediaHelper = [[MediaHelper alloc]init];
    /*
    [mediaHelper initaliseVideo];
    //YES == front camera
    [mediaHelper CameraToggleButtonPressed:YES];
     [mediaHelper StartStopRecording];
     [NSTimer scheduledTimerWithTimeInterval:4.0
     target:self
     selector:@selector(stopRecording)
     userInfo:nil
     repeats:NO];
     */
    isExpanded = NO;
    [super viewDidLoad];
    [self showTopBar];
    self.playButton.hidden = YES;
    profileController = [[ProfileController alloc] init];
    [self attachToGUI];
    
    if(isOwnProfile){
        [self getData];
    }
   
   
}

#pragma mark - gesture delegate
// this allows you to dispatch touches
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}
// this enables you to handle multiple recognizers on single view
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


-(void)initMedia{
    SEL mediaDone = @selector(mediaIsDownloaded:);
    [status getMedia:self withSelector:mediaDone withObject:self];
}
-(void)stopRecording{
    [mediaHelper StartStopRecording];

}

- (IBAction)playVideo:(id)sender {
    if(player != nil){
        if(isPlaying){
            isPlaying = NO;
            [player stop];
            [player.view removeFromSuperview];
        }else{
            isPlaying = YES;
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(moviePlayBackDidFinish:)
                                                         name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:player];
            
         
            //[self.statusImage addSubview:player.view];
            [self.statusImage insertSubview:player.view belowSubview:self.bottomBar];
            UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPlayerTapped:)];
            singleFingerTap.numberOfTapsRequired = 1;
            singleFingerTap.delegate = self;
            [player.view addGestureRecognizer:singleFingerTap];
            [player play];
        }
    }
}

-(void)setOwnProfile:(bool) isProfile{
    isOwnProfile = isProfile;
}
-(void)attachGestures{
    UITapGestureRecognizer *tapGr;
    tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGr.numberOfTapsRequired = 1;
    //tapGr.delegate = self;
    [self.expandArea addGestureRecognizer:tapGr];
    
    UITapGestureRecognizer *followerstapGr;
    followerstapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFollowers:)];
    followerstapGr.numberOfTapsRequired = 1;
    [self.showFollowersView addGestureRecognizer:followerstapGr];
    
    UITapGestureRecognizer *followingtapGr;
    followingtapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFollowing:)];
    followingtapGr.numberOfTapsRequired = 1;
    [self.showFollowingView addGestureRecognizer:followingtapGr];

    
}

-(void)attachToGUI{
    NSLog(@"ATTCH");
    if(isOwnProfile){
        [self updateGUIForOwnProfile];
    }else{
        [self updateGUIForOthersProfile];
    }
   // self.profileImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", @"testBilde.jpg"]];
    self.profileImage.layer.cornerRadius = 25;
    self.profileImage.clipsToBounds = YES;
    self.availability.layer.cornerRadius = 5;
    self.availability.clipsToBounds = YES;
    
    self.bottomBar.alpha = 0.9f;
    [self.nameLabel sizeToFit];
    
    //self.hotness.layer.borderWidth = 1;
    //self.followers.layer.borderWidth = 1;
    //self.following.layer.borderWidth = 1;
    //self.notifications.layer.borderWidth = 1;
   // [self setBorder:self.hotness];
    [self setBorder:self.followers];
    [self setBorder:self.following];
    [self setBorder:self.notifications];
    [self setBorderTopBottom:self.hotness];
    self.degreeLabel.textColor = [UIColor colorWithRed:0.204 green:0.596 blue:0.859 alpha:1];
    self.pointsIndicator.backgroundColor = [UIColor colorWithRed:0.204 green:0.596 blue:0.859 alpha:1];
}

-(void)updateGUIForOwnProfile{
    self.settingsButton.alpha = 0.5f;
    self.searchButton.hidden = NO;
    self.notificationsLabel.hidden = YES;
    self.subscribeText.hidden = YES;
    self.followView.hidden = YES;
    

}
-(void)updateGUIForOthersProfile{
    self.searchButton.hidden = YES;
    self.notificationsLabel.hidden = NO;
    self.subscribeText.hidden = NO;
    [self.settingsButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", @"testBilde.jpg"]] forState:UIControlStateNormal];
    self.followView.hidden = NO;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(subscribeAction:)];
    [self.notifications addGestureRecognizer:singleFingerTap];
    
    UITapGestureRecognizer *followTapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(followAction:)];
    [self.followView addGestureRecognizer:followTapGesture];
    self.followButtonText.text = [[status getUser] isFollowee] ? @"Unfollow" :@"Follow";
}

- (void)subscribeAction:(UITapGestureRecognizer *)recognizer {
    NSLog(@"subscribing");
    //Subscribe implementation here
}

- (void)followAction:(UITapGestureRecognizer *)recognizer {
    NSString* userId = [NSString stringWithFormat:@"%d", [[status getUser] getId]];
    [[status getUser] isFollowee] ? [profileController unfollowUserWithUserId:userId] : [profileController followUserWithUserId:userId];
}

-(void)setBorder:(UIView *) view{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, 0.0f, 1, 70);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    [view.layer addSublayer:bottomBorder];

}

-(void)setBorderTopBottom:(UIView *) view{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, 0.0f, [self getSize].width, 1);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                                       alpha:1.0f].CGColor;
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 69.0f, [self getSize].width, 1);
    topBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                                    alpha:1.0f].CGColor;
    [view.layer addSublayer:topBorder];
   [view.layer addSublayer:bottomBorder];
}

-(void)getData{
    [profileController requestUser:self withSuccess:@selector(userWasReturned:) withError:@selector(userWasNotReturned:)];
    [profileController initFollowers:self withSuccess:@selector(followersWasReturned:) withError:@selector(followersWasNotReturned:)];
    [profileController initFollowing:self withSuccess:@selector(followingWasReturned:) withError:@selector(followingWasNotReturned:)];
}
-(void)refreshGUI{
    [self updateGUI];
    [self attachGestures];
    [self initMedia];
}

#pragma --CALLBACKS--

#pragma success
-(void)userWasReturned:(NSData *) data{
    status = [profileController getUser:data];
    [self refreshGUI];
}

-(void)followersWasReturned:(NSData*) data{
    [profileController getFollowers:data];
    NumberOfFollowers = [profileController getNumberOfFollowers];
    [self refreshGUI];
}

-(void)followingWasReturned:(NSData *) data{
    [profileController getFollowing:data];
    NumberOfFollowings = [profileController getNumberOfFollowing];
    [self refreshGUI];
}

#pragma error
-(void)userWasNotReturned:(NSError *) error{
    
}

-(void)followersWasNotReturned:(NSError*) error{
    
}

-(void)followingWasNotReturned:(NSError *) error{
    
}
#pragma --GUI--

-(void)updateGUI{
    self.nameLabel.text =[[status getUser] getDisplayName];
    [self getMedia];
    self.statusTextLabel.text = [status getBody];
    [self updateAvailability:[[status getUser] getAvailability]];
    self.followersLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)NumberOfFollowers];
    self.followingLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)NumberOfFollowings];
}

-(void)updateAvailability:(NSInteger) available{
    //NSLog(@"%i", (int)av);
    if(available == 0){
        //available
        [self.availability setBackgroundColor:[UIColor colorWithRed:0.18 green:0.8 blue:0.443 alpha:1]];
    }
    else if(available == 1){
        //Busy
        [self.availability setBackgroundColor:[UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1] ];
    }
    else if(available == 2){
        [self.availability setBackgroundColor:[UIColor colorWithRed:0.741 green:0.765 blue:0.78 alpha:1]];
        //SNOOZE
    }
    
}

-(void)mediaIsDownloaded:(NSObject *) object{
    if([[status getMediaType] intValue] == 1){
        UIImage *image = [UIImage imageWithData:[status getMedia]];
        image = [self getCroppedImage:image];
        
        [self.statusImage setBackgroundColor:[UIColor colorWithPatternImage:image]];
        
    }else{
        [self getVideo];
    }
}
-(void)getMedia{

}

-(void)getVideo{
    NSData *data = [status getMedia];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"MyFile.mov"];
    [data writeToFile:appFile atomically:YES];
    NSURL *movieUrl = [NSURL fileURLWithPath:appFile];
  
    //NSString *dataString = [[NSString alloc] initWithData:[status getMedia] encoding:NSUTF8StringEncoding];
    NSLog(@"video: %@",@"mdia is downloaded");
    //NSURL *url = [NSURL URLWithString:dataString];
    player = [[MPMoviePlayerController alloc] initWithContentURL:movieUrl];
    [UIHelper initialize];
    player.view.frame = [UIHelper getFrame];
    //NSLog(@"video: %@",[status getMediaUrl]);
    player.movieSourceType = MPMovieSourceTypeFile;
    player.controlStyle = MPMovieControlStyleNone;

    
    AVAsset *asset = [AVAsset assetWithURL:movieUrl];
    
    //  Get thumbnail at the very start of the video
    CMTime thumbnailTime = [asset duration];
    thumbnailTime.value = 0;
    
    //  Get image from the video at the given time
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;

    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:thumbnailTime actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    [self.statusImage setBackgroundColor:[UIColor colorWithPatternImage:thumbnail]];
}

-(void)playMovie
{
    NSData *data = [status getMedia];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"MyFile.mov"];
    [data writeToFile:appFile atomically:YES];
    NSURL *movieUrl = [NSURL fileURLWithPath:appFile];
    MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:movieUrl];
    
    
    mp.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [self.statusImage addSubview:mp.view];
    [mp.moviePlayer play];
    //[self presentMoviePlayerViewControllerAnimated:mp];
}

-(void)quitVideo:(UITapGestureRecognizer *) sender{
    NSLog(@"wquit");
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
    [self despand];
    isExpanded = NO;
    
}


- (void)onPlayerTapped:(UITapGestureRecognizer *) sender
{
    isPlaying = NO;
    [player stop];
    [player.view removeFromSuperview];
    [self despand];
    isExpanded = NO;

}


-(void)setProfile:(StatusModel* ) statusProfile{
    isOwnProfile = NO;
    status = statusProfile;
    NSString* userId = [NSString stringWithFormat:@"%d", [[status getUser] getId]];
    profileController  = [[ProfileController alloc] init];
    [profileController initFollowersWithUserId:userId withObject:self withSuccess:@selector(followersWasReturned:) withError:@selector(followersWasNotReturned:)];
    [profileController initFollowingWithUserId:userId withObject:self withSuccess:@selector(followingWasReturned:) withError:@selector(followingWasNotReturned:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleTap:(UITapGestureRecognizer *) sender{
    NSLog(@"tapped");
    if(!isExpanded){
        //[self animate:269];
        [self expand];
    }else{
        [self despand];
    }
    [self playVideo:nil];
    isExpanded = isExpanded == YES ? NO : YES;
}

-(void)showFollowers:(UITapGestureRecognizer *) sender{
    NSLog(@"showFolloers");
    followersTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"followers"];
    NSLog(@"length %lu", (unsigned long)[[profileController getFollowers] count]);
    [vc setFollowers:[profileController getFollowers] withBool:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showFollowing:(UITapGestureRecognizer *) sender{
    NSLog(@"showFolloers");
    followersTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"followers"];
    //NSLog(@"length %lu", (unsigned long)[[profileController getFollowers] count]);
    [vc setFollowers:[profileController getFollowing] withBool:NO];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)expand{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         //swish out
                         self.expandHeight.constant = EXPAND_SIZE;
                         self.expandView.constant = EXPAND_SIZE;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    
}

-(void)despand{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         //swish out
                         self.expandHeight.constant = DESPAND_SIZE;
                         self.expandView.constant = DESPAND_SIZE;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         
                         
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

- (IBAction)showSearch:(id)sender {
}

@end
