//
//  SearchTableViewController.m
//  DogApp
//
//  Created by Matt Maher on 5/14/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import "SearchTableViewController.h"
#import <Parse/Parse.h>
#import "SearchTableViewCell.h"
#import "FullSearchResultTableViewController.h"

@interface SearchTableViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISegmentedControl *postTypeControl;
- (IBAction)pickType:(id)sender;

@property (nonatomic, assign) BOOL forumSearch;

@end

@implementation SearchTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithClassName:@"ReferenceArticles"];
    self = [super initWithCoder:aDecoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"ReferenceArticles";
        
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
    
    self.searchBar.delegate = self;
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:@"reloadTable" object:nil];
    
    UITapGestureRecognizer *tapDismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapDismissKeyboard];
    [tapDismissKeyboard setCancelsTouchesInView:NO];
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

-(void)dismissKeyboard {
    [self.searchBar resignFirstResponder];
}

#pragma mark - PFQuery

- (PFQuery *)queryForTable {
    
    NSString *searchString = self.searchBar.text;
    
    if (self.forumSearch == NO) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        
        [query whereKey:@"articleText" matchesRegex:searchString modifiers:@"i"];
        
        [query orderByDescending:@"createdAt"];
        
        return query;
    } else {
        PFQuery *query = [PFQuery queryWithClassName:@"Response"];
        
        [query whereKey:@"responseBody" matchesRegex:searchString modifiers:@"i"];
        
        [query orderByDescending:@"createdAt"];
        
        return query;
    }
}

#pragma mark - PFQueryTableViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchTVCell" forIndexPath:indexPath];
    
    cell.searchLabel.layer.cornerRadius = 8.0;
    cell.searchLabel.layer.masksToBounds = YES;
    
    if (self.forumSearch == NO) {
        cell.usernameLabel.text = @"Article";
    } else {
        PFUser *user = [self.objects objectAtIndex:indexPath.row][@"author"];
        [user fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            cell.usernameLabel.text = [object objectForKey:@"username"];
        }];
    }
    
    if (self.forumSearch == NO) {
        cell.searchLabel.text = [[self.objects objectAtIndex:indexPath.row] objectForKey:@"articleTitle"];
    } else {
        cell.searchLabel.text = [[self.objects objectAtIndex:indexPath.row] objectForKey:@"DiscussionText"];
    }
    
    return cell;
}

- (IBAction)pickType:(id)sender {
    switch (self.postTypeControl.selectedSegmentIndex)
    {
        case 0:
            self.forumSearch = NO;
            [self loadObjects
             ];
            break;
        case 1:
            self.forumSearch = YES;
            [self loadObjects];
            break;
        default:
            break;
    }
}

#pragma mark - Search

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    [self queryForTable];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showSearchPost"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        FullSearchResultTableViewController *fullSearchResultTableViewController = (FullSearchResultTableViewController *)segue.destinationViewController;
        
        if (self.forumSearch) {
            fullSearchResultTableViewController.postForum = object;
        } else {
            fullSearchResultTableViewController.postReference = object;
        }
    }
}

@end