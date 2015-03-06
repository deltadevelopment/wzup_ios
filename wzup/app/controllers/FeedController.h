//
//  FeedController.h
//  wzup
//
//  Created by Simen Lie on 24/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationController.h"
#import "UserModel.h"

@interface FeedController : ApplicationController<NSURLConnectionDataDelegate>
-(NSMutableArray*)getFeed;
- (void)sendImageToServer:(NSData *)imageData;
-(void)setLoading:(UILabel *) label;
-(void)setImageDone:(UIImageView *) image;
-(void)updateStatus:(NSString *) status;
-(void)updateAvailability:(NSNumber *) availability;
-(void)setSelector: (SEL)theSelector withObject:(NSObject *) object;
-(UserModel*)getUser;

@end
