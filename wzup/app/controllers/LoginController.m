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
    //Create dictionary with username and password
    NSDictionary *credentials = @{
                                @"username" : username,
                                @"password" : password
                                };
    //Create json body from dictionary
    NSString *jsonData = [applicationHelper generateJsonFromDictionary:credentials];
    //Create the request with the body
    NSMutableURLRequest *request =[self postHttpRequest:@"login"  json:jsonData];
    //Parse login request
    NSMutableDictionary *dic = [parserHelper parse:request];
    //Store parsed login data in sskey secure
    [authHelper storeCredentials:dic];
    
    //Debugging
    NSLog([authHelper getAuthToken]);
    NSLog([authHelper getUserId]);
}

@end
