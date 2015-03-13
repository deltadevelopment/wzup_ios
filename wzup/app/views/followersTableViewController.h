//
//  followersTableViewController.h
//  wzup
//
//  Created by Simen Lie on 11/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface followersTableViewController : UITableViewController
-(void)setFollowers:(NSMutableArray*) theFollowers withBool:(bool) isFollower;
@end
