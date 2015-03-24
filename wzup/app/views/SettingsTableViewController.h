//
//  SettingsTableViewController.h
//  wzup
//
//  Created by Simen Lie on 24/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController
- (IBAction)togglePrivateProfile:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *privateToggleSwitch;
- (IBAction)editProfileAction:(id)sender;
- (IBAction)changePasswordAction:(id)sender;
- (IBAction)logoutAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serverLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *profileCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *changePasswordCell;
- (IBAction)showErrorsToggle:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *showErrorsSwitch;
@property (weak, nonatomic) IBOutlet UITableViewCell *serverCell;


- (IBAction)toggleServerAction:(id)sender;

@end
