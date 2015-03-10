//
//  FollowModel.m
//  wzup
//
//  Created by Simen Lie on 10/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "FollowModel.h"

@implementation FollowModel

-(void)build:(NSMutableDictionary*) dic{
    self.user = [[UserModel alloc]init];
    [self.user build:dic[@"user"]];
    self.Id = [[dic objectForKey:@"id"] intValue];
}
-(int)getId{return _Id;}
-(UserModel*)getUser{return _user;}

@end
