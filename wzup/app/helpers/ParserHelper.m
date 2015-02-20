//
//  ParserHelper.m
//  wzup
//
//  Created by Simen Lie on 16/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ParserHelper.h"

@implementation ParserHelper

- (NSMutableDictionary *) parse:(NSData *) response;{
    NSError *error;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    return dic;
};

@end


