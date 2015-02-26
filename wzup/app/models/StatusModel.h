//
//  StatusModel.h
//  wzup
//
//  Created by Simen Lie on 24/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface StatusModel : NSObject{
NSString * imgPath;
}
@property (nonatomic,strong) NSString * statusId;
@property (nonatomic,strong) NSString * body;
@property (nonatomic,strong) NSString * location;
@property (nonatomic,strong) NSString * user_id;
@property (nonatomic,strong) NSString * created_at;
@property (nonatomic,strong) NSString * updated_at;
@property (nonatomic,strong) NSString * imgPath;
//Virtual
@property (nonatomic,strong) UserModel * user;

-(void)build:(NSMutableDictionary *)dic;

-(NSString*) getStatusId;
-(NSString*) getBody;
-(NSString*) getLocation;
-(NSString*) getUserId;
-(NSString*) getCreatedAt;
-(NSString*) getUpdatedAt;
-(UserModel*) getUser;
-(NSString*)getImgPath;


@end
