//
//  RegisterController.h
//  wzup
//
//  Created by Simen Lie on 20/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationController.h"

@interface RegisterController : ApplicationController
-(void)registerUser:(NSString *) username
               pass:(NSString *) password
               email:(NSString *) email;
-(NSDictionary*) getErrors;
-(NSString *) getUsernameError;
-(NSString *) getPasswordError;
-(NSString *) getEmailError;
@end
