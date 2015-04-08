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
#import "ProfileViewController.h"

@interface followersTableViewController ()

@end

@implementation followersTableViewController{
    NSMutableArray* followers;
    NSMutableArray* requestingFollowers;
    ProfileController *profileController;
    followerTableViewCell *currentCell;
    NSIndexPath *indexPathForRemoval;
}
    bool isOwnProfil = YES;
    int sections = 1;
- (void)viewDidLoad {
    [super viewDidLoad];
    profileController = [[ProfileController alloc] init];
    //self.navigationController.tabBarItem.title = @"Followers";
    self.navigationItem.title = @"Followers";
    
    //[profileController initRequestingFollowers];
    if(isOwnProfil){
        [profileController initRequestingFollowers:self
                                       withSuccess:@selector(requestingFollowersWasReturned:)
                                         withError:@selector(requestingFollowersWasNotReturned:)];
    }

    
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"hey");
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didselect");
    ProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    FollowModel *follower  = [followers objectAtIndex:indexPath.row];
    
    //[follower getUser]
    [vc setProfileWithFollower:follower];
    // OR myViewController *vc = [[myViewController alloc] init];
    
    // any setup code for *vc
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain
                                                                            target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return 35;
        
    }
    return UITableViewAutomaticDimension;
}

-(void)requestingFollowersWasReturned:(NSData *) data{
    requestingFollowers = [profileController getRequestingFollowers:data];
    if([requestingFollowers count] != 0){
        sections = 2;
    }
    [self.tableView reloadData];
}

-(void)requestingFollowersWasNotReturned:(NSError *) error{
    
}

-(void)setFollowers:(NSMutableArray*) theFollowers isOwnProfile:(bool) isProfile{
    NSLog(@"followr");
    isOwnProfil = isProfile;
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
        return @"Waiting for accept";
        
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
        cell.followButton.hidden = NO;
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
    
    [profileController AcceptFollowingWithUserId:userId withObject:self withSuccess:@selector(acceptWasSuccessful:) withError:@selector(acceptWasNotSuccessful:) ];
    indexPathForRemoval = tapIndexPath;
  
}

-(void)acceptWasSuccessful:(NSData *) data{
    //Remove user from the cell
    [requestingFollowers removeObjectAtIndex:indexPathForRemoval.row];
    
    if([requestingFollowers count] == 0){
        sections = 1;
    }
    [self.tableView reloadData];

}

-(void)acceptWasNotSuccessful:(NSError *)error{


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
