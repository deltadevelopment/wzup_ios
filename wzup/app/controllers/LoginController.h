//
//  LoginController.h
//  wzup
//
//  Created by Simen Lie on 16/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationController.h"

@interface LoginController : ApplicationController
-(void)login:(NSString *) username
        pass:(NSString *) password;
@end
