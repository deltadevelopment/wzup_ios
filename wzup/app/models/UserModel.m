//
//  UserModel.m
//  wzup
//
//  Created by Simen Lie on 24/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

-(void)build:(NSMutableDictionary *)dic{
    _username  = dic[@"username"];
    _email  = dic[@"email"];
    _phone_number  = dic[@"phone_number"];
    _display_name  = dic[@"display_name"];
    _availability  = [[dic objectForKey:@"availability"] intValue];    
    _created_at  = dic[@"created_at"];
    _updated_at  = dic[@"updated_at"];
    _password_hash  = dic[@"password_hash"];
    _password_salt  = dic[@"password_salt"];
    _private_profile  = dic[@"private_profile"];
    //User
    NSLog(@"The username is %@", _username);
};

-(NSString*) getUsername{return _username;};
-(NSString*) getEmail{return _email;};
-(id) getPhoneNumber{return _phone_number;};
-(NSString*) getDisplayName{return _display_name;};
-(int) getAvailability{return _availability;};
-(NSDate*) getCreatedAt{return _created_at;};
-(NSDate*) getUpdatedAt{return _updated_at;};
-(NSString*) getPasswordHash{return _password_hash;};
-(NSString*) getPasswordSalt{return _password_salt;};
-(BOOL) isPrivateProfile{return _private_profile;};
@end
