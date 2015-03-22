//
//  Feed2ViewController.h
//  wzup
//
//  Created by Simen Lie on 26.02.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
@interface FeedViewController : MainViewController<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusButtonverticalSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusButtonHorizontalSpace;
@property (weak, nonatomic) IBOutlet UIView *availabilityView;
@property (weak, nonatomic) IBOutlet UILabel *statusText;
- (IBAction)addStatus:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)cancelStatus:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *indicatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicatorHorizontalSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusButtonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusButtonWidth;

-(void)imageIsUploaded;
@end
