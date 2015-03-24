//
//  ConfigHelper.m
//  wzup
//
//  Created by Simen Lie on 16/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ConfigHelper.h"

@implementation ConfigHelper
- (id)init
{
    self = [super init];
    if (self) {
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"currentServer"] != nil) {
            NSString *storedBaseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentServer"];
            // NSLog(@"imgPath: %@", theImagePath);
            _baseUrl = storedBaseUrl;
        
        }else{
         _baseUrl = @"http://wzap.herokuapp.com";
        }
           NSLog(@"baseURL: %@", _baseUrl);
    }
    
    return self;
}
@end
