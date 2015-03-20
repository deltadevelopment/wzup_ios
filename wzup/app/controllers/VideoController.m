//
//  VideoController.m
//  wzup
//
//  Created by Simen Lie on 18/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "VideoController.h"
#import <UIKit/UIKit.h>
@implementation VideoController
NSString *token;
NSString *key;
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

-(void)sendVideoToServer:(NSData *)imageData
            withSelector:(SEL) success
              withObject:(NSObject*)object withArg:(NSObject *) arg
{
    mediaUploadSuccess = success;
    mediaUploadSuccessObject = object;
    mediaUploadSuccessArg = arg;
    [self sendVideoToServer:imageData];
}

- (void)sendVideoToServer:(NSData *)imageData {
    [self requestUpload];
    [self puttHttpRequestWithImage:imageData token:token];
}

-(void)requestUpload{
    //GET to backend
    //STEP 1: GET generated image upload url from backend
    NSData *response = [self getHttpRequest:@"status/generate_upload_url"];
    NSMutableDictionary *dic = [parserHelper parse:response];
    token = dic[@"url"];
    key = dic[@"key"];
}

-(void)SetStatusWithMedia{
    //STEP 3: POST
    NSDictionary *body = @{
                           @"status": @{
                                   @"media_key" : key,
                                   @"media_type" : @"2"
                                   }
                           };
    
    //Create json body from dictionary
    NSString *jsonData = [applicationHelper generateJsonFromDictionary:body];
    //Create the request with the body
    
    
    NSString *url = [NSString stringWithFormat:@"user/%@/status/add_media",[authHelper getUserId]];
    NSData *response2 = [self postHttpRequest:url json:jsonData];
}

-(NSData *) postHttpRequest:(NSString *) url
                       json:(NSString *) data{
    NSURL * serviceUrl = [NSURL URLWithString:[applicationHelper generateUrl:url]];
    NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
    [serviceRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [serviceRequest addValue:[authHelper getAuthToken] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [serviceRequest setHTTPMethod:@"POST"];
    [serviceRequest setHTTPBody:[data dataUsingEncoding:NSASCIIStringEncoding]];
    return [self getResp:serviceRequest];
};

-(void)puttHttpRequestWithImage:(NSData *) imageData token:(NSString *) token{
    //POST/PUT to Amazon
    //STEP 2: Upload image to S3 with generated token from backend
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[imageData length]];
    
    // Init the URLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"PUT"];
    [request setURL:[NSURL URLWithString:token]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:imageData];
   //[request addData:audioData withFileName:videoName andContentType:@"video/mov" forKey:@"videoFile"];

    NSLog(@"token is --- %@", token);
    
    
    NSURLConnection * connection2 = [[NSURLConnection alloc]
                                     initWithRequest:request
                                     delegate:self startImmediately:NO];
    
    [connection2 scheduleInRunLoop:[NSRunLoop mainRunLoop]
                           forMode:NSDefaultRunLoopMode];
    
    [connection2 start];
    if (connection2) {
        NSLog(@"connection---");
    };
    
}

- (void)connection:(NSURLConnection *)connection
   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    long percentageDownloaded = (totalBytesWritten * 100)/totalBytesExpectedToWrite;

    [mediaUploadSuccessObject performSelector:mediaUploadSuccess withObject:[NSNumber numberWithInt:percentageDownloaded]];
    if(percentageDownloaded == 100){
        NSLog(@"Video upload done");
        NSLog(key);
        [self SetStatusWithMedia];
        
    }
    //NSLog(@"Skrevet %ld av totalt %ld percentage %d", (long)totalBytesWritten, (long)totalBytesExpectedToWrite, percentageDownloaded);
}

-(NSData*)getResp:(NSMutableURLRequest *) request{
    NSURLResponse *response;
    NSError *error;
    
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //NSLog(urlData);
    
    //  NSString *strdata=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    // NSLog(@"%@",strdata);
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    if([httpResponse statusCode] == 200 || [httpResponse statusCode] == 201){
        //isErrors = false;
    }else if([httpResponse statusCode] == 403 ){
        //[authHelper resetCredentials];
        [authHelper resetCredentials];
        //isErrors = true;
    }
    else{
        //NSLog(@"ERROR");
        //isErrors = true;
    }
    
    NSLog(@"response status code: %ld on %@", (long)[httpResponse statusCode], [request URL]);
    return urlData;
}

-(NSData *) getHttpRequest:(NSString *) url{
    NSURL * serviceUrl = [NSURL URLWithString:[applicationHelper generateUrl:url]];
    NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
    [serviceRequest setValue:@"text" forHTTPHeaderField:@"Content-type"];
    [serviceRequest addValue:[authHelper getAuthToken] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [serviceRequest setHTTPMethod:@"GET"];
    return [self getResp:serviceRequest];
};

@end
