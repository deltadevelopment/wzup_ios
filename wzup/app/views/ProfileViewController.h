//
//  ProfileViewController.h
//  wzup
//
//  Created by Simen Lie on 26/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
-(void)setProfile:(NSString* ) profilename;
@end
