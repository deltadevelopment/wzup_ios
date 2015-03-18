//
//  VideoController.h
//  wzup
//
//  Created by Simen Lie on 18/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthHelper.h"
#import "ParserHelper.h"
#import "ApplicationHelper.h"

@interface VideoController : NSObject<NSURLConnectionDataDelegate>{
    AuthHelper *authHelper;
    ParserHelper *parserHelper;
    ApplicationHelper *applicationHelper;
}
- (void)sendVideoToServer:(NSData *)imageData;
@end
