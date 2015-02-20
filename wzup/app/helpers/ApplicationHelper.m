//
//  ApplicationHelper.m
//  wzup
//
//  Created by Simen Lie on 16/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationHelper.h"
#import "ConfigHelper.h"
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


@end
