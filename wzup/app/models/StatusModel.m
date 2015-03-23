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
    _media_key = dic[@"media_key"];
    
//NSLog(@"The status is %@ %@",_body, _user_id);
    //NSArray* pics = [[NSArray alloc] initWithObjects:@"testBilde.jpg", @"testBilde.jpg", @"testBilde.jpg",@"testBilde.jpg", nil];
    //imgPath =pics[rand()%4];
 
};

-(void)downloadImage{
 
        //NSLog(@"Donwloading image with %@", _media_url);
        _media = [NSData dataWithContentsOfURL:[NSURL URLWithString:_media_url]];
       // NSLog(@"image donwloaded");
    
  
}

-(void)downloadImage3:(NSObject*) object withSelector:(SEL)mediaDoneSelector  withObject:(NSObject*) element{
    //NSLog(@"downloading image");
    //NSLog(_media_url);
    NSURL *url = [NSURL URLWithString:_media_url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    NSCachedURLResponse *cachedURLResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    
    NSData *responseData;
    NSString *strdata=[[NSString alloc]initWithData:cachedURLResponse.data encoding:NSUTF8StringEncoding];
    NSLog(@"cached data %@",strdata);
    //check if has cache
    
    if(cachedURLResponse && cachedURLResponse != (id)[NSNull null])
    {
        NSLog(@"ISCAHCED");
        responseData = [cachedURLResponse data];
        _media = responseData;
        [object performSelector:mediaDoneSelector withObject:element];
    }
    else //if no cache get it from the server.
    {
        //[request setTimeoutInterval: 10.0]; // Will timeout after 10 seconds
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue currentQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   //NSLog(@"downloading");
                                   if (data != nil && error == nil)
                                   {
                                         NSLog(@"notCAHCED");
                                       
                                       
                                       NSURLCache *cache = [NSURLCache sharedURLCache];
                                       NSCachedURLResponse *cachedURLResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data userInfo:nil storagePolicy:NSURLCacheStorageAllowed];
                                       [[NSURLCache sharedURLCache] storeCachedResponse:cachedURLResponse forRequest:request];
                                       
                                       
                                       _media = data;
                                       [object performSelector:mediaDoneSelector withObject:element];
                                   }
                                   else
                                   {
                                       // There was an error, alert the user
                                       NSLog(@"error with the request");
                                   }
                                   
                               }];
        
        
        

        
     
    }
    
    
    

}

-(void)StoreCached:(NSData *) data withResponse:(NSURLResponse *) response withRequest:(NSMutableURLRequest *) request{
    //NSCachedURLResponse *cachedURLResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data userInfo:nil storagePolicy:NSURLCacheStorageAllowed];
    //store in cache
   
    NSCachedURLResponse *cachedURLResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data userInfo:nil storagePolicy:NSURLCacheStorageAllowed];
    [[NSURLCache sharedURLCache] storeCachedResponse:cachedURLResponse forRequest:request];

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
    //NSLog(@"get----");
    if(![_media isKindOfClass:[NSNull class]] && ![_media_url isKindOfClass:[NSNull class]]){
        if(_media == nil && _media_url != nil){
      //      NSLog(@"get----2");
          
              [self downloadImage3:object withSelector:mediaDoneSelector withObject:element];
            
          
        }
    }
    
    else if(_media_url == nil){
        
    }
    else{
        //NSLog(@"image is cached");
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


-(UIImage *)getCroppedImage{
    return _croppedImage;
}
-(void)setCroppedImage:(UIImage *) image{
    _croppedImage = image;
    [self storeimage:image];
    
}

-(bool)shouldUpdateMedia{
    NSString *userIdEtag = [NSString stringWithFormat:@"cachedEtag%@", self.user_id];
    if([[NSUserDefaults standardUserDefaults] objectForKey:userIdEtag] != nil) {
        NSString *etagStored = [[NSUserDefaults standardUserDefaults] stringForKey:userIdEtag];
        if([etagStored isEqualToString:self.media_key]){
            return NO;
        }
        return YES;
    }
    return  YES;
}

-(void)storeimage:(UIImage *) image{
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",@"cached"]];
    
    NSLog((@"pre writing to file"));
    if (![imageData writeToFile:imagePath atomically:NO])
    {
        NSLog((@"Failed to cache image data to disk"));
    }
    else
    {
        NSLog((@"the cachedImagedPath is %@",imagePath)); 
    }
    
    // Store the data
    NSLog(@"user id storing for : %@", self.user_id);
    NSString *userIdString = [NSString stringWithFormat:@"cachedImage%@", self.user_id];
    NSString *userIdEtag = [NSString stringWithFormat:@"cachedEtag%@", self.user_id];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:imageData forKey:userIdString];
    [defaults setObject:_media_key forKey:userIdEtag];
    [defaults synchronize];
    NSLog(@"Data saved");
    
}

-(UIImage *) getStoredImage{
     NSString *userIdString = [NSString stringWithFormat:@"cachedImage%@", self.user_id];
    if([[NSUserDefaults standardUserDefaults] objectForKey:userIdString] != nil) {
        NSString *theImagePath = [[NSUserDefaults standardUserDefaults] objectForKey:userIdString];
       // NSLog(@"imgPath: %@", theImagePath);
        UIImage *customImage = [UIImage imageWithData:theImagePath];
        return customImage;
    }
    return nil;
   
    
}

-(void)storeVideo:(NSData *) videoData{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",@"cached"]];
    
    NSLog((@"pre writing to file"));
    if (![videoData writeToFile:imagePath atomically:NO])
    {
        NSLog((@"Failed to cache image data to disk"));
    }
    else
    {
        NSLog((@"the cachedImagedPath is %@",imagePath));
    }
    
    // Store the data
    NSLog(@"user id storing for : %@", self.user_id);
    NSString *userIdString = [NSString stringWithFormat:@"cachedImage%@", self.user_id];
    NSString *userIdEtag = [NSString stringWithFormat:@"cachedEtag%@", self.user_id];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:videoData forKey:userIdString];
    [defaults setObject:_media_key forKey:userIdEtag];
    [defaults synchronize];
    NSLog(@"Data saved");
    
}

-(NSData *) getStoredVideo{
    NSString *userIdString = [NSString stringWithFormat:@"cachedImage%@", self.user_id];
    if([[NSUserDefaults standardUserDefaults] objectForKey:userIdString] != nil) {
        NSString *theImagePath = [[NSUserDefaults standardUserDefaults] objectForKey:userIdString];
        // NSLog(@"imgPath: %@", theImagePath);
        
        return [NSData dataWithData:theImagePath];
    }
    return nil;
    
    
}


@end
