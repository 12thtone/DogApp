//
//  MyPostsTableViewController.m
//  DogApp
//
//  Created by Matt Maher on 5/13/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import "MyPostsTableViewController.h"
#import <Parse/Parse.h>
#import "MyPostsTableViewCell.h"

@interface MyPostsTableViewController ()

@property (strong, nonatomic) IBOutlet UISegmentedControl *postTypeControl;
- (IBAction)pickType:(id)sender;

@property (nonatomic, assign) BOOL responses;
@property (strong, nonatomic)PFObject *postToDelete;

@end

@implementation MyPostsTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithClassName:@"Discussions"];
    self = [super initWithCoder:aDecoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Discussions";
        
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
    
    [self.tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    self.tabBarController.tabBar.alpha = 0.7;
    [self.tabBarController.tabBar setBarTintColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:@"reloadTable" object:nil];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadTable" object:nil];
}

- (void)reloadTableView:(NSNotification*)notification {
    {
        if ([[notification name] isEqualToString:@"reloadTable"])
        {
            [self loadObjects];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - PFQuery

- (PFQuery *)queryForTable {
    
    if (self.responses == NO) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        
        PFUser *currentUser = [PFUser currentUser];
        
        [query whereKey:@"author" equalTo:currentUser];
        [query orderByDescending:@"createdAt"];
        
        return query;
    } else {
        PFQuery *query = [PFQuery queryWithClassName:@"Response"];
        
        PFUser *currentUser = [PFUser currentUser];
        
        [query whereKey:@"author" equalTo:currentUser];
        [query orderByDescending:@"createdAt"];
        
        return query;
    }
}

#pragma mark - PFQueryTableViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    MyPostsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myPostsTVCell" forIndexPath:indexPath];
    
    if (self.responses == NO) {
        cell.postName.text = [[self.objects objectAtIndex:indexPath.row] objectForKey:@"DiscussionText"];
    } else {
        cell.postName.text = [[self.objects objectAtIndex:indexPath.row] objectForKey:@"DiscussionText"]; // Same column name for both Response and Discussions
    }
    
    [cell.deletePostButton addTarget:self action:@selector(confirmDelete:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (IBAction)pickType:(id)sender {
    switch (self.postTypeControl.selectedSegmentIndex)
    {
        case 0:
            self.responses = NO;
            [self loadObjects
             ];
            break;
        case 1:
            self.responses = YES;
            [self loadObjects];
            break;
        default:
            break;
    }
}

#pragma mark - Delete

- (void)confirmDelete:(id)sender {
    
    UITableViewCell *tappedCell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath *tapIndexPath = [self.tableView indexPathForCell:tappedCell];
    self.postToDelete = [self.objects objectAtIndex:tapIndexPath.row];
    
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"Delete?"
                                                          message:@"Are you sure you want to delete this post?"
                                                         delegate:self
                                                cancelButtonTitle:@"No"
                                                otherButtonTitles:@"Yes", nil];
    [deleteAlert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        [self.postToDelete deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Deleted"
                                                                    message:@"Everyone's looking forward to your next post!"
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                [self loadObjects];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                    message:[error.userInfo objectForKey:@"error"]
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
        }];
    }
}

@end