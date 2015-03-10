//
//  FollowModel.h
//  wzup
//
//  Created by Simen Lie on 10/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
@interface FollowModel : NSObject
@property (nonatomic) int Id;
@property (nonatomic, strong) UserModel *user;
-(void)setUser:(UserModel *)user;
-(void)setId:(int)Id;
-(int)getId;
-(UserModel*)getUser;
-(void)build:(NSMutableDictionary*) dic;
@end
