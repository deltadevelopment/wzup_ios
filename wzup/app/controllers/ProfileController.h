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
-(void)initFollowers;
-(void)initFollowing;
@end
