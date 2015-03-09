//
//  ProfileViewController.h
//  wzup
//
//  Created by Simen Lie on 26/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "StatusModel.h"
@interface ProfileViewController : MainViewController
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIView *pointsIndicator;
@property (weak, nonatomic) IBOutlet UIView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *statusTextLabel;
@property (weak, nonatomic) IBOutlet UIView *expandArea;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expandHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expandView;
-(void)setProfile:(StatusModel* ) statusProfile;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (weak, nonatomic) IBOutlet UIView *hotness;
@property (weak, nonatomic) IBOutlet UIView *followers;
@property (weak, nonatomic) IBOutlet UIView *following;
@property (weak, nonatomic) IBOutlet UIView *notifications;
@property (weak, nonatomic) IBOutlet UIView *bottomBarInfo;
@property (weak, nonatomic) IBOutlet UILabel *degreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *availability;
-(void)setOwnProfile:(bool) isProfile;
@end
