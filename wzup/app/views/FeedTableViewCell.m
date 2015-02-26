//
//  FeedTableViewCell.m
//  wzup
//
//  Created by Simen Lie on 24/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "FeedTableViewCell.h"
#import "ApplicationHelper.h"
@implementation FeedTableViewCell
UIImageView *profileImg;
UILabel *nameLabel;
UIView *availability;
UIImageView *statusImg;
UIView *statusImgView;
UILabel *statusLabel;
bool isDrawed;
NSIndexPath *indexPath;


- (void)awakeFromNib {
   
  
}
-(void)viewDidLOad{
    
}

-(void)initCell{
    // Initialization code
    //231 per celle
    //top = 48
    //bilde = 145
    //nede 38
    self.separatorInset = UIEdgeInsetsZero;
    self.profileImage.layer.cornerRadius = 15;
    self.profileImage.clipsToBounds = YES;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth , 48)];
    //[view setBackgroundColor:[UIColor colorWithRed:0.557 green:0.267 blue:0.678 alpha:1]];
    
    
    profileImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10,30, 30)];
    // profileImg.image =[UIImage imageNamed:@"christer-dahl.jpeg"];
    profileImg.layer.cornerRadius = 15;
    profileImg.clipsToBounds = YES;
    
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 8,200, 30)];
    [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0]];
    //nameLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    // nameLabel.text = @"Christer Hansen";
    
    availability = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 25, 18,15, 15)];
    [availability setBackgroundColor:[UIColor colorWithRed:0.18 green:0.8 blue:0.443 alpha:1]];
    
    availability.layer.cornerRadius = 7;
    availability.clipsToBounds = YES;
    
    [view addSubview:availability];
    [view addSubview:profileImg];
    [view addSubview:nameLabel];
    
    
    //statusImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60,screenWidth, 180)];
    statusImgView = [[UIView alloc] initWithFrame:CGRectMake(0, 48,screenWidth, 145)];
    UITapGestureRecognizer *tapGr;
    tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGr.numberOfTapsRequired = 1;
    [view addGestureRecognizer:tapGr];
    //statusImg.contentMode = UIViewContentModeTopLeft;
    //statusImg.image =[UIImage imageNamed:@"christer-dahl.jpeg"];
    
    viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 193, screenWidth , 38)];
    // [viewBottom  setBackgroundColor:[UIColor colorWithRed:0.557 green:0.267 blue:0.678 alpha:1]];
    
    statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 3,200, 30)];
    [statusLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0]];
    //nameLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    UIView *viewAll = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth , 290)];
    [viewBottom addSubview:statusLabel];
    [viewAll addSubview:statusImgView];
    [viewAll addSubview:viewBottom];
    [viewAll addSubview:view];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:viewAll];
}

-(void)handleTap:(UITapGestureRecognizer *) sender{
 
    [[[ApplicationHelper alloc] init] setIndex:indexPath];
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
    
    if(status == nil){
        status =[UIImage imageNamed:img];
        status = [self imageByScalingAndCroppingForSize:statusImgView.frame.size img:status];
        [statusImgView setBackgroundColor:[UIColor colorWithPatternImage:status]];
    }
   
  
}
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    return YES;
}

-(void)changeSize{
     NSLog(@"change size");
    CGRect rect = viewBottom.frame;
    rect.origin.y  = 500 - 38;
    viewBottom.frame = rect;
    
}
-(void) resetView{
    NSLog(@"reset");
    CGRect rect = viewBottom.frame;
    rect.origin.y  = 193;
    viewBottom.frame = rect;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

-(void)setIndexPath:(NSIndexPath *) path{
    indexPath = path;
}
-(void)setAvailability:(NSInteger) av{
    //NSLog(@"%i", (int)av);
    if(av == 0){
        //available
        [availability setBackgroundColor:[UIColor colorWithRed:0.18 green:0.8 blue:0.443 alpha:1]];
    }
    else if(av == 1){
        //Busy
        [availability setBackgroundColor:[UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1] ];
    }
    else if(av == 2){
        [availability setBackgroundColor:[UIColor colorWithRed:0.741 green:0.765 blue:0.78 alpha:1]];
        //SNOOZE
    }
    
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize img:(UIImage *) sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = 0;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = 0;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
