//
//  SearchViewController.h
//  wzup
//
//  Created by Simen Lie on 10/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationViewController.h"
@interface SearchViewController : ApplicationViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIImageView *searchIcon;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
