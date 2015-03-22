//
//  ApplicationController2.h
//  wzup
//
//  Created by Simen Lie on 21.03.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthHelper.h"
#import "ParserHelper.h"
#import "ApplicationHelper.h"
@interface ApplicationController2 : NSObject<NSURLConnectionDataDelegate>{
    AuthHelper *authHelper;
    ParserHelper *parserHelper;
    ApplicationHelper *applicationHelper;
    BOOL isErrors;
    NSURLConnection *connection;
    SEL mediaUploadSuccess;
    NSObject *mediaUploadSuccessObject;
    NSObject *mediaUploadSuccessArg;
}
-(void) getHttpRequest:(NSString *) url
            withObject:(NSObject *) view
           withSuccess:(SEL)success
             withError:(SEL)errorAction
              withArgs:(NSObject *) args;

-(void) postHttpRequest:(NSString *) url
                   json:(NSString *) data
             withObject:(NSObject *) view
            withSuccess:(SEL)success
              withError:(SEL)errorAction
               withArgs:(NSObject *) args;

-(void) deleteHttpRequest:(NSString *) url
               withObject:(NSObject *) view
              withSuccess:(SEL)success
                withError:(SEL)errorAction
                 withArgs:(NSObject *) args;

-(void) putHttpRequest:(NSString *) url
                  json:(NSString *) data
            withObject:(NSObject *) view
           withSuccess:(SEL)success
             withError:(SEL)errorAction
              withArgs:(NSObject *) args;

-(void)puttHttpRequestWithImage:(NSData *) imageData token:(NSString *) token;

@end
