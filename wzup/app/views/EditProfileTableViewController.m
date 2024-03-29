//
//  EditProfileTableViewController.m
//  wzup
//
//  Created by Simen Lie on 24/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "EditProfileTableViewController.h"
#import "SettingsController.h"
#import "ProfileController.h"
#import "UserModel.h"
#import "AuthHelper.h"
#import "ApplicationHelper.h"
@interface EditProfileTableViewController ()

@end

@implementation EditProfileTableViewController{
    SettingsController *settingsController;
    ProfileController *profileController;
    UserModel *user;
    AuthHelper *authHelper;
    ApplicationHelper *applicationHelper;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    settingsController = [[SettingsController alloc]init];
    profileController = [[ProfileController alloc]init];
    applicationHelper = [[ApplicationHelper alloc]init];
    authHelper = [[AuthHelper alloc]init];
    //Requesting user
    [profileController requestUser:self withSuccess:@selector(userWasReturned:) withError:@selector(userWasNotReturned:)];
    self.tableView.allowsSelection = NO;
    self.emailTextField.delegate = self;
    self.displayNameTextField.delegate = self;
    self.phoneNumberTextField.delegate = self;


}



-(BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    NSLog(@"the string; %@ andfield: %@", string, textField.text);
    if(textField == self.phoneNumberTextField){
        if ([string isEqualToString:@""]) {
            NSLog(@"Backspace");
            int length = textField.text.length;
            if([[textField.text substringFromIndex:length - 1] isEqualToString:@" "]){
                textField.text = [textField.text substringToIndex:textField.text.length-1];
            }
        }else{
            self.phoneNumberTextField.text = [self formatNumber:textField.text];
        }
    }
  
    return YES;
}

-(NSString *)formatNumber:(NSString *)text
{
    if(text.length == 3){
        text=[NSString stringWithFormat:@"%@ ", text];
    }
    else  if(text.length == 6){
        text=[NSString stringWithFormat:@"%@ ", text];
    }
  
    return text;
}
-(NSString *)formatPhoneNumber:(NSString *) text
{
  
NSString *finalString = [NSString stringWithFormat:@"%@ %@ %@", [text substringWithRange:NSMakeRange(0, 3)],[text substringWithRange:NSMakeRange(3, 2)],[text substringWithRange:NSMakeRange(5, 3)]];
    
    return  finalString;
}


-(void)userWasReturned:(NSData *) data{
    user = [[profileController getUser:data] getUser];
    NSString *phoneNumber = [user getPhoneNumber] == 0 ? @"" : [NSString stringWithFormat:@"%d", [user getPhoneNumber]];

    self.emailTextField.text = [user getEmail];
    self.displayNameTextField.text = [user getDisplayName];
    self.phoneNumberTextField.text = [self formatPhoneNumber:phoneNumber];
    
}


-(void)userWasNotReturned:(NSError *) error{

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
    

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneAction:(id)sender {
    NSString *phoneNumber = [self.phoneNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [settingsController saveProfile:self.displayNameTextField.text withPhoneNumber:phoneNumber withEmail:self.emailTextField.text withObject:self withSuccess:@selector(userWasSaved:) withError:@selector(userWasNotSaved:)];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)userWasSaved:(NSData *) data{
    NSLog(@"user saved");
}

-(void)userWasNotSaved:(NSError *) error{
    
}


- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
