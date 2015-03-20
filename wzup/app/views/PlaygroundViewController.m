//
//  PlaygroundViewController.m
//  wzup
//
//  Created by Simen Lie on 20/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "PlaygroundViewController.h"
#import "CircleIndicator.h"

@interface PlaygroundViewController ()

@end

@implementation PlaygroundViewController
CGFloat startAngle;
CGFloat endAngle;
int _percent;
CircleIndicator *circle;

- (void)viewDidLoad {
//
    [super viewDidLoad];
    circle = [[CircleIndicator alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:circle];
    [circle setIndicatorWithMaxTime:30];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(decrementSpin) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)decrementSpin{
    [circle incrementSpin];
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
