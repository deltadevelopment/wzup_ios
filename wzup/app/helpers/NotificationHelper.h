//
//  NotificationHelper.h
//  wzup
//
//  Created by Simen Lie on 08/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ParserHelper.h"
@interface NotificationHelper : NSObject
-(id) initNotification;
-(void)addNotificationToView:(UIView *) view;
-(void)setNotificationMessage:(NSData *) responseData;

@end
