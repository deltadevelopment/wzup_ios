//
//  ParserHelper.m
//  wzup
//
//  Created by Simen Lie on 16/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ParserHelper.h"

@implementation ParserHelper

- (NSMutableDictionary *) parse:(NSMutableURLRequest *) request{
    NSURLResponse *response;
    NSError *error;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSString *strdata=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",strdata);
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&error];
    return dic;
};

@end


