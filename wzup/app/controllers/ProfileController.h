//
//  ProfileController.h
//  wzup
//
//  Created by Simen Lie on 09/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationController.h"
#import "UserModel.h"
#import "StatusModel.h"
#import "FollowModel.h"
@interface ProfileController : ApplicationController
-(StatusModel*)getUser;

-(NSMutableArray*)getFollowers;
-(NSMutableArray*)getFollowing;
-(NSUInteger)getNumberOfFollowers;
-(NSUInteger)getNumberOfFollowing;
-(void)initFollowingWithUserId:(NSString*) Id;
-(void)initFollowersWithUserId:(NSString*) Id;
-(void)initFollowers;
-(void)initFollowing;
-(void)unfollowUserWithUserId:(NSString *) userId;
-(void)followUserWithUserId:(NSString *) userId;
@end
