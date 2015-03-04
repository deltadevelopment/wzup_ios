//
//  Feed2TableViewCell.m
//  wzup
//
//  Created by Simen Lie on 26.02.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "Feed2TableViewCell.h"

@implementation Feed2TableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self attachUiToCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)attachUiToCell{
    NSLog(@"cropping");
    self.editStatusTextField.borderStyle = UITextBorderStyleNone;
    [self.editStatusTextField setBackgroundColor:[UIColor clearColor]];
    self.editStatusTextField.hidden = YES;
    self.tickImage.hidden = YES;
    self.tickImage.alpha = 0.0;
    self.captionTick.hidden = YES;
    self.captionTick.alpha = 0.0;
   self.uploadImageIndicatorLabel.hidden = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
   self.availabilityPicture.backgroundColor = [UIColor colorWithRed:0.18 green:0.8 blue:0.443 alpha:1];
    self.availabilityPicture.layer.cornerRadius = 7;
    self.availabilityPicture.clipsToBounds = YES;
    self.profilePicture.layer.cornerRadius = 15;
    self.profilePicture.clipsToBounds = YES;
    self.bottomBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9f];
    
    
    
    //UIImage * image = [UIImage imageNamed:@"testBilde.jpg"];
    //image = [self imageByScalingAndCroppingForSize:size img:image];
    //[self.statusImage setBackgroundColor:[UIColor colorWithPatternImage:image]];
    
}

-(UIView*)getTopBar{
    return self.topBar;
}

-(void)stopImageLoading{
    [_imageLoadingIndicator stopAnimating];
    _imageLoadingIndicator.hidden = YES;
    
}
-(void)setAvailability:(NSInteger) available{
    //NSLog(@"%i", (int)av);
    if(available == 0){
        //available
        [self.availabilityPicture setBackgroundColor:[UIColor colorWithRed:0.18 green:0.8 blue:0.443 alpha:1]];
    }
    else if(available == 1){
        //Busy
        [self.availabilityPicture setBackgroundColor:[UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1] ];
    }
    else if(available == 2){
        [self.availabilityPicture setBackgroundColor:[UIColor colorWithRed:0.741 green:0.765 blue:0.78 alpha:1]];
        //SNOOZE
    }
    
}





@end
