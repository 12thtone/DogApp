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
        self.navigationItem.title = @"";
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    self.newsTextView.layer.cornerRadius = 8.0;
    self.newsTextView.layer.masksToBounds = YES;
    
    //self.newsTextView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:36.0];
    
    [self setNews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNews {
    NSMutableArray *jokeArray = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"News"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *joke in objects) {
            [jokeArray addObject:[joke objectForKey:@"newsText"]];
        }
        
        self.newsString = [NSString stringWithFormat:@"%@", jokeArray[0]];
        self.newsTextView.text = self.newsString;
    }];
}

@end
