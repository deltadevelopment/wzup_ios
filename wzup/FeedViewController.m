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
#import "FeedController.h"
#import "StatusModel.h"
#import "UserModel.h"
#import "FeedTableViewCell.h"

@interface FeedViewController ()

@end

@implementation FeedViewController
LoginController *loginController;
AuthHelper *authHelper;
UIView *top;
NSMutableArray *feed;
- (void)viewDidLoad {
    FeedController* feedController = [[FeedController alloc] init];
    feed = [feedController getFeed];
    NSLog(@"%lu", (unsigned long)[feed count]);
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [feed count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    static NSString *CellIdentifier = @"feedCell";
    FeedTableViewCell *cell = (FeedTableViewCell *)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell initCell];
    if(cell == nil){
        cell = [[FeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"feedCell"];
    }

    StatusModel *statusmodel = [feed objectAtIndex:indexPath.row];
    UserModel *userModel = [statusmodel getUser];
    [cell setStatus:[statusmodel getBody]];
    [cell setName:[[statusmodel getUser] getUsername]];
    [cell setProfileImg:@"miranda-kerr.jpg"];
    [cell setStatusImg:@"miranda-kerr.jpg"];
    [cell setAvailability:[[statusmodel getUser] getAvailability]];
    
   // NSLog(@"%@", [[statusmodel getUser] getAvailability]);
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 290;
}

-(void)viewDidLayoutSubviews
{
    if ([_tableviewe respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableviewe setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableviewe respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableviewe setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}





@end
