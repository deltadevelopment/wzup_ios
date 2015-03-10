//
//  UserModel.h
//  wzup
//
//  Created by Simen Lie on 24/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (nonatomic,strong) NSString * username;
@property (nonatomic,strong) NSString * email;
@property (nonatomic) id phone_number;
@property (nonatomic,strong) NSString * display_name;
@property (nonatomic) int availability;
@property (nonatomic,strong) NSDate * created_at;
@property (nonatomic,strong) NSDate * updated_at;
@property (nonatomic,strong) NSString * password_hash;
@property (nonatomic,strong) NSString * password_salt;
@property (nonatomic) BOOL private_profile;
@property (nonatomic) BOOL is_followee;
@property (nonatomic) int Id;

-(void)build:(NSMutableDictionary *)dic;

-(NSString*) getUsername;
-(NSString*) getEmail;
-(id) getPhoneNumber;
-(NSString*) getDisplayName;
-(int) getAvailability;
-(NSDate*) getCreatedAt;
-(NSDate*) getUpdatedAt;
-(NSString*) getPasswordHash;
-(NSString*) getPasswordSalt;
-(BOOL) isPrivateProfile;
-(int) getId;
-(bool)isFollowee;
@end