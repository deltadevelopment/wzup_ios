//
//  FollowingTableViewController.m
//  wzup
//
//  Created by Simen Lie on 24/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "FollowingTableViewController.h"
#import "followerTableViewCell.h"
#import "FollowModel.h"
#import "ProfileController.h"
#import "ProfileViewController.h"
@interface FollowingTableViewController ()

@end

@implementation FollowingTableViewController
{
    NSMutableArray* followings;
    NSMutableArray* requestingFollowees;
    ProfileController *profileController;
    int sections;
    followerTableViewCell *currentCell;
}
bool isOwnProfiles = YES;
- (void)viewDidLoad {
    [super viewDidLoad];
    sections = 1;
    self.navigationItem.title = @"Following";
    profileController = [[ProfileController alloc]init];
    requestingFollowees = [[NSMutableArray alloc] init];
    if(isOwnProfiles){
        [profileController initRequestingFollowees:self withSuccess:@selector(requestingFolloweesWasReturned:) withError:@selector(requestingFolloweesWasNotReturned:)];
    }

}
     
-(void)requestingFolloweesWasReturned:(NSData *) data{

    NSString *strdata=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(strdata);
    NSLog(@"was returned -----");
    requestingFollowees = [profileController getRequestingFollowers:data];
    if([requestingFollowees count] != 0){
        sections = 2;
    }
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didselect");
    ProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    FollowModel *follower  = [followings objectAtIndex:indexPath.row];
    
    //[follower getUser]
    [vc setProfileWithFollower:follower];
    // OR myViewController *vc = [[myViewController alloc] init];
    
    // any setup code for *vc
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain
                                                                            target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)requestingFolloweesWasNotReturned:(NSError *) error{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setFollowings:(NSMutableArray*) theFollowings withBool:(BOOL)isOwnProfile{
    followings = theFollowings;
    isOwnProfiles = isOwnProfile;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        // Return the number of rows in the section.
        return [followings count];
    }
    else{
        NSLog(@"Re %lu",(unsigned long)[requestingFollowees count]);
        return [requestingFollowees count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0){
        //return @"Section 1";
    }
    
    if(section == 1){
        return  @"Pending requests";
        
    }
    return nil;
}

-(void)followTap:(UITapGestureRecognizer *) sender{
    CGPoint tapLocation = [sender locationInView:self.tableView];
    NSIndexPath *tapIndexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
    
    FollowModel *follower = [followings objectAtIndex:tapIndexPath.row];
    followerTableViewCell *cell = [self.tableView cellForRowAtIndexPath:tapIndexPath];
    NSString *userId = [NSString stringWithFormat:@"%d", [[follower getUser] getId]];
    [[follower getUser] isFollowee] ? [self unFollowWithFollower:follower cell:cell] : [self followWithFollower:follower cell:cell];
}


-(void) followWithFollower:(FollowModel *) follower
                      cell:(followerTableViewCell*) cell{
    NSString *userId = [NSString stringWithFormat:@"%d", [[follower getUser] getId]];
    [[follower getUser] setIs_followee:true];
    //[profileController followUserWithUserId:userId];
    [profileController followUserWithUserId:userId withObject:self withSuccess:@selector(followedSuccesfully:) withError:@selector(followedWithError:)];
    currentCell = cell;
}
-(void)unFollowWithFollower:(FollowModel *) follower cell:(followerTableViewCell*) cell
{
    NSString *userId = [NSString stringWithFormat:@"%d", [[follower getUser] getId]];
    [[follower getUser] setIs_followee:false];
    [profileController unfollowUserWithUserId:userId withObject:self withSuccess:@selector(unfollowedSuccesfully:) withError:@selector(unfollowedWithError:)];
    //  [profileController unfollowUserWithUserId:userId];
    currentCell = cell;
    
}

-(void)followedSuccesfully:(NSData *) data{
    [currentCell.followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
}

-(void)followedWithError:(NSError *) error{
    
}

-(void)unfollowedSuccesfully:(NSData *) data{
    [currentCell.followButton setTitle:@"Follow" forState:UIControlStateNormal];
}

-(void)unfollowedWithError:(NSError *) error{
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"followingCell";
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
       
        FollowModel *follower = [followings objectAtIndex:indexPath.row];
        
        NSLog(@" followee %d", [[follower getUser] isFollowee]);
        if([[follower getUser] isFollowee]){
            [cell.followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
        }
        else{
            [cell.followButton setTitle:@"Follow" forState:UIControlStateNormal];
        }
        cell.followButton.hidden = NO;
        cell.profileName.text = [[follower getUser] getDisplayName];
        [cell attachToGUI];
        
    }else{
        if([requestingFollowees count] != 0){
            UITapGestureRecognizer *tapGr;
            tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(acceptTap:)];
            tapGr.numberOfTapsRequired = 1;
            [[cell followButton] addGestureRecognizer:tapGr];
            
            //following_requests
            FollowModel *follower = [requestingFollowees objectAtIndex:indexPath.row];
            /*if([[follower getUser] isFollowee]){
             [cell.followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
             }
             else{
             [cell.followButton setTitle:@"Follow" forState:UIControlStateNormal];
             }*/
            cell.followButton.hidden = YES;
            cell.profileName.text = [[follower getUser] getDisplayName];
            [cell attachToGUI];
        }
        
        
    }
    return cell;
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
