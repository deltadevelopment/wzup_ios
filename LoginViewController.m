//
//  LoginViewController.m
//  wzup
//
//  Created by Simen Lie on 18/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginController.h"
#import "FeedViewController.h"
#import "StartViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
LoginController* loginController;

- (void)viewDidLoad {
    verticalSpaceConstraintButton = self.verticalSpaceConstraint;
    [self addLine:self.usernameTextField];
    [self addLine:self.passwordTextField];
    [super viewDidLoad];
    loginController = [[LoginController alloc] init];
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    [self setTextFieldStyle:self.usernameTextField];
    [self setTextFieldStyle:self.passwordTextField];
    
    self.loginButton.hidden = YES;
    
    [self.usernameTextField addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
    [self setPlaceholderFont:self.usernameTextField];
    [self setPlaceholderFont:self.passwordTextField];
}
-(void)viewDidAppear:(BOOL)animated{
    [self.usernameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldDidChange:(UITextField *) textField{
    //[self showLoginButton];
    [self showLogin];

}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.usernameTextField){
        [self.usernameTextField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
        return YES;
    }
    else if(textField == self.passwordTextField){
        [self login:nil];
        [self.passwordTextField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (IBAction)login:(id)sender {
    //call on login controllers login method
    [self.loginIndicator setHidden:NO];
        
    [self.loginIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [loginController login:self.usernameTextField.text pass:self.passwordTextField.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [self.loginIndicator stopAnimating];
            if([loginController hasError]){
                [self errorAnimation];
            }else{
                 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 FeedViewController *viewController = (FeedViewController *)[storyboard instantiateViewControllerWithIdentifier:@"feed"];
                 [self presentViewController:viewController animated:YES completion:nil];
                
            }
        });
    });
}
-(void)showLogin{
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    if(username.length > 0 && password.length > 0){
        self.loginButton.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.loginButton.alpha = 1;
        }];
    }
    else if(username.length == 0 || password.length == 0){
        self.loginButton.hidden = YES;
        self.loginButton.alpha =0;
    }
}

@end
