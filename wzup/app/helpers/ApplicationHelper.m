//
//  ApplicationHelper.m
//  wzup
//
//  Created by Simen Lie on 16/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationHelper.h"
#import "ConfigHelper.h"
static NSIndexPath *currrentIndex = 0;
NSArray *availableTexts;
NSArray *unAvailableTexts;
@implementation ApplicationHelper
-(NSString*) generateUrl:(NSString*) relativePath{
    ConfigHelper *configHelper = [[ConfigHelper alloc] init];
    NSMutableString *url = [[NSMutableString alloc] init];
    [url appendString:[configHelper baseUrl]];
    [url appendString:@"/"];
    [url appendString:relativePath];
    return url;
    //base + relative;
}
-(NSString*) generateJsonFromDictionary:(NSDictionary *) dictionary{
    NSError *error;
    NSData *json = [NSJSONSerialization dataWithJSONObject:dictionary
                                                   options:0
                                                     error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    // This will be the json string in the preferred format
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    return jsonString;
}
-(void)setIndex:(NSIndexPath *) path{
    currrentIndex = path;
}
-(NSIndexPath*)getIndex{
    return currrentIndex;
}

-(void)addAvailableTexts{
    availableTexts = [[NSArray alloc] initWithObjects:@"IM FREE", @"IM FREE2", @"IM FREE3",@"IM FREE4", nil];
}
-(void)addUnAvailableTexts{
    unAvailableTexts = [[NSArray alloc] initWithObjects:@"BUSY BEE", @"BUSY BEE2", @"BUSY BEE3",@"BUSY BEE4", nil];
}

-(NSString*)getAvailableText{
    return availableTexts[rand()%4];
}
-(NSString*)getUnAvailableText{
    return unAvailableTexts[rand()%4];
}


@end
