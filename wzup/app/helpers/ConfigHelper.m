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
        _baseUrl = @"http://wzap.herokuapp.com";
    }
    
    return self;
}
@end
