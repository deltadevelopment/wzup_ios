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

/*
-(NSMutableArray*)getFeed{
    [self getData];
    return  feed;
}
*/
-(void)requestFeed:(NSObject *) view
       withSuccess:(SEL) success
         withError:(SEL) errorAction {
    
    [self getHttpRequest:@"feed" withObject:view withSuccess:success withError:errorAction withArgs:nil];
}

-(NSMutableArray *)getFeed:(NSData*) data{
    feed = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic = [parserHelper parse:data];
    NSArray* feedRaw = dic[@"feed"];
    for(NSMutableDictionary* statusRaw in feedRaw){
        StatusModel *status = [[StatusModel alloc] init];
        [status build:statusRaw];
        [feed addObject:status];
    }
    if(isErrors){
        NSLog(@"ER FEIL HER JA");
    }
    return feed;
}

-(NSMutableArray*)getFeed{
    return feed;
}


/*

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
 */
- (void)sendImageToServer:(NSData *)imageData {
    [self uploadImage:imageData];
}


-(void)requestUpload{
    //GET to backend
    //STEP 1: GET generated image upload url from backend
    [self getHttpRequest:@"status/generate_upload_url" withObject:self withSuccess:@selector(uploadUrlIsGenerated:) withError:@selector(uploadUrlIsNotGenerated:) withArgs:nil];
}

-(void)uploadUrlIsGenerated:(NSData *) data{
    NSMutableDictionary *dic = [parserHelper parse:data];
    token = dic[@"url"];
    key = dic[@"key"];
}

-(void)uploadUrlIsNotGenerated:(NSError *) error{
    NSLog([error localizedDescription]);
}

/*
-(void)setLoading:(UILabel *) label{
    loadingLabel = label;
}
*/
-(void)uploadImage:(NSData *) imageData{
    //POST/PUT to Amazon
    //STEP 2: Upload image to S3 with generated token from backend
    [self puttHttpRequestWithImage:imageData token:token];
    
}

-(void)SetStatusWithMedia:(NSObject *) view
              withSuccess:(SEL) success
                withError:(SEL) errorAction
{
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
  //  NSData *response2 = [self postHttpRequest:url json:jsonData];
    [self postHttpRequest:url json:jsonData withObject:view withSuccess:success withError:errorAction withArgs:nil];
}

-(void)updateStatus:(NSString *) status
         withObject:(NSObject *) view
        withSuccess:(SEL) success
          withError:(SEL) errorAction

{
    
    NSDictionary *body = @{
                           @"status":@{
                                   @"body" : status
                                   }
                           };
    
    NSString *jsonData = [applicationHelper generateJsonFromDictionary:body];
    NSString *url = [NSString stringWithFormat:@"user/%@/status", [authHelper getUserId]];
    [self putHttpRequest:url json:jsonData withObject:view withSuccess:success withError:errorAction withArgs:nil];
}
/*
-(void)imageUploadDone{
    [self SetStatusWithMedia];
}
 */
-(void)updateAvailability:(NSNumber *) availability
               withObject:(NSObject *) view
              withSuccess:(SEL) success
                withError:(SEL) errorAction
{
    
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
    [self putHttpRequest:url json:jsonData withObject:view withSuccess:success withError:errorAction withArgs:nil];
   // NSData *response = [self putHttpRequest:url  json:jsonData];
    //NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",strdata);

}
/*
-(void)setImageDone:(UIImageView *) image{
    imageDone = image;
}
*/

-(void)setSelector: (SEL)theSelector withObject:(NSObject *) object{
    mediaUploadSuccess = theSelector;
    mediaUploadSuccessObject = object;
    NSLog(@"selector sat");
}


-(void)requestUser:(NSObject *) view
         withSuccess:(SEL) success
           withError:(SEL) errorAction
{
    NSString *url = [NSString stringWithFormat:@"user/%@", [authHelper getUserId]];
    [self getHttpRequest:url withObject:view withSuccess:success withError:errorAction withArgs:nil];
    //NSData *response = [self getHttpRequest:url];
    //NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    
    //NSLog(strdata);

}

-(UserModel*)getUser:(NSData *) data{
    NSMutableDictionary *dic = [parserHelper parse:data];
    UserModel *user = [[UserModel alloc] init];
    [user build:dic[@"user"]];
    return user;
}




@end
