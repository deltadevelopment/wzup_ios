//
//  ParserHelper.h
//  wzup
//
//  Created by Simen Lie on 16/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParserHelper : NSObject<NSURLConnectionDelegate>
- (NSMutableDictionary *) parse:(NSData *) response;
@end
