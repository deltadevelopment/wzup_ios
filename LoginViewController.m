//
//  LoginViewController.m
//  wzup
//
//  Created by Simen Lie on 18/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginController.h"
#import "StartViewController.h"
#import "FeedViewController.h"
#import "FeedNavigationViewController.h"
#import "NotificationHelper.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
LoginController* loginController;

- (void)viewDidLoad {
    NSLog([[UIDevice currentDevice] name]);
    NSString *name = [[UIDevice currentDevice] name];
    if(![name isEqualToString:@"Simen sin iPhone"]){
        self.usernameTextField.text = @"christiandalsvaag";
        self.passwordTextField.text = @"christiandalsvaag";
    }
    

    
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
    [self showLogin];
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
    
    [loginController login:self.usernameTextField.text
                      pass:self.passwordTextField.text
                withObject:self
               withSuccess:@selector(loginWasSuccessful:)
                 withError:@selector(loginWasNotSuccessful:)];
    NSLog(@"logging in");
}

-(void)loginWasSuccessful:(NSData *) data{
    [self.loginIndicator stopAnimating];
    [loginController storeCredentials:data];
   // [self setView:[[Feed2ViewController alloc] init] second:@"feed2"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FeedViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"feed2"];
    [sfvc setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentModalViewController:sfvc animated:YES];
    
    
    
}

-(void)setView:(UIViewController *)controller second:(NSString *) controllerString{
    //self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    controller = (UIViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:controllerString];
    FeedNavigationViewController *nav= (UIViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:controllerString];
    //[self makeKeyAndVisible];
    [nav popToRootViewControllerAnimated:YES];
    [self presentViewController:nav animated:NO completion:NULL];
}

-(void)loginWasNotSuccessful:(NSError *) error{
    NotificationHelper *notificationHelper =[[NotificationHelper alloc]initNotification];
    [notificationHelper addNotificationToView:self.navigationController.view];
    [self.loginIndicator stopAnimating];
    //[self errorAnimation];
    //parse data here
    NSLog([error localizedDescription]);
}


-(void)showLogin{
  
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
      NSLog(@"login show %@ %@", username, password);
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
