//
//  FirstViewController.h
//  wzup
//
//  Created by Simen Lie on 16/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView* tableView;
}
- (IBAction)tes:(id)sender;


@end

