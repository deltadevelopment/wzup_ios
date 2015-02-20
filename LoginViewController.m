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
CGPoint originalCenter;
- (void)viewDidLoad {
    originalCenter = self.loginButton.center;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [super viewDidLoad];
    loginController = [[LoginController alloc] init];
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    [self setTextFieldStyle:self.usernameTextField];
    [self setTextFieldStyle:self.passwordTextField];
    // Do any additional setup after loading the view.
    self.loginButton.hidden = YES;
    CGRect btFrame = self.loginButton.frame;
    btFrame.origin.x = 0;
    btFrame.origin.y = 370;
    self.loginButton.frame = btFrame;
}
-(void)setTextFieldStyle:(UITextField *) textField{
    textField.borderStyle = UITextBorderStyleNone;
    [textField setBackgroundColor:[UIColor clearColor]];
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
- (void)keyboardDidShow:(NSNotification *)note
{
  //  self.loginButton.center = CGPointMake(originalCenter.x, originalCenter.y + 10);
     self.loginButton.hidden = NO;
    CGRect btFrame = self.loginButton.frame;
    btFrame.origin.x = 0;
    btFrame.origin.y = 370;
    self.loginButton.frame = btFrame;
}
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
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
            if([loginController hasError]){
                [self.view setBackgroundColor:[UIColor colorWithRed:0.957 green:0.263 blue:0.212 alpha:1]];
               
                //Animate to black color over period of two seconds (changeable)
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:2];
                [self.view setBackgroundColor:[UIColor whiteColor]];
                
                [UIView commitAnimations];
            }else{
                 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 FeedViewController *viewController = (FeedViewController *)[storyboard instantiateViewControllerWithIdentifier:@"feed"];
                 [self presentViewController:viewController animated:YES completion:nil];
                
            }
        });
    });
}



- (IBAction)back:(id)sender {
   // LoginViewController *loginView = [[LoginViewController alloc] init];
   
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StartViewController *viewController = (StartViewController *)[storyboard instantiateViewControllerWithIdentifier:@"start"];
    [self presentViewController:viewController animated:NO completion:nil];
     //[self.navigationController pushViewController:viewController animated:NO];
}
@end
