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
CGSize keyboardSize;
CGFloat keyboardPos;
BOOL loginButtonHasChangedPos;
int padding = 15;
CGFloat buttonY;

- (void)viewDidLoad {
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
 
    
   
    [self addLine:self.usernameTextField];
     [self addLine:self.passwordTextField];
    //[[self navigationController] setNavigationBarHidden:NO animated:NO];
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
   

    
    [self.usernameTextField addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
    

}
-(void)viewDidAppear:(BOOL)animated{
    CGRect btFrame = self.loginButton.frame;
    btFrame.origin.x = 0;
    buttonY = btFrame.origin.y;
}
-(void)setTextFieldStyle:(UITextField *) textField{
    textField.borderStyle = UITextBorderStyleNone;
    [textField setBackgroundColor:[UIColor clearColor]];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

-(void)addLine:(UITextField *) textField{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, textField.frame.size.height + 5, self.view.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.741 green:0.765 blue:0.78 alpha:1].CGColor;
    [textField.layer addSublayer:bottomBorder];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldDidChange:(UITextField *) textField{
    [self showLoginButton];

}

- (void)textFieldDidBeginEditing:(NSNotification *)notification {
    loginButtonHasChangedPos = FALSE;
    [self showLoginButton];
    
}

-(void)showButton{
    loginButtonHasChangedPos = TRUE;
    self.loginButton.hidden = NO;
    CGRect btFrame = self.loginButton.frame;
    btFrame.origin.x = 0;
    
    btFrame.origin.y = buttonY- keyboardSize.height;
    self.loginButton.frame = btFrame;
    self.loginButton.alpha =0;
    
    // animate
    [UIView animateWithDuration:0.3 animations:^{
        self.loginButton.alpha = 1;
    }];
    [self.view setNeedsDisplay];
}

-(void)showLoginButton{
    if(self.usernameTextField.text.length > 0 && self.passwordTextField.text.length > 0){
        if(!loginButtonHasChangedPos){
            [self showButton];
        }
    }
    else if(self.usernameTextField.text.length == 0 || self.passwordTextField.text.length == 0){
        loginButtonHasChangedPos = FALSE;
        CGRect btFrame = self.loginButton.frame;
        btFrame.origin.x = 0;
        btFrame.origin.y = buttonY + keyboardSize.height;
        self.loginButton.frame = btFrame;
    }
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

    NSDictionary* info = [note userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    keyboardSize = [aValue CGRectValue].size;
    loginButtonHasChangedPos = FALSE;
    [self showLoginButton];
    

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
