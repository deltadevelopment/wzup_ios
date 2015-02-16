//
//  FirstViewController.m
//  wzup
//
//  Created by Simen Lie on 16/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "FirstViewController.h"
#import "LoginController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
NSMutableArray *tempArray;
NSString *url;
LoginController *loginController;



- (void)viewDidLoad {
    [super viewDidLoad];
    loginController = [[LoginController alloc] init];
    [loginController login:@"simentest" pass:@"simentest"];
}

-(void)getTest{
    // Do any additional setup after loading the view, typically from a nib.
    // NSMutableString *url = [[NSMutableString alloc] init];
    //tempArray = [[NSMutableArray alloc] init];
    //[url appendString:@"http://wzap.herokuapp.com/login"];
    //NSData *datar = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    //NSLog(@"%@",datar);
    
    NSURL * serviceUrl = [NSURL URLWithString:@"http://wzap.herokuapp.com/user/5"];
    NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
    [serviceRequest setValue:@"text" forHTTPHeaderField:@"Content-type"];
    
    [serviceRequest setHTTPMethod:@"GET"];
    //[serviceRequest setValue:@"asd" forHTTPHeaderField:@"username"];
    //[serviceRequest setValue:@"asd" forHTTPHeaderField:@"password"];
    
    
    //Get Responce hear----------------------
    NSURLResponse *response;
    NSError *error;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:serviceRequest returningResponse:&response error:&error];
    NSString *strdata=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strdata);
    
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&error];
    
    //modellen
    NSArray *verdi2 = dic[@"error"];
    NSLog(verdi2);
    
    //NSError *error;
    //NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:datar options:kNilOptions error:&error];
    //NSMutableDictionary *verdi = dic[@"error"];
    //NSArray *verdi2 = verdi[@"programme"];
}

-(void)postTest{
    //Request
    NSString * xmlString = @"username=simentest&password=simentest";
    NSURL * serviceUrl = [NSURL URLWithString:@"http://wzap.herokuapp.com/login"];
    NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
    [serviceRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [serviceRequest setHTTPMethod:@"POST"];
    [serviceRequest setHTTPBody:[xmlString dataUsingEncoding:NSASCIIStringEncoding]];
    
    //Parse login request
   // NSMutableDictionary *dic = [parserHelper parse:serviceRequest];
    //Store parsed login data in sskey secure
   // [authHelper storeCredentials:dic];
    
    
    //Debugging
    //NSLog([authHelper getAuthToken]);
    //NSLog([authHelper getUserId]);
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
