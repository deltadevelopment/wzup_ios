//
//  FirstViewController.m
//  wzup
//
//  Created by Simen Lie on 16/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "FirstViewController.h"
#import "LoginController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
LoginController *loginController;

- (void)viewDidLoad {
    [super viewDidLoad];
    loginController = [[LoginController alloc] init];
    [loginController login:@"simentest" pass:@"simentest"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
