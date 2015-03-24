//
//  ServerTableViewController.h
//  wzup
//
//  Created by Simen Lie on 24/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServerTableViewController : UITableViewController<UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
- (IBAction)doneAction:(id)sender;
- (IBAction)cancelAction:(id)sender;


@end
