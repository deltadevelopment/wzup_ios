//
//  Feed2ViewController.m
//  wzup
//
//  Created by Simen Lie on 26.02.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "Feed2ViewController.h"
#import "Feed2TableViewCell.h"
#import "FeedController.h"
#import "StatusModel.h"
#import "UserModel.h"
#import "StartViewController.h"
#import "ProfileViewController.h"
@interface Feed2ViewController ()

@end

@implementation Feed2ViewController
NSIndexPath *indexCurrent;
NSMutableArray *feed;
FeedController* feedController;
BOOL shouldExpand;
CGRect screenBound;
CGSize screenSize;
CGFloat screenWidth;
- (void)viewDidLoad {
    [super viewDidLoad];
    screenBound = [[UIScreen mainScreen] bounds];
    screenSize = screenBound.size;
    screenWidth = screenSize.width;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    // Do any additional setup after loading the view.
    feedController = [[FeedController alloc] init];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                feed = [feedController getFeed];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            self.tableView.tableHeaderView = nil;
            [self.tableView reloadData];
        });
        
    });
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(labelDragged:)];
    [_statusButton addGestureRecognizer:gesture];
    
    
    
}

- (void)labelDragged:(UIPanGestureRecognizer *)gesture
{
    UILabel *label = (UILabel *)gesture.view;
    CGPoint translation = [gesture translationInView:label];
    float newX = _statusButtonHorizontalSpace.constant;
    
    //NSLog(@"gesture point %f",  translation.x);
    
    
    if(translation.x < 0){
        //CHECK left
        //NSLog(@"constraint is %f", _statusButtonHorizontalSpace.constant);
        
        if(newX>= 300){
            newX = 300;
            _statusButtonHorizontalSpace.constant = newX;
        }
        else {
            _statusButtonHorizontalSpace.constant -= translation.x;
        } 
    }
    else{
     //CHECK right
        if(newX <= 16){
            newX = 16;
            _statusButtonHorizontalSpace.constant = newX;
        }
        else {
            _statusButtonHorizontalSpace.constant -= translation.x;
            //NSLog(@"constraint is %f", _statusButtonHorizontalSpace.constant);
        }
    }
    
    
   
    // move label , limit it to stay inside self.view.frame

  
    
    //possibly compute collision here and limit new coordinates further
    
    //label.center = CGPointMake(newx,newy);
   // _statusButtonHorizontalSpace.constant = newx;
    
    // reset translation
    [gesture setTranslation:CGPointZero inView:label];
}

-(void)handleTap:(UITapGestureRecognizer *) sender{
    CGPoint tapLocation = [sender locationInView:self.tableView];
    NSIndexPath *tapIndexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
    
    
    ProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    StatusModel *statusmodel = [feed objectAtIndex:tapIndexPath.row];
    [vc setProfile:[statusmodel getBody]];
    // OR myViewController *vc = [[myViewController alloc] init];
    
    // any setup code for *vc
    
    [self.navigationController pushViewController:vc animated:YES];
    // do any setup you need for myNewVC
    
    
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    feed = [feedController getFeed];
    indexCurrent = nil;
    [self.tableView reloadData];
    [self checkErrors];
    [refreshControl endRefreshing];
    
}
-(void)checkErrors{
    if([feedController hasError]){
        StartViewController*startController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"startNav"];
        [self presentModalViewController:startController animated:YES];
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [feed count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //NSLog(@"cell creation");
    static NSString *CellIdentifier = @"customCell";
    Feed2TableViewCell *cell = (Feed2TableViewCell  *)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    //cell=nil;
    if(cell == nil){
        cell = [[Feed2TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customCell"];
    
    }
    if([feed count] != 0){
        UITapGestureRecognizer *tapGr;
        tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapGr.numberOfTapsRequired = 1;
        [[cell getTopBar] addGestureRecognizer:tapGr];
        StatusModel *status = [feed objectAtIndex:indexPath.row];
        cell.statusLabel.text = [status getBody];
        cell.nameLabel.text = [[status getUser] getUsername];
        cell.profilePicture.image = [UIImage imageNamed:[status getImgPath]];
        //NSLog([status getImgPath]);
        cell.statusImg = [status getImgPath];
        NSLog(@"often");
        
      
        CGSize size = CGSizeMake(screenWidth, 500);
        UIImage * image = [UIImage imageNamed:[status getImgPath]];
        image = [self imageByScalingAndCroppingForSize:size img:image];
        [cell.statusImage setBackgroundColor:[UIColor colorWithPatternImage:nil]];
        [cell.statusImage setBackgroundColor:[UIColor colorWithPatternImage:image]];
        [cell setAvailability:[[status getUser] getAvailability]];
    }
   
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    //NSLog(@"row for height");
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
    
    NSIndexPath *oldIndex = indexCurrent;
    
    indexCurrent = path;

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
 
    
    [tableView endUpdates];

    
}

-(void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
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

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize img:(UIImage *) sourceImage
{
    // NSLog(@"THE size is width: %f height: %f", targetSize.width, targetSize.height);
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        
        //NSLog(@"fit height %f", targetSize.width);
        scaleFactor = widthFactor; // scale to fit height
        
        
        
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = 0;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = 0;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
