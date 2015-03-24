//
//  MainViewController.h
//  wzup
//
//  Created by Simen Lie on 27.02.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
-(void)showTopBar;
-(CGSize)getSize;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize img:(UIImage *) sourceImage;
-(UIImage*)getCroppedImage:(UIImage*)sourceImage;
-(void)setView:(UIViewController *)controller second:(NSString *) controllerString;
@end
