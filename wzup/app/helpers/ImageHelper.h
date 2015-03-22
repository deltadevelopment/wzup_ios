//
//  ImageHelper.h
//  wzup
//
//  Created by Simen Lie on 21.03.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageHelper : NSObject

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize img:(UIImage *) sourceImage;
- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize;

@end
