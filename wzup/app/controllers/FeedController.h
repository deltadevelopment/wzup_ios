//
//  FeedController.h
//  wzup
//
//  Created by Simen Lie on 24/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationController2.h"
#import "UserModel.h"

@interface FeedController : ApplicationController2<NSURLConnectionDataDelegate>

-(void)requestUpload;
-(void)requestFeed:(NSObject *) view
       withSuccess:(SEL) success
         withError:(SEL) errorAction;

-(NSMutableArray *)getFeed:(NSData*) data;
- (void)sendImageToServer:(NSData *)imageData;

-(void)updateStatus:(NSString *) status
         withObject:(NSObject *) view
        withSuccess:(SEL) success
          withError:(SEL) errorAction;
-(void)updateAvailability:(NSNumber *) availability
               withObject:(NSObject *) view
              withSuccess:(SEL) success
                withError:(SEL) errorAction;


-(void)setSelector: (SEL)theSelector withObject:(NSObject *) object;

-(void)requestUser:(NSObject *) view
       withSuccess:(SEL) success
         withError:(SEL) errorAction;

-(UserModel*)getUser:(NSData *) data;
-(NSMutableArray*)getFeed;
-(void)SetStatusWithMedia:(NSObject *) view
              withSuccess:(SEL) success
                withError:(SEL) errorAction;

@end
