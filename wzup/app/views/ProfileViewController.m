//
//  ProfileViewController.m
//  wzup
//
//  Created by Simen Lie on 26/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileController.h"


@interface ProfileViewController ()

@end

@implementation ProfileViewController
ProfileController *profileController;
StatusModel *status;
NSUInteger NumberOfFollowers;
NSUInteger NumberOfFollowings;
bool isExpanded = YES;
bool isOwnProfile = YES;
- (void)viewDidLoad {
    isExpanded = YES;
    [super viewDidLoad];
    [self showTopBar];

    profileController = [[ProfileController alloc] init];
    [self attachToGUI];
    if(isOwnProfile){
        [self getData];
    }
    [self updateGUI];
    [self attachGestures];
    
    // Do any additional setup after loading the view.
}

-(void)setOwnProfile:(bool) isProfile{
    isOwnProfile = isProfile;
}
-(void)attachGestures{
    UITapGestureRecognizer *tapGr;
    tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGr.numberOfTapsRequired = 1;
    [self.expandArea addGestureRecognizer:tapGr];
}

-(void)attachToGUI{
    NSLog(@"ATTCH");
    if(isOwnProfile){
        [self updateGUIForOwnProfile];
    }else{
        [self updateGUIForOthersProfile];
    }
    self.profileImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", @"testBilde.jpg"]];
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
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(subscribeAction:)];
    [self.notifications addGestureRecognizer:singleFingerTap];


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

}

- (void)subscribeAction:(UITapGestureRecognizer *)recognizer {
    NSLog(@"subscribing");
    //Subscribe implementation here
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
    status = [profileController getUser];
    [profileController initFollowers];
    [profileController initFollowing];
    NumberOfFollowers = [profileController getNumberOfFollowers];
    NumberOfFollowings = [profileController getNumberOfFollowing];
}
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



-(void)getMedia{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    dispatch_async(queue, ^{
        UIImage *image = [UIImage imageWithData:[status getMedia]];
        image = [self getCroppedImage:image];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.statusImage setBackgroundColor:[UIColor colorWithPatternImage:image]];
        });
    });
}

-(void)setProfile:(StatusModel* ) statusProfile{
    //NSLog(@"profilename is %@", profilename);
    //_testLabel.text = profilename;
    isOwnProfile = NO;
       NSLog(@"called2");
    status = statusProfile;
    //[_testLabel setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleTap:(UITapGestureRecognizer *) sender{
    
    if(!isExpanded){
        [self animate:269];
    }else{
        [self animate:-269];
    }
    isExpanded = isExpanded == YES ? NO : YES;
}

-(void)animate:(NSInteger) constant{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         //swish out
                         self.expandHeight.constant += constant;
                         self.expandView.constant += constant;
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
- (IBAction)followAction:(id)sender {
    
    NSLog(@"follow");
}
@end
