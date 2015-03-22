//
//  UIHelper.m
//  wzup
//
//  Created by Simen Lie on 22.03.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "UIHelper.h"
static CGRect screenBound;
static CGSize screenSize;
static CGFloat screenWidth;
@implementation UIHelper

+(void)initialize{
    screenBound = [[UIScreen mainScreen] bounds];
    screenSize = screenBound.size;
    screenWidth = screenSize.width;
}

+(CGSize)getSize{
    CGSize size = CGSizeMake(screenWidth, 549);
    return size;
}

+(CGRect)getFrame{
    NSLog(@"screenWidth %f", screenWidth);
    return CGRectMake(0, 0, screenWidth, 500);
}

@end
