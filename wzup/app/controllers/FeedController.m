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
#import <UIKit/UIKit.h>
@implementation FeedController
NSMutableArray *feed;
NSString *token;
NSString *key;

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
    [self requestUpload];
    [self uploadImage:imageData];
    

}


-(void)requestUpload{
    //GET to backend
    //STEP 1: GET generated image upload url from backend
    NSData *response = [self getHttpRequest:@"status/generate_upload_url"];
    NSMutableDictionary *dic = [parserHelper parse:response];
    token = dic[@"url"];
    key = dic[@"key"];
    NSLog(key);
}

-(void)setLoading:(UILabel *) label{
    loadingLabel = label;
}

-(void)uploadImage:(NSData *) imageData{
    //POST/PUT to Amazon
    //STEP 2: Upload image to S3 with generated token from backend
    [self puttHttpRequestWithImage:imageData token:token];
    
}

-(void)SetStatusWithMedia{
    //STEP 3: POST
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

-(void)updateStatus:(NSString *) status{
    
    NSDictionary *body = @{
                                  @"status":@{
                                          @"body" : status
                                          }
                                  };
    //Create json body from dictionary
    NSString *jsonData = [applicationHelper generateJsonFromDictionary:body];
    //Create the request with the body
    //NSMutableURLRequest *request =[self postHttpRequest:@"login"  json:jsonData];
    NSString *url = [NSString stringWithFormat:@"user/%@/status", [authHelper getUserId]];
    NSData *response = [self putHttpRequest:url  json:jsonData];
    NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
   // NSLog(@"%@",strdata);
    //Parse login request
    //NSMutableDictionary *dic = [parserHelper parse:response];
    
    

}
-(void)imageUploadDone{
    [self SetStatusWithMedia];
}

-(void)updateAvailability:(NSNumber *) availability{
    
    NSDictionary *body = @{
                           @"user":@{
                                   @"availability" : availability
                                   }
                           };
    //Create json body from dictionary
    NSString *jsonData = [applicationHelper generateJsonFromDictionary:body];
    //Create the request with the body
    //NSMutableURLRequest *request =[self postHttpRequest:@"login"  json:jsonData];
    NSString *url = [NSString stringWithFormat:@"user/%@", [authHelper getUserId]];
    NSData *response = [self putHttpRequest:url  json:jsonData];
    NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strdata);

}

-(void)setImageDone:(UIImageView *) image{
    imageDone = image;
}

-(void)setSelector: (SEL)theSelector withObject:(NSObject *) object{
    aSelector = theSelector;
    currentObject = object;
    NSLog(@"selector sat");
}

-(UserModel*)getUser{
    NSString *url = [NSString stringWithFormat:@"user/%@", [authHelper getUserId]];
    NSData *response = [self getHttpRequest:url];
    //NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic = [parserHelper parse:response];
    UserModel *user = [[UserModel alloc] init];
    [user build:dic[@"user"]];
    return user;
    //NSLog(strdata);

}




@end
