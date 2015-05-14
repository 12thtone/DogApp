//
//  ReferenceArticlesTableViewController.m
//  DogApp
//
//  Created by Matt Maher on 4/23/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import "ReferenceArticlesTableViewController.h"
#import <Parse/Parse.h>
#import "ReferenceArticlesTableViewCell.h"
#import "AddRefArtViewController.h"
#import "ReferenceFullArticleTableViewController.h"

@interface ReferenceArticlesTableViewController ()

@end

@implementation ReferenceArticlesTableViewController

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
    
    if (![[PFUser currentUser] objectForKey:@"admin"] == true) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self.tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    self.tabBarController.tabBar.alpha = 0.7;
    [self.tabBarController.tabBar setBarTintColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"HelveticaNeue-Light" size:22],NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Articles", nil)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:@"reloadTable" object:nil];
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
    [query whereKey:@"articleTopic" equalTo:self.topic];
    [query orderByDescending:@"createdAt"];
    
    return query;
}

#pragma mark - PFQueryTableViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    ReferenceArticlesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefArtTVCell" forIndexPath:indexPath];
    
    PFFile *pictureFile = [[self.objects objectAtIndex:indexPath.row] objectForKey:@"picture"];
    [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error){
            
            [cell.articleImage setImage:[UIImage imageWithData:data]];
        }
        else {
            NSLog(@"no data!");
        }
    }];
    
    cell.titleLabel.text = [[self.objects objectAtIndex:indexPath.row] objectForKey:@"articleTitle"];
     
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"addArticle"]) {
        
        AddRefArtViewController *addRefArtViewController = (AddRefArtViewController *)segue.destinationViewController;
        addRefArtViewController.topic = self.topic;
    }
    
    if ([segue.identifier isEqualToString:@"showArticle"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        ReferenceFullArticleTableViewController *referenceFullArticleTableViewController = (ReferenceFullArticleTableViewController *)segue.destinationViewController;
        referenceFullArticleTableViewController.article = object;
    }
}

@end