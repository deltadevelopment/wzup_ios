//
//  MainViewController.m
//  wzup
//
//  Created by Simen Lie on 27.02.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "MainViewController.h"
#import "ProfileViewController.h"
#import "Feed2ViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
UIView *top;
- (void)viewDidLoad {
    [super viewDidLoad];
    top = [[UIView alloc] init];
    [top setFrame:CGRectMake(0, 0, 200, 35)];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat center = (screenWidth/4) - (10);
    
    UIButton *leftButton = [self createButton:@"feed-icon.png" x:center-80];
    UIButton *middleButton = [self createButton:@"events-icon.png" x:center];
    UIButton *rightButton = [self createButton:@"profile-icon.png" x:center + 80];
    [rightButton addTarget:self
                    action:@selector(showProfile)
          forControlEvents:UIControlEventTouchUpInside];
    [leftButton addTarget:self
                   action:@selector(showFeed)
         forControlEvents:UIControlEventTouchUpInside];
    
    [top addSubview:leftButton];
    [top addSubview:middleButton];
    [top addSubview:rightButton];
    self.navigationItem.titleView = top;
    //self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    // Do any additional setup after loading the view.
}

-(void)showTopBar{
  
}
-(void)hideTopBar{

}

-(void)showProfile{
[self setView:[[ProfileViewController alloc] init] second:@"profileNav"];
}

-(void)showFeed{
 [self setView:[[Feed2ViewController alloc] init] second:@"feed2"];
}

-(void)setView:(UIViewController *)controller second:(NSString *) controllerString{
    //self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    controller = (UIViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:controllerString];
    //[self.window makeKeyAndVisible];
    [self.navigationController presentViewController:controller animated:NO completion:NULL];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIButton *)createButton:(NSString *) img x:(int) xPos{
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *buttonImage = [UIImage imageNamed:img];
    buttonImage = [self resizeImage:buttonImage newSize:CGSizeMake(30,30)];
    [navButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [navButton setTitleColor:[UIColor colorWithRed:0.4 green:0.157 blue:0.396 alpha:1]  forState:UIControlStateNormal];
    [navButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    // [navButton bringSubviewToFront:navButton.imageView];
    
    [navButton setFrame:CGRectMake(xPos, 0, 30, 30)];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
