//
//  ApplicationViewController.h
//  wzup
//
//  Created by Simen Lie on 24.02.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplicationViewController : UIViewController{
    CGSize keyboardSize;
    NSLayoutConstraint* verticalSpaceConstraintButton;

}
    -(void)addLine:(UITextField *) textField;
-(void)setTextFieldStyle:(UITextField *) textField;
-(void)errorAnimation;
-(void)setPlaceholderFont:(UITextField *) textField;

@end
