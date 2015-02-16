//
//  ApplicationController.m
//  wzup
//
//  Created by Simen Lie on 16/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationController.h"
#import "ApplicationHelper.h";
#import "AuthHelper.h"
#import "ParserHelper.h"
@implementation ApplicationController
@synthesize authHelper, parserHelper, applicationHelper;

- (id)init
{
    self = [super init];
    if (self) {
        authHelper = [[AuthHelper alloc] init];
        parserHelper = [[ParserHelper alloc] init];
        applicationHelper = [[ApplicationHelper alloc] init];
    }
    return self;
}

-(NSMutableURLRequest *) getHttpRequest:(NSString *) url{
    
    NSURL * serviceUrl = [NSURL URLWithString:[applicationHelper generateUrl:url]];
    NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
    [serviceRequest setValue:@"text" forHTTPHeaderField:@"Content-type"];
    
    [serviceRequest setHTTPMethod:@"GET"];
    return serviceRequest;
};

-(NSMutableURLRequest *) postHttpRequest:(NSString *) url
                                    json:(NSString *) data{
    
    //Look through dic
    
    
    //NSString * xmlString = @"username=simentest&password=simentest";
    NSURL * serviceUrl = [NSURL URLWithString:[applicationHelper generateUrl:url]];
    NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
    [serviceRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [serviceRequest setHTTPMethod:@"POST"];
    [serviceRequest setHTTPBody:[data dataUsingEncoding:NSASCIIStringEncoding]];
    return serviceRequest;
};
@end
