//
//  SettingsController.h
//  wzup
//
//  Created by Simen Lie on 24/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationController2.h"

@interface SettingsController : ApplicationController2
-(void)editDisplayName:(NSString *) displayName
            withObject:(NSObject *) view
           withSuccess:(SEL) success
             withError:(SEL) errorAction __attribute__((deprecated));

-(void)editPhoneNumber:(NSString *) phoneNumber
            withObject:(NSObject *) view
           withSuccess:(SEL) success
             withError:(SEL) errorAction __attribute__((deprecated));
-(void)editEmail:(NSString *) email
            withObject:(NSObject *) view
           withSuccess:(SEL) success
             withError:(SEL) errorAction __attribute__((deprecated));

-(void)changePassword:(NSString *) password
      withObject:(NSObject *) view
     withSuccess:(SEL) success
       withError:(SEL) errorAction;

-(void)changePrivateProfile:(BOOL) isPrivate
           withObject:(NSObject *) view
          withSuccess:(SEL) success
            withError:(SEL) errorAction;

-(void)saveProfile:(NSString *) displayName
   withPhoneNumber:(NSString *) phoneNumber
         withEmail:(NSString *) email
        withObject:(NSObject *) view
       withSuccess:(SEL) success
         withError:(SEL) errorAction;
@end
