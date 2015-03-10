//
//  ProfileController.m
//  wzup
//
//  Created by Simen Lie on 09/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ProfileController.h"

@implementation ProfileController
NSMutableArray *followers;
NSMutableArray *following;
-(StatusModel*)getUser{
    NSString *url = [NSString stringWithFormat:@"user/%@/status", [authHelper getUserId]];
    NSData *response = [self getHttpRequest:url];
    NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(strdata);
    NSMutableDictionary *dic = [parserHelper parse:response];
    StatusModel *status = [[StatusModel alloc] init];
    [status build:dic[@"status"]];
    return status;
}

-(void)initFollowersWithUserId:(NSString*) Id{
    NSLog(@"eher");
    followers = [[NSMutableArray alloc] init];
    NSString *url = [NSString stringWithFormat:@"user/%@/followers", Id];
    NSData *response = [self getHttpRequest:url];
    NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(strdata);
    NSMutableDictionary *dic = [parserHelper parse:response];
    NSArray *followersRaw = dic[@"followings"];
    for(NSMutableDictionary* followerRaw in followersRaw){
        FollowModel *follower = [[FollowModel alloc] init];
        [follower build:followerRaw];
        [followers addObject:follower];
    }
};

-(void)initFollowers{
    [self initFollowersWithUserId:[authHelper getUserId]];
}
-(void)initFollowingWithUserId:(NSString*) Id{
    following = [[NSMutableArray alloc] init];
    NSString *url = [NSString stringWithFormat:@"user/%@/followees", Id];
    NSData *response = [self getHttpRequest:url];
    //NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    //NSLog(strdata);
    NSMutableDictionary *dic = [parserHelper parse:response];
    NSArray *followersRaw = dic[@"followings"];
    for(NSMutableDictionary* followerRaw in followersRaw){
        FollowModel *follower = [[FollowModel alloc] init];
        [follower build:followerRaw];
        [following addObject:follower];
    }
}

-(void)unfollowUserWithUserId:(NSString *) userId{
    NSString *url = [NSString stringWithFormat:@"user/%@/follow/%@", [authHelper getUserId], userId];
    NSData *response = [self deleteHttpRequest:url];
    NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(strdata);
    NSMutableDictionary *dic = [parserHelper parse:response];
    
    
    
}
-(void)followUserWithUserId:(NSString *) userId{
    NSString *url = [NSString stringWithFormat:@"user/%@/follow/%@", [authHelper getUserId], userId];
    NSData *response = [self postHttpRequest:url json:nil];
    NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(strdata);
    NSMutableDictionary *dic = [parserHelper parse:response];
}

-(void)initFollowing{
    [self initFollowingWithUserId:[authHelper getUserId]];
}

-(NSMutableArray*)getFollowers{
    return followers;
}

-(NSMutableArray*)getFollowing{
    return following;
}

-(NSUInteger)getNumberOfFollowers{
    return [followers count];
}

-(NSUInteger)getNumberOfFollowing{
    return [following count];
}


@end
