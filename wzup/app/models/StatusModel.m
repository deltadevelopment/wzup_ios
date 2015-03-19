//
//  StatusModel.m
//  wzup
//
//  Created by Simen Lie on 24/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "StatusModel.h"

@implementation StatusModel

-(void)build:(NSMutableDictionary *)dic{
    _statusId = dic[@"id"];
    _body = dic[@"body"];
    _location = dic[@"location"];
    _user_id = dic[@"user_id"];
    _created_at = dic[@"created_at"];
    _updated_at = dic[@"updated_at"];
    _user = [[UserModel alloc] init];
    _media_url = dic[@"media_url"];
    [_user build:dic[@"user"]];
    _media_type = dic[@"media_type"];
    
//NSLog(@"The status is %@ %@",_body, _user_id);
    //NSArray* pics = [[NSArray alloc] initWithObjects:@"testBilde.jpg", @"testBilde.jpg", @"testBilde.jpg",@"testBilde.jpg", nil];
    //imgPath =pics[rand()%4];
 
};

-(void)downloadImage{
 
        NSLog(@"Donwloading image with %@", _media_url);
        _media = [NSData dataWithContentsOfURL:[NSURL URLWithString:_media_url]];
        NSLog(@"image donwloaded");
    
  
}

-(void)downloadImage3:(NSObject*) object withSelector:(SEL)mediaDoneSelector  withObject:(NSObject*) element{
    NSLog(@"downloading image");
    NSLog(_media_url);
    NSURL *url = [NSURL URLWithString:_media_url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //[request setTimeoutInterval: 10.0]; // Will timeout after 10 seconds
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSLog(@"downloading");
                               if (data != nil && error == nil)
                               {
                                   //NSString *sourceHTML = [[NSString alloc] initWithData:data];
                                   // It worked, your source HTML is in sourceHTML
                                   _media = data;
                                        NSLog(@"image is not cached");
                                [object performSelector:mediaDoneSelector withObject:element];
                               }
                               else
                               {
                                   // There was an error, alert the user
                                   NSLog(@"error with the request");
                               }
                               
                           }];
}

-(NSString*) getStatusId{
    return _statusId;
};
-(NSString*) getBody
{
    return _body;
};
-(NSString*) getLocation
{
    return _location;
};
-(NSString*) getUserId
{
    return _user_id;
};
-(NSString*) getCreatedAt
{
    return _created_at;
};
-(NSString*) getUpdatedAt
{
    return _updated_at;
};
-(UserModel*) getUser{
    return _user;
};

-(NSString*)getImgPath{

    return imgPath;
}
-(NSString*)getMediaUrl{
    return _media_url;
}

-(NSString*)getMediaType{
    return _media_type;
}

-(void)getMedia:(NSObject*)object withSelector:(SEL)mediaDoneSelector withObject:(NSObject*) element{
    NSLog(@"get----");
    if(![_media isKindOfClass:[NSNull class]] && ![_media_url isKindOfClass:[NSNull class]]){
        if(_media == nil && _media_url != nil){
            NSLog(@"get----2");
          
              [self downloadImage3:object withSelector:mediaDoneSelector withObject:element];
            
          
        }
    }
    
    else if(_media_url == nil){
        
    }
    else{
        NSLog(@"image is cached");
        [object performSelector:mediaDoneSelector withObject:element];
    }
}

-(NSData*)getMedia{
    if(![_media isKindOfClass:[NSNull class]] && ![_media_url isKindOfClass:[NSNull class]]){
        if(_media == nil && _media_url != nil){
            //[self downloadImage];
        }
    }
   
    else if(_media_url == nil){
        return nil;
    }
    return _media;
}
@end
