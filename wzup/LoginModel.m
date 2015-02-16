//
//  LoginModel.m
//  wzup
//
//  Created by Simen Lie on 16/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

-(void)build:(NSMutableDictionary *)dic{
    _user_id = dic[@"user_id"];
    _auth_token = dic[@"auth_token"];
    _success = dic[@"success"];
};

-(NSString*) getUserID{
    return [NSString stringWithFormat: @"%@", _user_id];

};
-(NSString*) getSuccess{
 return _success;
};
-(NSString*) getAuth{
     return _auth_token;
};

@end
