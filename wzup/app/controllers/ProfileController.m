//
//  ProfileController.m
//  wzup
//
//  Created by Simen Lie on 09/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ProfileController.h"

@implementation ProfileController

-(StatusModel*)getUser{
    NSString *url = [NSString stringWithFormat:@"user/%@/status", [authHelper getUserId]];
    NSData *response = [self getHttpRequest:url];
    //NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    //NSLog(strdata);
    NSMutableDictionary *dic = [parserHelper parse:response];
    StatusModel *status = [[StatusModel alloc] init];
    [status build:dic[@"status"]];
    return status;
    
    
}


@end
