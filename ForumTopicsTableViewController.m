//
//  ForumTopicsTableViewController.m
//  DogApp
//
//  Created by Matt Maher on 4/16/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import "ForumTopicsTableViewController.h"
#import <Parse/Parse.h>
#import "ForumTopicsTableViewCell.h"
#import "DiscussionsTableViewController.h"

@interface ForumTopicsTableViewController ()

@end

@implementation ForumTopicsTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithClassName:@"ForumTopics"];
    self = [super initWithCoder:aDecoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"ForumTopics";
        
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
    
    if (![[PFUser currentUser] objectForKey:@"admin"] == true) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self.tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    self.tabBarController.tabBar.alpha = 0.6;
    [self.tabBarController.tabBar setBarTintColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"HelveticaNeue-Light" size:22],NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Forum Topics", nil)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark - PFQuery

- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    [query orderByDescending:@"topicName"];
    
    return query;
}

#pragma mark - PFQueryTableViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    ForumTopicsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"forumTopicTVCell" forIndexPath:indexPath];
    
    PFFile *pictureFile = [[self.objects objectAtIndex:indexPath.row] objectForKey:@"picture"];
    [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error){
            
            [cell.backgroundImage setImage:[UIImage imageWithData:data]];
            cell.backgroundImage.layer.cornerRadius = 8.0;
            cell.backgroundImage.layer.masksToBounds = YES;
        }
        else {
            NSLog(@"no data!");
        }
    }];
    
    cell.subjectLabel.text = [[self.objects objectAtIndex:indexPath.row] objectForKey:@"topicName"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"showDiscussion"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        DiscussionsTableViewController *discussionsTableViewController = (DiscussionsTableViewController *)segue.destinationViewController;
        discussionsTableViewController.topic = object;
    }
}

@end