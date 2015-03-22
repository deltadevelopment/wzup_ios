//
//  ApplicationController2.m
//  wzup
//
//  Created by Simen Lie on 21.03.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationController2.h"

@implementation ApplicationController2

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

-(void) getHttpRequest:(NSString *) url
            withObject:(NSObject *) view
           withSuccess:(SEL)success
             withError:(SEL)errorAction
              withArgs:(NSObject *) args{
    
    NSLog(@"token sendt med: %@", [authHelper getAuthToken]);
    NSURL * serviceUrl = [NSURL URLWithString:[applicationHelper generateUrl:url]];
    NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:1200.0];
    [serviceRequest setValue:@"text" forHTTPHeaderField:@"Content-type"];
    [serviceRequest addValue:[authHelper getAuthToken] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [serviceRequest setHTTPMethod:@"GET"];
    
    //[request setTimeoutInterval: 10.0]; // Will timeout after 10 seconds
    [self sendRequestAsync:serviceRequest withObject:view withSuccess:success withError:errorAction withArgs:args];
};


-(void) postHttpRequest:(NSString *) url
                   json:(NSString *) data
             withObject:(NSObject *) view
            withSuccess:(SEL)success
              withError:(SEL)errorAction
               withArgs:(NSObject *) args
{
    NSURL * serviceUrl = [NSURL URLWithString:[applicationHelper generateUrl:url]];
    NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
    [serviceRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [serviceRequest addValue:[authHelper getAuthToken] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [serviceRequest setHTTPMethod:@"POST"];
    [serviceRequest setHTTPBody:[data dataUsingEncoding:NSASCIIStringEncoding]];
    
    [self sendRequestAsync:serviceRequest withObject:view withSuccess:success withError:errorAction withArgs:args];
};

-(void) deleteHttpRequest:(NSString *) url
               withObject:(NSObject *) view
              withSuccess:(SEL)success
                withError:(SEL)errorAction
                 withArgs:(NSObject *) args
{
    NSURL * serviceUrl = [NSURL URLWithString:[applicationHelper generateUrl:url]];
    NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
    [serviceRequest setValue:@"text" forHTTPHeaderField:@"Content-type"];
    [serviceRequest addValue:[authHelper getAuthToken] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [serviceRequest setHTTPMethod:@"DELETE"];
    [self sendRequestAsync:serviceRequest withObject:view withSuccess:success withError:errorAction withArgs:args];
    
};
-(void) putHttpRequest:(NSString *) url
                  json:(NSString *) data
            withObject:(NSObject *) view
           withSuccess:(SEL)success
             withError:(SEL)errorAction
              withArgs:(NSObject *) args
{
    NSURL * serviceUrl = [NSURL URLWithString:[applicationHelper generateUrl:url]];
    NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
    [serviceRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [serviceRequest addValue:[authHelper getAuthToken] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [serviceRequest setHTTPMethod:@"PUT"];
    [serviceRequest setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    [self sendRequestAsync:serviceRequest withObject:view withSuccess:success withError:errorAction withArgs:args];
    
};


-(void)sendRequestAsync:(NSMutableURLRequest *)request
             withObject:(NSObject *) view
            withSuccess:(SEL)success
              withError:(SEL) errorAction
               withArgs:(NSObject *) args{
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if (data != nil && error == nil)
                               {
                                   //Ferdig lastet ned
                                   
                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                   NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
                                   NSInteger statuscode = [httpResponse statusCode];
                                   if(statuscode < 300){
                                       [view performSelector:success withObject:data];
                                   }else{
                                       NSMutableDictionary *errors = [parserHelper parse:data];
                                       NSError *httpError = [NSError errorWithDomain:@"world" code:200 userInfo:errors];
                                       [view performSelector:errorAction withObject:httpError];
                                   }
                               }
                               else
                               {
                                   // There was an error, alert the user
                                   [view performSelector:errorAction withObject:error];
                               }
                               
                           }];
}

- (void)connection:(NSURLConnection *)connection
   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    long percentageDownloaded = (totalBytesWritten * 100)/totalBytesExpectedToWrite;
    
    [mediaUploadSuccessObject performSelector:mediaUploadSuccess withObject:[NSNumber numberWithInt:percentageDownloaded]];
    if(percentageDownloaded == 100){
        NSLog(@"Video upload done");
       // [self SetStatusWithMedia];
        
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

@end
