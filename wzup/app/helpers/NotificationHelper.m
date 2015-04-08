//
//  NotificationHelper.m
//  wzup
//
//  Created by Simen Lie on 08/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "NotificationHelper.h"
#import "UIHelper.h"

@implementation NotificationHelper
{
    UIView *notificationView;
    UILabel *notificationMessage;
    UIButton *notificationCancelButton;
    ParserHelper *parserHelper;
}

-(id) initNotification{
    self = [super init];
    [UIHelper initialize];
    notificationView = [[UIView alloc] initWithFrame:CGRectMake(0, -65, 400, 65)];
    notificationView.backgroundColor = [UIColor redColor];
    notificationMessage = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, [UIHelper getScreenWidth] - 30, 30)];
    notificationMessage.text = @"Error message here";
    [notificationMessage setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:17]];
    notificationMessage.textColor = [UIColor whiteColor];
    notificationCancelButton = [[UIButton alloc] initWithFrame:CGRectMake([UIHelper getScreenWidth] - 30, 30, 20, 20)];
    notificationCancelButton.clipsToBounds = YES;
    
    
    [notificationView addSubview:notificationMessage];
    [notificationView insertSubview:notificationCancelButton atIndex:0];
    parserHelper = [[ParserHelper alloc]init];
    [notificationCancelButton addTarget:self action:@selector(cancelNotificationNow)
                       forControlEvents:UIControlEventTouchUpInside];
    [notificationCancelButton setImage:[UIImage imageNamed:@"cross-white.png"] forState:UIControlStateNormal];
    return self;
}

-(void)addNotificationToView:(UIView *) view
{
    [view addSubview:notificationView];
    view.userInteractionEnabled = YES;
    [self slideInAnimation];
    [view setNeedsDisplay];
    [view setNeedsLayout];
}

-(void)setNotificationMessage:(NSData *) responseData
{
    NSMutableDictionary *parsedData = [parserHelper parse:responseData];
    
    //notificationMessage.text = [parsedData objectForKey:@"message"];
}

-(void)slideInAnimation
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect frame = notificationView.frame;
                         frame.origin.y = 0;
                         notificationView.frame = frame;
                     }
                     completion:^(BOOL finished){
                         [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(slideOutAnimation) userInfo:nil repeats:NO];
                     }];
    
}
-(void)slideOutAnimation
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect frame = notificationView.frame;
                         frame.origin.y = -70;
                         notificationView.frame = frame;
                         
                     }
                     completion:^(BOOL finished){
                         //FJERN FRA VIEW HER
                         [notificationView removeFromSuperview];
                     }];
}

-(void)cancelNotificationNow
{
    [self slideOutAnimation];
}

@end
