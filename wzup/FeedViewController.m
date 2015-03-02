//
//  FirstViewController.m
//  wzup
//
//  Created by Simen Lie on 16/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "FeedViewController.h"
#import "LoginController.h"
#import "AuthHelper.h"
#import "FeedController.h"
#import "StatusModel.h"
#import "UserModel.h"
#import "FeedTableViewCell.h"
#import "ApplicationHelper.h"
#import "ProfileViewController.h"
#import "StartViewController.h"
@interface FeedViewController ()

@end

@implementation FeedViewController
LoginController *loginController;
AuthHelper *authHelper;
UIView *top;
NSIndexPath *oldIndex;
NSMutableArray *feed;
NSMutableArray *cells;
NSIndexPath *indexCurrent;
StatusModel *currentSelected;
bool shouldExpand;
FeedController* feedController;
- (void)viewDidLoad {
  
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableviewe addSubview:refreshControl];
    
    feedController = [[FeedController alloc] init];
    feed = [feedController getFeed];
    [self checkErrors];
    cells = [[NSMutableArray alloc] init];
    authHelper = [[AuthHelper alloc] init];
    [super viewDidLoad];
    _tableviewe.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableviewe.separatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0f];
    //loginController = [[LoginController alloc] init];
    //[loginController login:@"simentest" pass:@"simentest"];
    [super viewDidLoad];
    top = [[UIView alloc] init];
    [top setFrame:CGRectMake(0, 0, 200, 35)];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat center = (screenWidth/4) - (10);
    
    UIButton *leftButton = [self createButton:@"feed-icon.png" x:center-80];
    UIButton *middleButton = [self createButton:@"events-icon.png" x:center];
    UIButton *rightButton = [self createButton:@"profile-icon.png" x:center + 80];
    
    [top addSubview:leftButton];
    [top addSubview:middleButton];
    [top addSubview:rightButton];
    self.navigationItem.titleView = top;
}
-(void)checkErrors{
    if([feedController hasError]){
        StartViewController*loginController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"startNav"];
        [self presentModalViewController:loginController animated:YES];
    };
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    feed = [feedController getFeed];
    indexCurrent = nil;
    [self.tableviewe reloadData];
    [self checkErrors];
    [refreshControl endRefreshing];
}

-(UIButton *)createButton:(NSString *) img x:(int) xPos{
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *buttonImage = [UIImage imageNamed:img];
    buttonImage = [self resizeImage:buttonImage newSize:CGSizeMake(30,30)];
    [navButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [navButton setTitleColor:[UIColor colorWithRed:0.4 green:0.157 blue:0.396 alpha:1]  forState:UIControlStateNormal];
    [navButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    // [navButton bringSubviewToFront:navButton.imageView];
    
    [navButton setFrame:CGRectMake(xPos, 0, 30, 30)];
    return navButton;
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tes:(id)sender {

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [feed count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)handleTap:(UITapGestureRecognizer *) sender{
    CGPoint tapLocation = [sender locationInView:self.tableviewe];
    NSIndexPath *tapIndexPath = [self.tableviewe indexPathForRowAtPoint:tapLocation];
  
    
    ProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    StatusModel *statusmodel = [feed objectAtIndex:tapIndexPath.row];
    [vc setProfile:[statusmodel getBody]];
    // OR myViewController *vc = [[myViewController alloc] init];
    
    // any setup code for *vc
    
    [self.navigationController pushViewController:vc animated:YES];
    // do any setup you need for myNewVC
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    static NSString *CellIdentifier = @"feedCell";
    FeedTableViewCell *cell = (FeedTableViewCell *)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if(cell == nil){
        cell = [[FeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"feedCell"];
        
     
        
        if(oldIndex != nil){
        FeedTableViewCell *old = [tableView cellForRowAtIndexPath:indexCurrent];
        }
        if(!shouldExpand){
            [cell setExpand:YES];
        }else{
            [cell setExpand:NO];
        }
        
        [cell initCell];
        [cell setIndexPath:indexPath];
        [cells addObject:cell];
    }
    UITapGestureRecognizer *tapGr;
    tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGr.numberOfTapsRequired = 1;
    [[cell getView] addGestureRecognizer:tapGr];
    
    StatusModel *statusmodel = [feed objectAtIndex:indexPath.row];
    //currentSelected = statusmodel;
    UserModel *userModel = [statusmodel getUser];
    [cell setStatus:[statusmodel getBody]];
    [cell setName:[[statusmodel getUser] getUsername]];
    [cell setProfileImg:[statusmodel getImgPath]];
    UIImage *raw = [UIImage imageNamed:[statusmodel getImgPath]];
    [cell setStatusImg:raw];
    [cell setAvailability:[[statusmodel getUser] getAvailability]];
    if(indexCurrent == indexPath){
        if(shouldExpand){
            [cell changeSize:raw];
        }
        else{
           //[cell setExpand];
        }
       
    }else{
        
    }
    
   // NSLog(@"%@", [[statusmodel getUser] getAvailability]);
    
    
    return cell;
}

-(void)viewDidLayoutSubviews
{
    if ([_tableviewe respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableviewe setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableviewe respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableviewe setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    if ([indexPath isEqual:indexCurrent] && shouldExpand)
    {
        return 500;
    }
    else if([indexPath isEqual:indexCurrent]){
        return 231;
    }
    else {
        return 231;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)path
// or it must be some other method
{
    StatusModel *statusmodel = [feed objectAtIndex:path.row];
    currentSelected = statusmodel;
    
    if(indexCurrent != nil){
        FeedTableViewCell *old = [tableView cellForRowAtIndexPath:indexCurrent];
        //[old resetView];
    }
    NSIndexPath *oldIndex = indexCurrent;
    
    indexCurrent = path;
    FeedTableViewCell *cell = [tableView cellForRowAtIndexPath:path];
    if(indexCurrent == oldIndex){
        //indexCurrent = nil;
        if(shouldExpand){
            shouldExpand = false;
        }else{
            shouldExpand = true;
        }
        
    }else{
     shouldExpand = true;
    }

    [tableView beginUpdates];
    if(oldIndex != nil){
        if(oldIndex == indexCurrent){
            if(!shouldExpand){
                //[cell anim];
            }
            NSLog(@"1");
            [tableView reloadRowsAtIndexPaths:@[oldIndex] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            NSLog(@"2");
            [tableView reloadRowsAtIndexPaths:@[indexCurrent, oldIndex] withRowAnimation:UITableViewRowAnimationNone];
        }
    }else{
        NSLog(@"3");
        [tableView reloadRowsAtIndexPaths:@[indexCurrent] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [tableView endUpdates];
    
}








@end
