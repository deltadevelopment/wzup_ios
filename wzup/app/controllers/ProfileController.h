//
//  ProfileController.h
//  wzup
//
//  Created by Simen Lie on 09/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationController2.h"
#import "UserModel.h"
#import "StatusModel.h"
#import "FollowModel.h"
@interface ProfileController : ApplicationController2
-(void)requestUser:(NSObject *) view
       withSuccess:(SEL) success
         withError:(SEL) errorAction;

-(StatusModel*)getUser:(NSData *) data;
-(UserModel*)getUserWithUser:(NSData *) data;

-(void)initRequestingFollowers:(NSObject *)view
                   withSuccess:(SEL) success
                     withError:(SEL) errorAction;

-(void)searchForUserByUsername:(NSString *) searchString
                    withObject:(NSObject *)view
                   withSuccess:(SEL) success
                     withError:(SEL) errorAction;

-(void)initFollowers:(NSObject *)view
         withSuccess:(SEL) success
           withError:(SEL) errorAction;

-(void)initFollowing:(NSObject *)view
         withSuccess:(SEL) success
           withError:(SEL) errorAction;

-(void)initFollowersWithUserId:(NSString*) Id
                    withObject:(NSObject *)view
                   withSuccess:(SEL) success
                     withError:(SEL) errorAction;

-(void)getFollowers:(NSData *) data;


-(void)initFollowingWithUserId:(NSString*) Id
                    withObject:(NSObject *)view
                   withSuccess:(SEL) success
                     withError:(SEL) errorAction;

-(void)getFollowing:(NSData *) data;

-(void)unfollowUserWithUserId:(NSString *) userId
                   withObject:(NSObject *)view
                  withSuccess:(SEL) success
                    withError:(SEL) errorAction;

-(void)followUserWithUserId:(NSString *) userId
                 withObject:(NSObject *)view
                withSuccess:(SEL) success
                  withError:(SEL) errorAction;


-(void)initRequestingFollowersWithUserId:(NSString*) Id
                              withObject:(NSObject *)view
                             withSuccess:(SEL) success
                               withError:(SEL) errorAction;

-(NSMutableArray *)getRequestingFollowers:(NSData *) data;

-(void)AcceptFollowingWithUserId:(NSString *) Id
                      withObject:(NSObject *)view
                     withSuccess:(SEL) success
                       withError:(SEL) errorAction;


-(void)initRequestingFollowees:(NSObject *)view
                   withSuccess:(SEL) success
                     withError:(SEL) errorAction;


-(void)initRequestingFolloweesWithUserId:(NSString*) Id
                              withObject:(NSObject *)view
                             withSuccess:(SEL) success
                               withError:(SEL) errorAction;

-(void)subscribeToUserWithUserId:(NSString *) userId
                      withObject:(NSObject *)view
                     withSuccess:(SEL) success
                       withError:(SEL) errorAction;


-(void)unSubscribeToUserWithUserId:(NSString *) userId
                        withObject:(NSObject *) view
                       withSuccess:(SEL) success
                         withError:(SEL) errorAction;


-(NSMutableArray*)getFollowers;
-(NSMutableArray*)getFollowing;
-(NSUInteger)getNumberOfFollowers;
-(NSUInteger)getNumberOfFollowing;
-(NSMutableArray*)getRequestingFollowers;
-(void)AcceptFollowingWithUserId:(NSString *) Id
                      withObject:(NSObject *)view
                     withSuccess:(SEL) success
                       withError:(SEL) errorAction;

-(void)requestUser:(NSString *) userId withObject:(NSObject *) view
       withSuccess:(SEL) success
         withError:(SEL) errorAction;
@end
