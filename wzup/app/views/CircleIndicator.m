//
//  CircleIndicator.m
//  wzup
//
//  Created by Simen Lie on 20/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "CircleIndicator.h"

@implementation CircleIndicator

float updateValue;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        // Determine our start and stop angles for the arc (in radians)
        startAngle = M_PI * 1.5;
        endAngle = startAngle + (M_PI * 2);
        self.percent = 0;
        self.backgroundColor =[UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    // sirkel
    [bezierPath addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:35
                      startAngle:startAngle
                        endAngle:(endAngle - startAngle) * (_percent / 100.0) + startAngle
                       clockwise:YES];
    
    // runding rundt
    bezierPath.lineWidth = 5;
    [[UIColor colorWithRed:0.608 green:0.349 blue:0.714 alpha:1] setStroke];
    [bezierPath stroke];
}

-(void)setIndicatorWithMaxTime:(float) time{
    updateValue = time/(time *time);
}

-(void)incrementSpin{
    if(self.percent < 100){
        self.percent += updateValue;
        [self setNeedsDisplay];
    }
    //Lage en timer, den må sove slik at 100 tisvarer 10 sekunder
    //100
    //9 sekunder
    
}

@end
