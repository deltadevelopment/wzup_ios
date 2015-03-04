//
//  FeedController.h
//  wzup
//
//  Created by Simen Lie on 24/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationController.h"

@interface FeedController : ApplicationController<NSURLConnectionDataDelegate>
-(NSMutableArray*)getFeed;
- (void)sendImageToServer:(NSData *)imageData;
-(void)setLoading:(UILabel *) label;
-(void)updateStatus:(NSString *) status;
-(void)updateAvailability:(NSNumber *) availability;
@end
