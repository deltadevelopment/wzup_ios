//
//  LoginViewController.m
//  wzup
//
//  Created by Simen Lie on 18/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
LoginController* loginController;

- (void)viewDidLoad {
    [super viewDidLoad];
    loginController = [[LoginController alloc] init];
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    // Do any additional setup after loading the view.
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
    [self.loginIndicator setHidden:false];
    [self.loginIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [loginController login:self.usernameTextField.text pass:self.passwordTextField.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [self.loginIndicator stopAnimating];
        });
        
       
    });
  
    NSLog(@"TEst");
}


-(void)loginW{
    }


@end
