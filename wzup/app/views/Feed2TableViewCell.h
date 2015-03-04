//
//  Feed2TableViewCell.h
//  wzup
//
//  Created by Simen Lie on 26.02.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Feed2TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UIImageView *availabilityPicture;
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *statusImage;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet NSString *statusImg;

-(void)setStatusImagePath:(NSString *)statusImage;
-(void)setAvailability:(NSInteger) available;
-(UIView*)getTopBar;
-(void)stopImageLoading;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageLoadingIndicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uploadImageIndicator;
@property (weak, nonatomic) IBOutlet UILabel *uploadImageIndicatorLabel;
@end
