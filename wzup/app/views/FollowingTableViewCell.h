//
//  FollowingTableViewCell.h
//  wzup
//
//  Created by Simen Lie on 24/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
- (IBAction)followAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
-(void) attachToGUI;
@end
