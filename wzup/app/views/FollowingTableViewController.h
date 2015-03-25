//
//  FollowingTableViewController.h
//  wzup
//
//  Created by Simen Lie on 24/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowingTableViewController : UITableViewController
-(void)setFollowings:(NSMutableArray*) theFollowings withBool:(BOOL)wasOwnProfile;
@end
