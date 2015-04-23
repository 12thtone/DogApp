//
//  ResponsesTableViewController.m
//  DogApp
//
//  Created by Matt Maher on 4/17/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import "ResponsesTableViewController.h"
#import "AddResponseViewController.h"
#import "ResponsesTableViewCell.h"
#import <Parse/Parse.h>
#import "UserProfileTableViewController.h"

@interface ResponsesTableViewController ()

@end

@implementation ResponsesTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithClassName:@"Response"];
    self = [super initWithCoder:aDecoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Response";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 20;
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark - PFQuery

- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"DiscussionTopic" equalTo:self.discussion];
    [query orderByDescending:@"createdAt"];
    
    return query;
}

#pragma mark - PFQueryTableViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    ResponsesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResponseTVCell" forIndexPath:indexPath];
    
    PFUser *user = [self.objects objectAtIndex:indexPath.row][@"author"];
    [user fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        cell.usernameLabel.text = [object objectForKey:@"username"];
        
        PFFile *pictureFile = [user objectForKey:@"picture"];
        [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error){
                
                [cell.userImageButton setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                //cell.userImage.layer.cornerRadius = cell.userImage.frame.size.width / 2;
                //cell.userImage.layer.masksToBounds = YES;
            }
            else {
                NSLog(@"no data!");
            }
        }];
    }];
    
    cell.responseTextLabel.layer.cornerRadius = 8.0;
    cell.responseTextLabel.layer.masksToBounds = YES;
    cell.responseTextLabel.text = [[self.objects objectAtIndex:indexPath.row] objectForKey:@"DiscussionText"];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addResponse"]) {
        
        AddResponseViewController *addResponseViewController = (AddResponseViewController *)segue.destinationViewController;
        addResponseViewController.discussion = self.discussion;
    }
    
    if ([segue.identifier isEqualToString:@"showProfileFromResponse"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        PFUser *object = [[self.objects objectAtIndex:indexPath.row] objectForKey:@"author"];
        UINavigationController *navigationController = segue.destinationViewController;
        UserProfileTableViewController *profileVC = (UserProfileTableViewController*) navigationController;
        
        profileVC.userToProfile = object;
    }
}

@end