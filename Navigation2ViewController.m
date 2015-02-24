//
//  Navigation2ViewController.m
//  wzup
//
//  Created by Simen Lie on 24/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "Navigation2ViewController.h"

@interface Navigation2ViewController ()

@end

@implementation Navigation2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
-(void)viewDidLayoutSubviews{
    
 [self.navigationBar setFrame:CGRectMake(0, 0, self.navigationBar.frame.size.width, 80)];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
