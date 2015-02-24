//
//  LoginViewController.h
//  wzup
//
//  Created by Simen Lie on 18/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationViewController.h"

@interface LoginViewController : ApplicationViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginIndicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceConstraint;

@end
