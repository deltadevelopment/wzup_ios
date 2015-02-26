//
//  FeedTableViewCell.h
//  wzup
//
//  Created by Simen Lie on 24/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedTableViewCell : UITableViewCell{
    UIImage * status;
    BOOL isSelected;

    
}
@property (weak, nonatomic) IBOutlet UILabel *statusText;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIView *view;
@property bool shouldExpand;
-(void)setStatus:(NSString*) status;
-(void)setName:(NSString*) name;
-(void)setProfileImg:(NSString*) img;
-(void)setStatusImg:(NSString*) img;
-(void)setAvailability:(NSInteger) av;
-(void)initCell;
-(void)drawCell;
-(void)setIndexPath:(NSIndexPath *) path;
-(void)changeSize :(UIImage * ) img;
-(void) resetView;
-(void)anim;
-(UIView*)getView;
-(void)setExpand:(BOOL) s;
@end
