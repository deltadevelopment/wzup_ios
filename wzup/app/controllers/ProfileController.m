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
NSMutableArray *requestingFollowers;
NSMutableArray *following;

-(StatusModel*)getUser{
    NSString *url = [NSString stringWithFormat:@"user/%@/status", [authHelper getUserId]];
    NSData *response = [self getHttpRequest:url];
    NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    ParserHelper* parserHelper = [[ParserHelper alloc] init];
    NSMutableDictionary *dic = [parserHelper parse:response];
    StatusModel *status = [[StatusModel alloc] init];
    [status build:dic[@"status"]];
    return status;
}

-(void)initFollowersWithUserId:(NSString*) Id{
    followers = [[NSMutableArray alloc] init];
    NSString *url = [NSString stringWithFormat:@"user/%@/followers", Id];
    NSData *response = [self getHttpRequest:url];
    //NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    //NSLog(@"HER: %@",strdata);
    ParserHelper* parserHelper = [[ParserHelper alloc] init];
    NSMutableDictionary *dic2 = [parserHelper parse:response];
    NSArray *followersRaw = dic2[@"followings"];
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


-(void)initRequestingFollowers{
    [self initRequestingFollowersWithUserId:[authHelper getUserId]];
}

-(void)initRequestingFollowersWithUserId:(NSString*) Id{
    requestingFollowers = [[NSMutableArray alloc] init];
    NSString *url = [NSString stringWithFormat:@"user/%@/following_requests", Id];
    NSData *response = [self getHttpRequest:url];
    NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"waiting for accept: %@",strdata);
    ParserHelper* parserHelper = [[ParserHelper alloc] init];
    NSMutableDictionary *dic2 = [parserHelper parse:response];
    NSArray *followersRaw = dic2[@"followings"];
    for(NSMutableDictionary* followerRaw in followersRaw){
        FollowModel *follower = [[FollowModel alloc] init];
        [follower build:followerRaw];
        [requestingFollowers addObject:follower];
    }
    for(FollowModel *follower in requestingFollowers){
        NSLog(@"%@", [[follower getUser] getUsername]);
    }
};

-(void)AcceptFollowingWithUserId:(NSString *) Id{
///user/#{user_id}/accept_following/#{followee_id}
    
    NSString *url = [NSString stringWithFormat:@"user/%@/accept_following/%@", [authHelper getUserId], Id];
    NSData *response = [self postHttpRequest:url json:nil];
    NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"accepted response: %@",strdata);
    
    
    //ParserHelper* parserHelper = [[ParserHelper alloc] init];
    //NSMutableDictionary *dic2 = [parserHelper parse:response];
    //NSArray *followersRaw = dic2[@"followings"];
    
}


-(void)initFollowing{
    [self initFollowingWithUserId:[authHelper getUserId]];
}

-(NSMutableArray*)getFollowers{
    return followers;
}

-(NSMutableArray*)getRequestingFollowers{
    return requestingFollowers;
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
