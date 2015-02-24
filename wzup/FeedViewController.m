//
//  FirstViewController.m
//  wzup
//
//  Created by Simen Lie on 16/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "FeedViewController.h"
#import "LoginController.h"
#import "AuthHelper.h"

@interface FeedViewController ()

@end

@implementation FeedViewController
LoginController *loginController;
AuthHelper *authHelper;
UIView *top;
- (void)viewDidLoad {
    authHelper = [[AuthHelper alloc] init];
    NSLog( [authHelper getAuthToken]);
     NSLog( [authHelper getUserId]);
    [super viewDidLoad];
    
    //loginController = [[LoginController alloc] init];
    //[loginController login:@"simentest" pass:@"simentest"];
    [super viewDidLoad];
    top = [[UIView alloc] init];
    [top setFrame:CGRectMake(0, 0, 200, 35)];
    NSLog(@"%f", self.view.center.x);
    CGFloat center = (self.view.center.x/2) - (35/2);
    
    UIButton *leftButton = [self createButton:@"feed-icon.png" x:center-100];
    UIButton *middleButton = [self createButton:@"events-icon.png" x:center];
    UIButton *rightButton = [self createButton:@"profile-icon.png" x:center + 100];
    
    [top addSubview:leftButton];
    [top addSubview:middleButton];
    [top addSubview:rightButton];
    self.navigationItem.titleView = top;
}

-(UIButton *)createButton:(NSString *) img x:(int) xPos{
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *buttonImage = [UIImage imageNamed:img];
    buttonImage = [self resizeImage:buttonImage newSize:CGSizeMake(35,35)];
    [navButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [navButton setTitleColor:[UIColor colorWithRed:0.4 green:0.157 blue:0.396 alpha:1]  forState:UIControlStateNormal];
    [navButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    // [navButton bringSubviewToFront:navButton.imageView];
    
    [navButton setFrame:CGRectMake(xPos, -10, 35, 35)];
    return navButton;
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tes:(id)sender {

}
@end
