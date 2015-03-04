//
//  Feed2ViewController.h
//  wzup
//
//  Created by Simen Lie on 26.02.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
@interface Feed2ViewController : MainViewController<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusButtonverticalSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusButtonHorizontalSpace;
@property (weak, nonatomic) IBOutlet UIView *availabilityView;
@property (weak, nonatomic) IBOutlet UILabel *statusText;
- (IBAction)addStatus:(id)sender;

-(void)imageIsUploaded;
@end
