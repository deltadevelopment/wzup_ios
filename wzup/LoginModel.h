//
//  LoginModel.h
//  wzup
//
//  Created by Simen Lie on 16/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject
@property (nonatomic,strong) NSString * success;
@property (nonatomic,strong) NSString * user_id;
@property (nonatomic,strong) NSString * auth_token;
-(void)build:(NSMutableDictionary *)dic;

-(NSString*) getUserID;
-(NSString*) getSuccess;
-(NSString*) getAuth;

@end
