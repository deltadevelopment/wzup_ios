//
//  ProfileController.m
//  wzup
//
//  Created by Simen Lie on 09/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ProfileController.h"
#import "UserModel.h"

@implementation ProfileController
NSMutableArray *followers;
NSMutableArray *requestingFollowers;
NSMutableArray *following;

-(void)requestUser:(NSObject *) view
       withSuccess:(SEL) success
         withError:(SEL) errorAction{
    NSString *url = [NSString stringWithFormat:@"user/%@/status", [authHelper getUserId]];
    [self getHttpRequest:url withObject:view withSuccess:success withError:errorAction withArgs:nil];
}

-(void)requestUser:(NSString *) userId withObject:(NSObject *) view
       withSuccess:(SEL) success
         withError:(SEL) errorAction{
    NSString *url = [NSString stringWithFormat:@"user/%@/status", userId];
    [self getHttpRequest:url withObject:view withSuccess:success withError:errorAction withArgs:nil];
}

-(StatusModel*)getUser:(NSData *) data{
    ParserHelper* parserHelper = [[ParserHelper alloc] init];
    NSMutableDictionary *dic = [parserHelper parse:data];
    StatusModel *status = [[StatusModel alloc] init];
    [status build:dic[@"status"]];
    return status;
}

-(UserModel*)getUserWithUser:(NSData *) data{
    ParserHelper* parserHelper = [[ParserHelper alloc] init];
    NSMutableDictionary *dic = [parserHelper parse:data];
    UserModel *user = [[UserModel alloc] init];
    [user build:dic[@"user"]];
    return user;
}

-(void)initFollowers:(NSObject *)view
         withSuccess:(SEL) success
           withError:(SEL) errorAction

{
    [self initFollowersWithUserId:[authHelper getUserId] withObject:view withSuccess:success withError:errorAction];
};

-(void)initFollowersWithUserId:(NSString*) Id
                    withObject:(NSObject *)view
                   withSuccess:(SEL) success
                     withError:(SEL) errorAction

{
    
    NSString *url = [NSString stringWithFormat:@"user/%@/followers", Id];
    // NSData *response = [self getHttpRequest:url];
    [self getHttpRequest:url withObject:view withSuccess:success withError:errorAction withArgs:nil];
    
    
};

-(void)getFollowers:(NSData *) data{
    followers = [[NSMutableArray alloc] init];
    ParserHelper* parserHelper = [[ParserHelper alloc] init];
    NSMutableDictionary *dic2 = [parserHelper parse:data];
    NSArray *followersRaw = dic2[@"followings"];
    for(NSMutableDictionary* followerRaw in followersRaw){
        FollowModel *follower = [[FollowModel alloc] init];
        [follower build:followerRaw];
        [followers addObject:follower];
    }
}

-(void)searchForUserByUsername:(NSString *) searchString
                    withObject:(NSObject *)view
                   withSuccess:(SEL) success
                     withError:(SEL) errorAction
{
    NSString *url = [NSString stringWithFormat:@"user/by_username/%@", searchString];
    [self getHttpRequest:url withObject:view withSuccess:success withError:errorAction withArgs:nil];
    
}

-(void)initFollowing:(NSObject *)view
         withSuccess:(SEL) success
           withError:(SEL) errorAction
{
    [self initFollowingWithUserId:[authHelper getUserId] withObject:view withSuccess:success withError:errorAction];
    
}

-(void)initFollowingWithUserId:(NSString*) Id
                    withObject:(NSObject *)view
                   withSuccess:(SEL) success
                     withError:(SEL) errorAction
{
    
    NSString *url = [NSString stringWithFormat:@"user/%@/followees", Id];
    //NSData *response = [self getHttpRequest:url];
    [self getHttpRequest:url withObject:view withSuccess:success withError:errorAction withArgs:nil];
    //NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    //NSLog(strdata);
    
}

-(void)getFollowing:(NSData *) data{
    following = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic = [parserHelper parse:data];
    NSArray *followersRaw = dic[@"followings"];
    for(NSMutableDictionary* followerRaw in followersRaw){
        FollowModel *follower = [[FollowModel alloc] init];
        [follower build:followerRaw];
        [following addObject:follower];
    }
}

-(void)unfollowUserWithUserId:(NSString *) userId
                   withObject:(NSObject *)view
                  withSuccess:(SEL) success
                    withError:(SEL) errorAction
{
    NSString *url = [NSString stringWithFormat:@"user/%@/follow/%@", [authHelper getUserId], userId];
    //NSData *response = [self deleteHttpRequest:url];
    [self deleteHttpRequest:url withObject:view withSuccess:success withError:errorAction withArgs:nil];
    
    //NSMutableDictionary *dic = [parserHelper parse:response];
}
-(void)followUserWithUserId:(NSString *) userId
                 withObject:(NSObject *)view
                withSuccess:(SEL) success
                  withError:(SEL) errorAction
{
    NSString *url = [NSString stringWithFormat:@"user/%@/follow/%@", [authHelper getUserId], userId];
    //  NSData *response = [self postHttpRequest:url json:nil];
    [self postHttpRequest:url json:nil withObject:view withSuccess:success withError:errorAction withArgs:nil];
    //NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    //   NSLog(strdata);
    // NSMutableDictionary *dic = [parserHelper parse:response];
}


-(void)subscribeToUserWithUserId:(NSString *) userId
                      withObject:(NSObject *)view
                     withSuccess:(SEL) success
                       withError:(SEL) errorAction
{
    NSString *url = [NSString stringWithFormat:@"user/%@/subscribe/%@", [authHelper getUserId], userId];
    [self postHttpRequest:url json:nil withObject:view withSuccess:success withError:errorAction withArgs:nil];
    
}

-(void)unSubscribeToUserWithUserId:(NSString *) userId
                        withObject:(NSObject *) view
                       withSuccess:(SEL) success
                         withError:(SEL) errorAction
{
    NSString *url = [NSString stringWithFormat:@"user/%@/subscribe/%@", [authHelper getUserId], userId];
    [self deleteHttpRequest:url withObject:view withSuccess:success withError:errorAction withArgs:nil];
}

-(void)initRequestingFollowers:(NSObject *)view
                   withSuccess:(SEL) success
                     withError:(SEL) errorAction
{
    
    [self initRequestingFollowersWithUserId:[authHelper getUserId] withObject:view withSuccess:success withError:errorAction];
    
};


-(void)initRequestingFollowersWithUserId:(NSString*) Id
                              withObject:(NSObject *)view
                             withSuccess:(SEL) success
                               withError:(SEL) errorAction
{
    
    NSString *url = [NSString stringWithFormat:@"user/%@/follower_requests", Id];
    // NSData *response = [self getHttpRequest:url];
    [self getHttpRequest:url withObject:view withSuccess:success withError:errorAction withArgs:nil];
    //NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    //NSLog(@"waiting for accept: %@",strdata);
    
};


-(void)initRequestingFollowees:(NSObject *)view
                   withSuccess:(SEL) success
                     withError:(SEL) errorAction
{
    
    [self initRequestingFolloweesWithUserId:[authHelper getUserId] withObject:view withSuccess:success withError:errorAction];
    
};


-(void)initRequestingFolloweesWithUserId:(NSString*) Id
                              withObject:(NSObject *)view
                             withSuccess:(SEL) success
                               withError:(SEL) errorAction
{
    
    NSString *url = [NSString stringWithFormat:@"user/%@/followee_requests", Id];
    NSLog(@"followeee requests");
    [self getHttpRequest:url withObject:view withSuccess:success withError:errorAction withArgs:nil];
    
};

-(NSMutableArray *)getRequestingFollowers:(NSData *) data{
    requestingFollowers = [[NSMutableArray alloc] init];
    ParserHelper* parserHelper = [[ParserHelper alloc] init];
    NSMutableDictionary *dic2 = [parserHelper parse:data];
    NSArray *followersRaw = dic2[@"followings"];
    for(NSMutableDictionary* followerRaw in followersRaw){
        FollowModel *follower = [[FollowModel alloc] init];
        [follower build:followerRaw];
        [requestingFollowers addObject:follower];
    }
    return requestingFollowers;
    
}

-(void)AcceptFollowingWithUserId:(NSString *) Id
                      withObject:(NSObject *)view
                     withSuccess:(SEL) success
                       withError:(SEL) errorAction
{
    ///user/#{user_id}/accept_following/#{followee_id}
    
    NSString *url = [NSString stringWithFormat:@"user/%@/accept_following/%@", [authHelper getUserId], Id];
    //  NSData *response = [self postHttpRequest:url json:nil];
    [self postHttpRequest:url json:nil withObject:view withSuccess:success withError:errorAction withArgs:nil];
    // NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    //NSLog(@"accepted response: %@",strdata);
    
    
    //ParserHelper* parserHelper = [[ParserHelper alloc] init];
    //NSMutableDictionary *dic2 = [parserHelper parse:response];
    //NSArray *followersRaw = dic2[@"followings"];
    
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
