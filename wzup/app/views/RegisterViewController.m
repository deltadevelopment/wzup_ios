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
    self.regButton.hidden = YES;
    verticalSpaceConstraintButton = self.verticalSpaceConstraint;
    [self addLine:self.usernameTextField];
    [self addLine:self.passwordTextField];
    [self addLine:self.emailTextField];
    
    [self hideErrors];
    
    registerController = [[RegisterController alloc] init];
    loginController = [[LoginController alloc] init];
    [super viewDidLoad];
    [self setTextFieldStyle:self.usernameTextField];
    [self setTextFieldStyle:self.emailTextField];
    [self setTextFieldStyle:self.passwordTextField];
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.emailTextField.delegate = self;
    
    [self.usernameTextField addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
    [self.emailTextField addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
    
    [self setPlaceholderFont:self.usernameTextField];
    [self setPlaceholderFont:self.passwordTextField];
    [self setPlaceholderFont:self.emailTextField];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidChange:(UITextField *) textField{
    //[self showLoginButton];
    [self showRegister];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self.usernameTextField becomeFirstResponder];
}
-(void)showRegister{
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
     NSString *email = self.emailTextField.text;
    if(username.length > 0 && password.length > 0 && email.length > 0){
        self.regButton.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.regButton.alpha = 1;
        }];
    }
    else if(username.length == 0 || password.length == 0 || email.length == 0){
        self.regButton.hidden = YES;
        self.regButton.alpha =0;
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)hideErrors{
    [self.usernameError setHidden:TRUE];
    [self.passwordError setHidden:TRUE];
    [self.emailError setHidden:TRUE];
}

- (IBAction)reg:(id)sender {
    [self hideErrors];
    [self.regIndicator setHidden:NO];
    
    [self.regIndicator startAnimating];
    
    [registerController registerUser:self.usernameTextField.text
                                pass:self.passwordTextField.text
                               email:self.emailTextField.text
                          withObject:self
                         withSuccess:@selector(registerWasSuccessful:)
                           withError:@selector(registerWasNotSuccessful:)];

}
-(void)registerWasSuccessful:(NSData *) data{
 NSString *strdata=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(strdata);
    [self.regIndicator stopAnimating];
    [loginController login:self.usernameTextField.text
                      pass:self.passwordTextField.text
                withObject:self
               withSuccess:@selector(loginWasSuccessful:)
                 withError:@selector(loginWasNotSuccessful:)];
     
}

-(void)registerWasNotSuccessful:(NSError *) error{
    [registerController parseData:[error userInfo]];
    
    //[self errorAnimation];
    [self.regIndicator stopAnimating];
    [self showError:self.usernameError errorMsg:[registerController getUsernameError]];
    [self showError:self.emailError errorMsg:[registerController getEmailError]];
    [self showError:self.passwordError errorMsg:[registerController getPasswordError]];
    
}

-(void)loginWasSuccessful:(NSData *) data{
    [self.regIndicator stopAnimating];
    [loginController storeCredentials:data];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FeedViewController *viewController = (FeedViewController *)[storyboard instantiateViewControllerWithIdentifier:@"feed2"];
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void)loginWasNotSuccessful:(NSError *) error{
    [self.regIndicator stopAnimating];
    [self errorAnimation];
    
  
}

-(void)showError:(UILabel*) errorLabel
        errorMsg:(NSString*) error {
    
    if(error != nil){
        [errorLabel setHidden:false];
        errorLabel.text = error;
    }
   
    
}
@end
