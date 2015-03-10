//
//  StartViewController.m
//  wzup
//
//  Created by Simen Lie on 17/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "StartViewController.h"
#import "FollowModel.h"
@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Start");
    FollowModel *f = [[FollowModel alloc] init];
   //[[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
   
}
-(void)viewWillAppear:(BOOL)animated{
 //[[self navigationController] setNavigationBarHidden:YES animated:NO];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
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
