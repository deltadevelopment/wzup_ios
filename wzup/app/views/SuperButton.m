//
//  SuperButton.m
//  wzup
//
//  Created by Simen Lie on 21.03.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SuperButton.h"

@implementation SuperButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) initSuperButton{
    self.layer.cornerRadius = 25;
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(labelDragged:)];
    
    [self addGestureRecognizer:gesture];
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(recordVideo:)];
    [longGesture setMinimumPressDuration:1];
    [self addGestureRecognizer:longGesture];
}

@end
