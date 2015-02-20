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

- (void)viewDidLoad {
    authHelper = [[AuthHelper alloc] init];
    NSLog( [authHelper getAuthToken]);
     NSLog( [authHelper getUserId]);
    [super viewDidLoad];
    
    //loginController = [[LoginController alloc] init];
    //[loginController login:@"simentest" pass:@"simentest"];
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
