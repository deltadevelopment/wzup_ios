//
//  Feed2TableViewCell.h
//  wzup
//
//  Created by Simen Lie on 26.02.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FeedTableViewCell : UITableViewCell{
  bool isPlaying;
}
@property (nonatomic) bool isPlaying;
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
-(void)getVideo:(NSData *)data withId:(NSInteger *) intId;
- (IBAction)playVideo;
-(void)stopVideo;
-(void)setVideoDoneCallback:(NSObject *) callbackView withSuccess:(SEL) success;
-(void)showVideoIcon;
-(void)hideVideoIcon;
-(UIImage*)getThumbnail;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageLoadingIndicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uploadImageIndicator;
@property (weak, nonatomic) IBOutlet UILabel *uploadImageIndicatorLabel;
@property (weak, nonatomic) IBOutlet UITextField *editStatusTextField;
@property (weak, nonatomic) IBOutlet UIImageView *tickImage;
@property (weak, nonatomic) IBOutlet UIImageView *captionTick;

@end
