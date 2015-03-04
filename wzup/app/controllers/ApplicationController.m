//
//  ApplicationController.m
//  wzup
//
//  Created by Simen Lie on 16/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationController.h"
#import "ApplicationHelper.h"
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
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    NSLog(@"CASHMONEY");
    return nil;
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
        isErrors = false;
    }else if([httpResponse statusCode] == 403 ){
        //[authHelper resetCredentials];
        [authHelper resetCredentials];
        isErrors = true;
    }
    else{
        isErrors = true;
    }
   
    NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
    return urlData;
}

-(BOOL)hasError{
    return isErrors;
};

-(NSData *) getHttpRequest:(NSString *) url{
    
    NSURL * serviceUrl = [NSURL URLWithString:[applicationHelper generateUrl:url]];
    NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
    [serviceRequest setValue:@"text" forHTTPHeaderField:@"Content-type"];
    [serviceRequest addValue:[authHelper getAuthToken] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [serviceRequest setHTTPMethod:@"GET"];
    return [self getResp:serviceRequest];
};

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

-(NSData *) deleteHttpRequest:(NSString *) url{
    NSURL * serviceUrl = [NSURL URLWithString:[applicationHelper generateUrl:url]];
    NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
    [serviceRequest setValue:@"text" forHTTPHeaderField:@"Content-type"];
      [serviceRequest addValue:[authHelper getAuthToken] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [serviceRequest setHTTPMethod:@"DELETE"];
    return [self getResp:serviceRequest];

};
-(NSData *) putHttpRequest:(NSString *) url
                                   json:(NSString *) data{
    NSURL * serviceUrl = [NSURL URLWithString:[applicationHelper generateUrl:url]];
    NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
    [serviceRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [serviceRequest setHTTPMethod:@"PUT"];
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
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    if(loadingLabel != nil){
        loadingLabel.hidden = NO;
        double width = (percentageDownloaded* screenWidth)/100 ;
        CGRect frame = loadingLabel.frame;
        NSLog(@"%f", width);
        frame.size.width = width;
        loadingLabel.frame = frame;
        [loadingLabel setNeedsDisplay];
    }
    if(percentageDownloaded == 100){
        loadingLabel.hidden = YES;
    }
    //NSLog(@"Skrevet %ld av totalt %ld percentage %d", (long)totalBytesWritten, (long)totalBytesExpectedToWrite, percentageDownloaded);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSLog(@"-----RESPO fra server");
    NSLog(@"%ld", (long)[httpResponse statusCode]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"JA");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"JA2");
}

- (void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *)destinationURL{
    NSLog(@"tester her");
}


@end
