//
//  SettingsTableViewController.m
//  wzup
//
//  Created by Simen Lie on 24/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "SettingsController.h"
#import "ProfileController.h"
#import "UserModel.h"
#import "AuthHelper.h"
@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController{
    SettingsController *settingsController;
    ProfileController *profileController;
    UserModel *user;
    AuthHelper *authHelper;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"debugMode"] != nil) {
        bool debugMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"debugMode"];
        if(debugMode){
            [self.showErrorsSwitch setOn:YES];
        }else{
            [self.showErrorsSwitch setOn:NO];
        }
    }
    else{
        [self.showErrorsSwitch setOn:NO];
    }
    settingsController = [[SettingsController alloc]init];
    profileController = [[ProfileController alloc]init];
    authHelper = [[AuthHelper alloc]init];
    //Requesting user
    [profileController requestUser:self withSuccess:@selector(userWasReturned:) withError:@selector(userWasNotReturned:)];
    self.profileCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.changePasswordCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.serverCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

}
-(void)userWasReturned:(NSData *) data{
    NSString *strdata=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",strdata);
    user = [[profileController getUser:data] getUser];
    //NSLog(@"user profile: %@", [[user private_profile]]);
    [self.privateToggleSwitch setOn:[user private_profile] animated:YES];
}

-(void)userWasNotReturned:(NSError *) error{
    
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

- (IBAction)togglePrivateProfile:(id)sender {
    
    [settingsController changePrivateProfile:self.privateToggleSwitch.isOn withObject:self withSuccess:@selector(didChangePrivateProfile:) withError:@selector(didNotChangePrivateProfile:)];
    
}

-(void)didChangePrivateProfile:(NSData *) data{
    NSLog(@"profile private changed");
}

-(void)didNotChangePrivateProfile:(NSError *) error{
    NSLog(@"error");
}



- (IBAction)editProfileAction:(id)sender {
}

- (IBAction)changePasswordAction:(id)sender {
}

- (IBAction)logoutAction:(id)sender {

    [self showLoginAlert];
}

-(void)showLoginAlert{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Log out"
                                                   message:@"Are you sure you want to log out?"
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Ok",nil];
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //ikke logg ut
    }else{
        //Logg ut
        [authHelper resetCredentials];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UINavigationController *navigation =[mainStoryboard instantiateViewControllerWithIdentifier:@"startNav"];
        [self presentViewController:navigation animated:NO completion:nil];
    }
}

- (IBAction)showErrorsToggle:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.showErrorsSwitch.isOn forKey:@"debugMode"];
    
}

- (IBAction)toggleServerAction:(id)sender {

}
@end
