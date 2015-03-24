//
//  FollowingTableViewCell.m
//  wzup
//
//  Created by Simen Lie on 24/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "FollowingTableViewCell.h"

@implementation FollowingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)followAction:(id)sender {
    
}

-(void) attachToGUI {
    self.profilePicture.layer.cornerRadius = 25;
    self.profilePicture.clipsToBounds = YES;
    [[self.followButton layer] setBorderWidth:1.0f];
    [[self.followButton layer] setBorderColor:[UIColor colorWithRed:0.557 green:0.267 blue:0.678 alpha:1].CGColor];
}

@end
