//
//  RegisterController.h
//  wzup
//
//  Created by Simen Lie on 20/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationController2.h"

@interface RegisterController : ApplicationController2
-(void)registerUser:(NSString *) username
               pass:(NSString *) password
              email:(NSString *) email
         withObject:(NSObject *) view
        withSuccess:(SEL) success
          withError:(SEL) errorAction;
-(NSDictionary*) getErrors;
-(NSString *) getUsernameError;
-(NSString *) getPasswordError;
-(NSString *) getEmailError;

-(void)parseData:(NSDictionary *) dic;
@end
