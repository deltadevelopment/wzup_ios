//
//  RegisterController.m
//  wzup
//
//  Created by Simen Lie on 20/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "RegisterController.h"

@implementation RegisterController
NSDictionary* errors;
NSString *usernameError;
NSString *emailError;
NSString *passwordError;

-(void)registerUser:(NSString *) username
               pass:(NSString *) password
              email:(NSString *) email
{
    //Logout
    [authHelper resetCredentials];
    //Create dictionary with username and password
    NSDictionary *credentials = @{
                                  @"user":@{
                                          @"username" : username,
                                          @"password" : password,
                                          @"email": email
                                          }
                                  };
    //Create json body from dictionary
    NSString *jsonData = [applicationHelper generateJsonFromDictionary:credentials];
    //Create the request with the body
    //NSMutableURLRequest *request =[self postHttpRequest:@"login"  json:jsonData];
    NSData *response = [self postHttpRequest:@"register"  json:jsonData];
    //Parse login request
    NSMutableDictionary *dic = [parserHelper parse:response];
    NSArray *usernameErrorArray = dic[@"username"];
    NSArray *passwordErrorArray = dic[@"password"];
    NSArray *emailErrorArray = dic[@"email"];
    usernameError =usernameErrorArray[0];
    emailError = emailErrorArray[0];
    passwordError = passwordErrorArray[0];
    

    
  //  NSLog(usernameError[0]);
    //  NSLog(passwordError[0]);
      // NSLog(emailError[0]);
};
-(NSString *) getUsernameError{
    if(usernameError == nil){
        return nil;
    }
 return [NSString stringWithFormat:@"%@ %@",@"Username",usernameError];
 
};
-(NSString *) getPasswordError{
    if(passwordError == nil){
        return nil;
    }
    return [NSString stringWithFormat:@"%@ %@",@"Password",passwordError];
};
-(NSString *) getEmailError{
    if(emailError == nil){
        return nil;
    }
    return [NSString stringWithFormat:@"%@ %@",@"Email",emailError];
};
-(NSDictionary*) getErrors{
    return errors;
}

@end
