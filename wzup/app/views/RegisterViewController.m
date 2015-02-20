//
//  RegisterViewController.m
//  wzup
//
//  Created by Simen Lie on 20/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterController.h"
#import "FeedViewController.h"
#import "LoginController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
RegisterController *registerController;
LoginController *loginController;
- (void)viewDidLoad {
    [self.usernameError setHidden:TRUE];
    [self.passwordError setHidden:TRUE];
    [self.emailError setHidden:TRUE];
    
    registerController = [[RegisterController alloc] init];
    loginController = [[LoginController alloc] init];
    [super viewDidLoad];
    [self setTextFieldStyle:self.usernameTextField];
    [self setTextFieldStyle:self.emailTextField];
    [self setTextFieldStyle:self.passwordTextField];
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.emailTextField.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField == self.usernameTextField){
        [self.usernameTextField resignFirstResponder];
        [self.emailTextField becomeFirstResponder];
        return YES;
    }
    else if(textField == self.emailTextField){
        [self.emailTextField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
        return YES;
    }
    else if(textField == self.passwordTextField){
        [self reg:nil];
        [self.passwordTextField resignFirstResponder];
        return NO;
    }
    return YES;
}


-(void)setTextFieldStyle:(UITextField *) textField{
    textField.borderStyle = UITextBorderStyleNone;
    [textField setBackgroundColor:[UIColor clearColor]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)reg:(id)sender {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [registerController registerUser:self.usernameTextField.text
                                    pass:self.passwordTextField.text
                                   email:self.emailTextField.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            
            if([registerController hasError]){
                
                [self showError:self.usernameError errorMsg:[registerController getUsernameError]];
                 [self showError:self.emailError errorMsg:[registerController getEmailError]];
                 [self showError:self.passwordError errorMsg:[registerController getPasswordError]];
                
            }else{
                [loginController login:self.usernameTextField.text
                                  pass:self.passwordTextField.text ];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                FeedViewController *viewController = (FeedViewController *)[storyboard instantiateViewControllerWithIdentifier:@"feed"];
                [self presentViewController:viewController animated:YES completion:nil];
            }
        });
    });
}

-(void)showError:(UILabel*) errorLabel
        errorMsg:(NSString*) error {
    
    if(error != nil){
        [errorLabel setHidden:false];
        errorLabel.text = error;
    }
   
    
}
@end
