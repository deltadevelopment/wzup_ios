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
        pass:(NSString *) password{
    //Logout
    [authHelper resetCredentials];
    //Create dictionary with username and password
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSDictionary *credentials = @{
                                @"username" : username,
                                @"password" : password,
                                @"device_id" : uniqueIdentifier
                                };
    //Create json body from dictionary
    NSString *jsonData = [applicationHelper generateJsonFromDictionary:credentials];
    //Create the request with the body
    //NSMutableURLRequest *request =[self postHttpRequest:@"login"  json:jsonData];
    NSData *response = [self postHttpRequest:@"login"  json:jsonData];
    //Parse login request
    NSMutableDictionary *dic = [parserHelper parse:response];
    //Store parsed login data in sskey secure
   [authHelper storeCredentials:dic];
    //Debugging
    NSLog([authHelper getAuthToken]);
    NSLog([authHelper getUserId]);
}

@end
