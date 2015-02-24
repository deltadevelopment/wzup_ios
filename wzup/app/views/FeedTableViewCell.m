//
//  FeedTableViewCell.m
//  wzup
//
//  Created by Simen Lie on 24/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "FeedTableViewCell.h"

@implementation FeedTableViewCell
UIImageView *profileImg;
UILabel *nameLabel;
UIView *availability;
UIImageView *statusImg;
UILabel *statusLabel;
- (void)awakeFromNib {
    // Initialization code
   self.separatorInset = UIEdgeInsetsZero;
    self.profileImage.layer.cornerRadius = 15;
    self.profileImage.clipsToBounds = YES;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth , 60)];
    //[view setBackgroundColor:[UIColor colorWithRed:0.557 green:0.267 blue:0.678 alpha:1]];
    
    
    profileImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15,30, 30)];
   // profileImg.image =[UIImage imageNamed:@"christer-dahl.jpeg"];
    profileImg.layer.cornerRadius = 15;
    profileImg.clipsToBounds = YES;
    
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 15,200, 30)];
    [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0]];
    //nameLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
   // nameLabel.text = @"Christer Hansen";
    
    availability = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 25, 25,15, 15)];
    [availability setBackgroundColor:[UIColor colorWithRed:0.18 green:0.8 blue:0.443 alpha:1]];
    availability.layer.cornerRadius = 7;
    availability.clipsToBounds = YES;
    
    [view addSubview:availability];
    [view addSubview:profileImg];
    [view addSubview:nameLabel];
    
    
    statusImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60,screenWidth, 180)];
    //statusImg.image =[UIImage imageNamed:@"christer-dahl.jpeg"];
   
    UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 240, screenWidth , 50)];
   // [viewBottom  setBackgroundColor:[UIColor colorWithRed:0.557 green:0.267 blue:0.678 alpha:1]];
    
    statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10,200, 30)];
    [statusLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0]];
    //nameLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        [viewBottom addSubview:statusLabel];
    [self addSubview:statusImg];
    [self addSubview:viewBottom];
    [self addSubview:view];
    
}

-(void)setStatus:(NSString*) status{
    statusLabel.text = status;

}
-(void)setName:(NSString*) name{
    nameLabel.text = name;
}
-(void)setProfileImg:(NSString*) img{
    profileImg.image =[UIImage imageNamed:img];
}
-(void)setStatusImg:(NSString*) img{
    statusImg.image =[UIImage imageNamed:img];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setAvailability:(NSInteger) av{
    //NSLog(@"%i", (int)av);
    if(av == 0){
        //available
        [availability setBackgroundColor:[UIColor colorWithRed:0.18 green:0.8 blue:0.443 alpha:1]];
    }
    else if(av == 1){
        //Busy
        NSLog(@"here");
        [availability setBackgroundColor:[UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1] ];
    }
    else if(av == 2){
        [availability setBackgroundColor:[UIColor colorWithRed:0.741 green:0.765 blue:0.78 alpha:1]];
        //SNOOZE
    }
    
}

@end
