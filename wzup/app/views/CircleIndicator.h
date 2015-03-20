//
//  CircleIndicator.h
//  wzup
//
//  Created by Simen Lie on 20/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleIndicator : UIView{
    CGFloat startAngle;
    CGFloat endAngle;
}
@property (nonatomic) float percent;
-(void)setIndicatorWithMaxTime:(float) time;
-(void)incrementSpin;
@end
