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
#import "ApplicationHelper.h"
#import <UIKit/UIKit.h>

@interface ApplicationController : NSObject<NSURLConnectionDataDelegate>{
    AuthHelper *authHelper;
    ParserHelper *parserHelper;
    ApplicationHelper *applicationHelper;
    BOOL isErrors;
    NSURLConnection *connection;
    UILabel *loadingLabel;
    UIImageView *imageDone;
    SEL aSelector;
    NSObject *currentObject;
}

@property AuthHelper *authHelper;
@property ParserHelper *parserHelper;
@property ApplicationHelper *applicationHelper;


-(NSData *) getHttpRequest:(NSString *) url;
-(NSData  *) postHttpRequest:(NSString *) url
                                    json:(NSString *) data;
-(NSData  *) deleteHttpRequest:(NSString *) url;
-(NSData  *) putHttpRequest:(NSString *) url
                                    json:(NSString *) data;
-(void)puttHttpRequestWithImage:(NSData *) imageData token:(NSString *) token;

-(BOOL)hasError;

@end
