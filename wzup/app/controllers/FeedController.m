//
//  FeedController.m
//  wzup
//
//  Created by Simen Lie on 24/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "FeedController.h"
#import "AuthHelper.h"
#import "StatusModel.h"
@implementation FeedController
NSMutableArray *feed;
-(NSMutableArray*)getFeed{
    [self getData];
    return  feed;
}
-(void)getData{
    feed = [[NSMutableArray alloc] init];
    NSData *response = [self getHttpRequest:@"feed"];
    NSMutableDictionary *dic = [parserHelper parse:response];
    NSArray* feedRaw = dic[@"feed"];
    for(NSMutableDictionary* statusRaw in feedRaw){
        StatusModel *status = [[StatusModel alloc] init];
        [status build:statusRaw];
        [feed addObject:status];
    }
    if(isErrors){
        NSLog(@"ER FEIL HER JA");
    }
}
- (void)sendImageToServer:(NSData *)imageData {
    //GET to backend
    /*
    NSData *response = [self getHttpRequest:@"status/generate_upload_url"];
    NSMutableDictionary *dic = [parserHelper parse:response];
    NSString *token = dic[@"url"];
     NSString *key = dic[@"key"];
    NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(token);
    NSLog(key);
    
    //POST/PUT to Amazon
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[imageData length]];
    
    // Init the URLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"PUT"];
    [request setURL:[NSURL URLWithString:token]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    NSMutableString *temp = [[NSMutableString alloc] init];
    [temp appendString:key];
    [temp appendString:@".jpg"];
    [request setValue:imageData forKey:key];
    
    
     NSMutableData *httpBody = [NSMutableData data];
    NSString *filename = @"test.jpg";
    //[httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
    //[httpBody appendData:imageData];
    //[httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //[request setHTTPBody:imageData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
      
        // response data of the request
        
    }
   
   // [request release];
   */ 
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSLog(@"%ld", (long)[httpResponse statusCode]);
}

@end
