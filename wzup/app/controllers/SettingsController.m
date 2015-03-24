//
//  SettingsController.m
//  wzup
//
//  Created by Simen Lie on 24/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SettingsController.h"

@implementation SettingsController{

}

-(void)saveProfile:(NSString *) displayName
   withPhoneNumber:(NSString *) phoneNumber
         withEmail:(NSString *) email
        withObject:(NSObject *) view
       withSuccess:(SEL) success
         withError:(SEL) errorAction
{
    NSString *url = [NSString stringWithFormat:@"/user/%@", [authHelper getUserId]];
    NSDictionary *body = @{
                           @"user": @{
                                   @"display_name" : displayName,
                                   @"phone_number" : phoneNumber,
                                   @"email" : email
                                   }
                           };
    NSString *jsonData = [applicationHelper generateJsonFromDictionary:body];
    [self putHttpRequest:url json:jsonData withObject:view withSuccess:success withError:errorAction withArgs:nil];
}


-(void)changePassword:(NSString *) password
           withObject:(NSObject *) view
          withSuccess:(SEL) success
            withError:(SEL) errorAction
{
    NSString *url = [NSString stringWithFormat:@"/user/%@", [authHelper getUserId]];
    NSDictionary *body = @{
                           @"user": @{
                                   @"password" : password
                                   }
                           };
    NSString *jsonData = [applicationHelper generateJsonFromDictionary:body];
    [self putHttpRequest:url json:jsonData withObject:view withSuccess:success withError:errorAction withArgs:nil];

}

-(void)changePrivateProfile:(BOOL) isPrivate
                 withObject:(NSObject *) view
                withSuccess:(SEL) success
                  withError:(SEL) errorAction
{
    NSString *url = [NSString stringWithFormat:@"/user/%@", [authHelper getUserId]];
    NSDictionary *body = @{
                           @"user": @{
                                   @"private_profile" : [NSString stringWithFormat:@"%@", isPrivate ? @"true" : @"false"]
                                   }
                           };
    NSString *jsonData = [applicationHelper generateJsonFromDictionary:body];
    [self putHttpRequest:url json:jsonData withObject:view withSuccess:success withError:errorAction withArgs:nil];
}

#pragma Deprecated
-(void)editDisplayName:(NSString *) displayName
            withObject:(NSObject *) view
           withSuccess:(SEL) success
             withError:(SEL) errorAction {
    NSString *url = [NSString stringWithFormat:@"/user/%@", [authHelper getUserId]];
    NSDictionary *body = @{
                           @"user": @{
                                   @"display_name" : displayName
                                   }
                           };
    NSString *jsonData = [applicationHelper generateJsonFromDictionary:body];
    [self putHttpRequest:url json:jsonData withObject:view withSuccess:success withError:errorAction withArgs:nil];
}

-(void)editPhoneNumber:(NSString *) phoneNumber
            withObject:(NSObject *) view
           withSuccess:(SEL) success
             withError:(SEL) errorAction
{
    NSString *url = [NSString stringWithFormat:@"/user/%@", [authHelper getUserId]];
    NSDictionary *body = @{
                           @"user": @{
                                   @"phone_number" : phoneNumber
                                   }
                           };
    NSString *jsonData = [applicationHelper generateJsonFromDictionary:body];
    [self putHttpRequest:url json:jsonData withObject:view withSuccess:success withError:errorAction withArgs:nil];
}
-(void)editEmail:(NSString *) email
      withObject:(NSObject *) view
     withSuccess:(SEL) success
       withError:(SEL) errorAction
{
    NSString *url = [NSString stringWithFormat:@"/user/%@", [authHelper getUserId]];
    NSDictionary *body = @{
                           @"user": @{
                                   @"email" : email
                                   }
                           };
    NSString *jsonData = [applicationHelper generateJsonFromDictionary:body];
    [self putHttpRequest:url json:jsonData withObject:view withSuccess:success withError:errorAction withArgs:nil];
}

@end
