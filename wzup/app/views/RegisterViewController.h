//
//  RegisterViewController.h
//  wzup
//
//  Created by Simen Lie on 20/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationViewController.h"

@interface RegisterViewController : ApplicationViewController<UITextFieldDelegate>
- (IBAction)reg:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *usernameError;
@property (weak, nonatomic) IBOutlet UILabel *passwordError;
@property (weak, nonatomic) IBOutlet UILabel *emailError;
@property (weak, nonatomic) IBOutlet UIButton *regButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceConstraint;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *regIndicator;
@end
