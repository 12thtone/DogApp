//
//  AddResponseViewController.m
//  DogApp
//
//  Created by Matt Maher on 4/17/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import "AddResponseViewController.h"
#import "DataSource.h"
#import <Parse/Parse.h>

@interface AddResponseViewController ()

@property (nonatomic, strong) NSString *responseString;

@property (strong, nonatomic) IBOutlet UITextField *responseTextField;

- (IBAction)savePressed:(UIBarButtonItem *)sender;

@end

@implementation AddResponseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *color = [UIColor blackColor];
    self.responseTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Please enter your response." attributes:@{NSForegroundColorAttributeName: color}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePressed:(UIBarButtonItem *)sender {
    
    self.responseString = [self.responseTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([self.responseString length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Please enter some text."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else {
        
        if ([[DataSource sharedInstance] filterForProfanity:self.responseString] == NO) {
            [self saveDiscussion];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Uh oh!"
                                                                message:@"We found a banned word."
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }
    
    
}

- (IBAction)cancelPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveDiscussion
{
    PFObject *newResponse = [PFObject objectWithClassName:@"Response"];
    newResponse[@"DiscussionText"] = self.responseString;
    newResponse[@"DiscussionTopic"] = self.discussion;
    newResponse[@"author"] = [PFUser currentUser];
    
    [newResponse saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    /*
     Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
     NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
     if (networkStatus == NotReachable) {
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Uh oh!"
     message:@"There's a problem with the internet connection. We'll get your joke up ASAP!"
     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [alertView show];
     [newJoke saveEventually];
     } else {
     
     [newJoke saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
     if (succeeded) {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
     [self.navigationController popViewControllerAnimated:YES];
     } else {
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
     message:[error.userInfo objectForKey:@"error"]
     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [alertView show];
     }
     }];
     
     [self dismissViewControllerAnimated:YES completion:nil];
     }
     */
    
}

@end
