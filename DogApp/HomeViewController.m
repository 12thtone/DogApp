//
//  ViewController.m
//  DogApp
//
//  Created by Matt Maher on 4/14/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

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
        //self.navigationItem.title = @"";
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    if (![[PFUser currentUser] objectForKey:@"admin"] == true) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    [self.tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    self.tabBarController.tabBar.alpha = 0.6;
    [self.tabBarController.tabBar setBarTintColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
        
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"HelveticaNeue-Light" size:22],NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Home", nil)];
    
    self.navigationItem.hidesBackButton = YES;
    
    self.newsTextView.layer.cornerRadius = 8.0;
    self.newsTextView.layer.masksToBounds = YES;
    
    //self.newsTextView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:36.0];
    
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
    //[self.navigationItem setTitle:@""];
}

- (void)setNews {
    NSMutableArray *jokeArray = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"News"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *joke in objects) {
            [jokeArray addObject:[joke objectForKey:@"newsText"]];
        }
        
        self.newsString = [NSString stringWithFormat:@"%@", jokeArray[0]];
        self.newsTextView.text = self.newsString;
    }];
}

@end
