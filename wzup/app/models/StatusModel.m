//
//  StatusModel.m
//  wzup
//
//  Created by Simen Lie on 24/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "StatusModel.h"

@implementation StatusModel

-(void)build:(NSMutableDictionary *)dic{
    _statusId = dic[@"id"];
    _body = dic[@"body"];
    _location = dic[@"location"];
    _user_id = dic[@"user_id"];
    _created_at = dic[@"created_at"];
    _updated_at = dic[@"updated_at"];
    _user = [[UserModel alloc] init];
    [_user build:dic[@"user"]];
   NSLog(@"The status is %@ %@",_body, _user_id);
};

-(NSString*) getStatusId{
    return _statusId;
};
-(NSString*) getBody
{
    return _body;
};
-(NSString*) getLocation
{
    return _location;
};
-(NSString*) getUserId
{
    return _user_id;
};
-(NSString*) getCreatedAt
{
    return _created_at;
};
-(NSString*) getUpdatedAt
{
    return _updated_at;
};
-(UserModel*) getUser{
    return _user;
};


@end
