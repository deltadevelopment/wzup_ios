//
//  LoginController.m
//  wzup
//
//  Created by Simen Lie on 16/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "LoginController.h"

@implementation LoginController

-(void)login:(NSString *) username
        pass:(NSString *) password
  withObject:(NSObject *) view
 withSuccess:(SEL) success
   withError:(SEL) errorAction
{
    NSLog(@"Device Id sending: %@", [authHelper getDeviceId]);
    NSDictionary *credentials = [self loginBody:username pass:password];
    NSString *jsonData = [applicationHelper generateJsonFromDictionary:credentials];
    [self postHttpRequest:@"login" json:jsonData withObject:view withSuccess:success withError:errorAction withArgs:nil];
}

-(NSDictionary *) loginBody:(NSString *) username
                       pass:(NSString *) password
{
    NSDictionary *body;
    if([authHelper getDeviceId] == nil){
        body = @{
                 @"username" : username,
                 @"password" : password
                 };
    }else{
        body= @{
                @"username" : username,
                @"password" : password,
                @"device_id" : [authHelper getDeviceId],
                @"device_type":@"ios"
                };
    }
    return body;
}

-(void)storeCredentials:(NSData *) data{
    NSMutableDictionary *dic = [parserHelper parse:data];
    //Store parsed login data in sskey secure
    NSLog(@"reciv: %@", dic[@"auth_token"]);
    [authHelper storeCredentials:dic];
}

@end
