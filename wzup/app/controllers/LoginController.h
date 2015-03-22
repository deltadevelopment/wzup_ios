//
//  LoginController.h
//  wzup
//
//  Created by Simen Lie on 16/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationController2.h"

@interface LoginController : ApplicationController2
-(void)login:(NSString *) username
        pass:(NSString *) password
  withObject:(NSObject *) view
 withSuccess:(SEL) success
   withError:(SEL) errorAction;
-(void)storeCredentials:(NSData *) data;
@end
