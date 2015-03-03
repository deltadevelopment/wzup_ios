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
    //STEP 1: GET generated image upload url from backend
    NSData *response = [self getHttpRequest:@"status/generate_upload_url"];
    NSMutableDictionary *dic = [parserHelper parse:response];
    NSString *token = dic[@"url"];
     NSString *key = dic[@"key"];
    NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(token);
    NSLog(key);
    
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
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        // response data of the request
    }
    NSLog(@"sendt");

    //STEP 3: POST
    //POST request
    NSDictionary *body = @{
                           @"status": @{
                                   @"media_key" : key,
                                   @"media_type" : @"1"
                                   }
                           };

    //Create json body from dictionary
    NSString *jsonData = [applicationHelper generateJsonFromDictionary:body];
    //Create the request with the body

    
    NSString *url = [NSString stringWithFormat:@"user/%@/status/add_media",[authHelper getUserId]];
    NSData *response2 = [self postHttpRequest:url json:jsonData];
   
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSLog(@"-----RESPO fra server");
    NSLog(@"%ld", (long)[httpResponse statusCode]);
}

@end
