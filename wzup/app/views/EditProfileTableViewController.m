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
@interface EditProfileTableViewController ()

@end

@implementation EditProfileTableViewController{
    SettingsController *settingsController;
    ProfileController *profileController;
    UserModel *user;
    AuthHelper *authHelper;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    settingsController = [[SettingsController alloc]init];
    profileController = [[ProfileController alloc]init];
    authHelper = [[AuthHelper alloc]init];
    //Requesting user
    [profileController requestUser:self withSuccess:@selector(userWasReturned:) withError:@selector(userWasNotReturned:)];
    self.tableView.allowsSelection = NO;
    self.emailTextField.delegate = self;
    self.displayNameTextField.delegate = self;
    self.phoneNumberTextField.delegate = self;
}


-(void)userWasReturned:(NSData *) data{
    user = [[profileController getUser:data] getUser];
    NSString *phoneNumber = [user getPhoneNumber] == 0 ? @"" : [NSString stringWithFormat:@"%d", [user getPhoneNumber]];

    self.emailTextField.text = [user getEmail];
    self.displayNameTextField.text = [user getDisplayName];
    self.phoneNumberTextField.text = phoneNumber;
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
    [settingsController saveProfile:self.displayNameTextField.text withPhoneNumber:self.phoneNumberTextField.text withEmail:self.emailTextField.text withObject:self withSuccess:@selector(userWasSaved:) withError:@selector(userWasNotSaved:)];
    
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
