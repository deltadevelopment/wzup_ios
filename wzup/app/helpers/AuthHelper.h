//
//  AuthHelper.h
//  wzup
//
//  Created by Simen Lie on 16/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthHelper : NSObject
- (void) storeCredentials:(NSMutableDictionary *) credentials;
- (NSString*) getAuthToken;
- (NSString *) getUserId;


@end
