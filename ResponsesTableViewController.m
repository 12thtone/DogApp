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
#import "FullResponseTableViewController.h"

@interface ResponsesTableViewController ()
@property (strong, nonatomic) IBOutlet UILabel *discussionLabel;

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
    
    [self.tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    self.tabBarController.tabBar.alpha = 0.7;
    [self.tabBarController.tabBar setBarTintColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"HelveticaNeue-Light" size:22],NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Responses", nil)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:@"reloadTable" object:nil];
    
    self.discussionLabel.text = [self.discussion objectForKey:@"DiscussionText"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)reloadTableView:(NSNotification*)notification {
    {
        if ([[notification name] isEqualToString:@"reloadTable"])
        {
            [self loadObjects];
        }
    }
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userProfileTapped:)];
    [tap setNumberOfTapsRequired:1];
    tap.enabled = YES;
    [cell.userImage addGestureRecognizer:tap];
    
    PFUser *user = [self.objects objectAtIndex:indexPath.row][@"author"];
    [user fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        cell.usernameLabel.text = [object objectForKey:@"username"];
        
        PFFile *pictureFile = [user objectForKey:@"picture"];
        [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error){
                
                [cell.userImage setImage:[UIImage imageWithData:data]];
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
    
    if ([segue.identifier isEqualToString:@"showResponse"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        FullResponseTableViewController *fullResponseTableViewController = (FullResponseTableViewController *)segue.destinationViewController;
        fullResponseTableViewController.response = object;
    }
}

- (void)userProfileTapped:(UITapGestureRecognizer *)sender {
    
    CGPoint tapLocation = [sender locationInView:self.tableView];
    NSIndexPath *tapIndexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
    
    PFUser *object = [[self.objects objectAtIndex:tapIndexPath.row] objectForKey:@"author"];
    UserProfileTableViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"viewProfile"];
    profileVC.userToProfile = object;
    
    [self.navigationController pushViewController:profileVC animated:YES];
    
}

@end