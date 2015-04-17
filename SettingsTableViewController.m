//
//  SettingsTableViewController.m
//  DogApp
//
//  Created by Matt Maher on 4/16/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import "SettingsTableViewController.h"
#import <Parse/Parse.h>

@interface SettingsTableViewController ()
- (IBAction)logout:(id)sender;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
}

@end
