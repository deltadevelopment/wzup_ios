//
//  ApplicationController.h
//  wzup
//
//  Created by Simen Lie on 16/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthHelper.h"
#import "ParserHelper.h"
#import "ApplicationHelper.h";

@interface ApplicationController : NSObject{
    AuthHelper *authHelper;
    ParserHelper *parserHelper;
    ApplicationHelper *applicationHelper;
}

@property AuthHelper *authHelper;
@property ParserHelper *parserHelper;
@property ApplicationHelper *applicationHelper;


-(NSMutableURLRequest *) getHttpRequest:(NSString *) url;
-(NSMutableURLRequest *) postHttpRequest:(NSString *) url
                                    json:(NSString *) data;
@end
