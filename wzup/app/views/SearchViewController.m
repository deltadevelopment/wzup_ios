//
//  SearchViewController.m
//  wzup
//
//  Created by Simen Lie on 10/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
bool sendRequest;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLine:self.searchTextField];
    self.searchTextField.delegate = self;
    [self setTextFieldStyle:self.searchTextField];
    [self setPlaceholderFont:self.searchTextField];
    self.searchIcon.alpha = 0.5f;
    [self.searchTextField addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
    [self.searchTextField addTarget:self
                             action:@selector(textFieldDidEndEditing:)
                   forControlEvents:UIControlEventEditingDidEnd];
    
    self.indicator.hidden = YES;
    // Do any additional setup after loading the view.
}

-(void)textFieldDidChange:(UITextField *) textField{
    self.userLabel.text = textField.text;
    self.indicator.hidden = NO;
    NSLog(@"here");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidEndEditing:(UITextField *) textField{
    NSLog(@"here");
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    sendRequest = NO;
    return YES;
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    sendRequest = YES;
    return YES;
}

-(void)addLine:(UITextField *) textField{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, textField.frame.size.height + 5, self.view.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.741 green:0.765 blue:0.78 alpha:1].CGColor;
    [textField.layer addSublayer:bottomBorder];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 50, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
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
