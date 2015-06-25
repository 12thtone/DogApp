//
//  ViewController.m
//  DogApp
//
//  Created by Matt Maher on 4/14/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//
// This is a private application. Use of any code, images, ideas, shits, giggles, or whatever is forbidden.

#import "HomeViewController.h"
#import <Parse/Parse.h>

@interface HomeViewController ()

@property (nonatomic, strong) NSString *newsString;

@property (strong, nonatomic) IBOutlet UILabel *newsTextView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Current user: %@", currentUser.username);
    }
    else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    NSLog(@"%@", [[PFUser currentUser] objectForKey:@"admin"]);
    
    if (![[PFUser currentUser] objectForKey:@"admin"] == true) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    [self.tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    self.tabBarController.tabBar.alpha = 0.7;
    [self.tabBarController.tabBar setBarTintColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    self.navigationItem.hidesBackButton = YES;
    
    [self setNews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationItem setTitle:@""];
}

- (void)setNews {
    NSMutableArray *newsArray = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"News"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *news in objects) {
            [newsArray addObject:[news objectForKey:@"newsText"]];
        }
        
        self.newsString = [NSString stringWithFormat:@"%@", newsArray[0]];
        self.newsTextView.text = self.newsString;
    }];
}

@end
