//
//  ProfileNavigationViewController.m
//  wzup
//
//  Created by Simen Lie on 06/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ProfileNavigationViewController.h"
#import "ProfileViewController.h"

@interface ProfileNavigationViewController ()

@end

@implementation ProfileNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    [vc setOwnProfile:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
