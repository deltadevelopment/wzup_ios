//
//  FeedController.m
//  wzup
//
//  Created by Simen Lie on 24/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "FeedController.h"
#import "AuthHelper.h"
#import "StatusModel.h"
@implementation FeedController
NSMutableArray *feed;
-(NSMutableArray*)getFeed{
    [self getData];
    return  feed;
}
-(void)getData{
    feed = [[NSMutableArray alloc] init];
    NSData *response = [self getHttpRequest:@"feed"];
    NSMutableDictionary *dic = [parserHelper parse:response];
    NSArray* feedRaw = dic[@"feed"];
    for(NSMutableDictionary* statusRaw in feedRaw){
        StatusModel *status = [[StatusModel alloc] init];
        [status build:statusRaw];
        [feed addObject:status];
    }
    if(isErrors){
        NSLog(@"ER FEIL HER JA");
    }
}




@end
