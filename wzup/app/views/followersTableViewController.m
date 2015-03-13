//
//  followersTableViewController.m
//  wzup
//
//  Created by Simen Lie on 11/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "followersTableViewController.h"
#import "followerTableViewCell.h"
#import "FollowModel.h"
#import "ProfileController.h"

@interface followersTableViewController ()

@end

@implementation followersTableViewController
NSMutableArray* followers;
NSMutableArray* requestingFollowers;
ProfileController *profileController;
int sections = 1;
bool isFollowers;
- (void)viewDidLoad {
    [super viewDidLoad];
    profileController = [[ProfileController alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(isFollowers){
            [profileController initRequestingFollowers];
            requestingFollowers = [profileController getRequestingFollowers];
            if([requestingFollowers count] != 0){
                sections = 2;
            }
        }else{
            //INITIALISER FOLLOWEES REQUESTS HER
            //[profileController initPendingFollowees];
            //requestingFollowers = [profileController getRequestingFollowers];
            //if([requestingFollowers count] != 0){
              //  sections = 2;
            //}
        }
        
        NSLog(@"amount %lu", (unsigned long)[[profileController getFollowers] count ]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)setFollowers:(NSMutableArray*) theFollowers withBool:(bool) isFollower{
    NSLog(@"followr");
    isFollowers = isFollower;
    
    followers = theFollowers;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        // Return the number of rows in the section.
        return [followers count];
    }
    else{
        return [requestingFollowers count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if(section == 0){
        //return @"Section 1";
    }
    
    if(section == 1){
        return isFollowers ? @"Waiting for accept" : @"Pending requests";
        
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"followerCell";
    followerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    

    if(cell == nil){
        cell = [[followerTableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    if(indexPath.section == 0){
        UITapGestureRecognizer *tapGr;
        tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followTap:)];
        tapGr.numberOfTapsRequired = 1;
        [[cell followButton] addGestureRecognizer:tapGr];
        //following_requests
        FollowModel *follower = [followers objectAtIndex:indexPath.row];
        NSLog(@" followee %d", [[follower getUser] isFollowee]);
        if([[follower getUser] isFollowee]){
            [cell.followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
        }
        else{
            [cell.followButton setTitle:@"Follow" forState:UIControlStateNormal];
        }
        
        cell.profileName.text = [[follower getUser] getDisplayName];
        [cell attachToGUI];
    
    }else{
        if([requestingFollowers count] != 0){
            UITapGestureRecognizer *tapGr;
            tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(acceptTap:)];
            tapGr.numberOfTapsRequired = 1;
            [[cell followButton] addGestureRecognizer:tapGr];
            
            //following_requests
            FollowModel *follower = [requestingFollowers objectAtIndex:indexPath.row];
            /*if([[follower getUser] isFollowee]){
             [cell.followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
             }
             else{
             [cell.followButton setTitle:@"Follow" forState:UIControlStateNormal];
             }*/
            [cell.followButton setTitle:@"Accept" forState:UIControlStateNormal];
            cell.profileName.text = [[follower getUser] getDisplayName];
            [cell attachToGUI];
        }
        
    
    }
    return cell;
}

-(void)acceptTap:(UITapGestureRecognizer *) sender{
    CGPoint tapLocation = [sender locationInView:self.tableView];
    NSIndexPath *tapIndexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
    FollowModel *follower = [requestingFollowers objectAtIndex:tapIndexPath.row];
    NSString *userId = [NSString stringWithFormat:@"%d", [[follower getUser] getId]];
    
    [profileController AcceptFollowingWithUserId:userId];
    //Remove user from the cell
    [requestingFollowers removeObjectAtIndex:tapIndexPath.row];
    if([requestingFollowers count] == 0){
        sections = 1;
    }
    [self.tableView reloadData];
}

-(void)followTap:(UITapGestureRecognizer *) sender{
    CGPoint tapLocation = [sender locationInView:self.tableView];
    NSIndexPath *tapIndexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
    
    FollowModel *follower = [followers objectAtIndex:tapIndexPath.row];
    followerTableViewCell *cell = [self.tableView cellForRowAtIndexPath:tapIndexPath];
    NSString *userId = [NSString stringWithFormat:@"%d", [[follower getUser] getId]];
    [[follower getUser] isFollowee] ? [self unFollowWithFollower:follower cell:cell] : [self followWithFollower:follower cell:cell];
}

-(void) followWithFollower:(FollowModel *) follower
                      cell:(followerTableViewCell*) cell{
    NSString *userId = [NSString stringWithFormat:@"%d", [[follower getUser] getId]];
    [[follower getUser] setIs_followee:true];
    [profileController followUserWithUserId:userId];
    [cell.followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
}
-(void)unFollowWithFollower:(FollowModel *) follower cell:(followerTableViewCell*) cell
{
    NSString *userId = [NSString stringWithFormat:@"%d", [[follower getUser] getId]];
    [[follower getUser] setIs_followee:false];
    [profileController unfollowUserWithUserId:userId];
    [cell.followButton setTitle:@"Follow" forState:UIControlStateNormal];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
