//
//  SettingsTableViewController.m
//  DogApp
//
//  Created by Matt Maher on 4/16/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import "SettingsTableViewController.h"
#import <Parse/Parse.h>
#import "DataSource.h"

@interface SettingsTableViewController ()
@property (weak, nonatomic) IBOutlet UIButton *rules;
@property (weak, nonatomic) IBOutlet UIButton *eula;
@property (weak, nonatomic) IBOutlet UIButton *privacy;
@property (weak, nonatomic) IBOutlet UIButton *logout;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI {
    
    [self.tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    self.tabBarController.tabBar.alpha = 0.7;
    [self.tabBarController.tabBar setBarTintColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"HelveticaNeue-Light" size:22],NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Settings", nil)];
    
    [self.rules addTarget:self action:@selector(rules:) forControlEvents:UIControlEventTouchUpInside];
    self.rules.layer.cornerRadius = 8;
    self.rules.layer.masksToBounds = YES;
    
    [self.eula addTarget:self action:@selector(eula:) forControlEvents:UIControlEventTouchUpInside];
    self.eula.layer.cornerRadius = 8;
    self.eula.layer.masksToBounds = YES;
    
    [self.privacy addTarget:self action:@selector(privacy:) forControlEvents:UIControlEventTouchUpInside];
    self.privacy.layer.cornerRadius = 8;
    self.privacy.layer.masksToBounds = YES;
    
    [self.logout addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    self.logout.layer.borderWidth = 1;
    self.logout.layer.borderColor = [UIColor grayColor].CGColor;
    self.logout.layer.cornerRadius = 8;
    self.logout.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logout:(id)sender {
    [PFUser logOut];
}

- (void)rules:(id)sender {
    UIAlertView *confirmAlert = [[UIAlertView alloc] initWithTitle:@"Rules"
                                                           message:[[DataSource sharedInstance] rulesString]
                                                          delegate:self
                                                 cancelButtonTitle:@"Done"
                                                 otherButtonTitles:nil];
    [confirmAlert show];
}

- (void)eula:(id)sender {
    UIAlertView *confirmAlert = [[UIAlertView alloc] initWithTitle:@"EULA + Terms"
                                                           message:[[DataSource sharedInstance] eulaString]
                                                          delegate:self
                                                 cancelButtonTitle:@"Done"
                                                 otherButtonTitles:nil];
    [confirmAlert show];
}

- (void)privacy:(id)sender {
    UIAlertView *confirmAlert = [[UIAlertView alloc] initWithTitle:@"Privacy Policy"
                                                           message:[[DataSource sharedInstance] privacyString]
                                                          delegate:self
                                                 cancelButtonTitle:@"Done"
                                                 otherButtonTitles:nil];
    [confirmAlert show];
}

@end
