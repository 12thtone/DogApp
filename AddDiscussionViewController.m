//
//  AddDiscussionViewController.m
//  DogApp
//
//  Created by Matt Maher on 4/16/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import "AddDiscussionViewController.h"
#import "DataSource.h"
#import <Parse/Parse.h>

@interface AddDiscussionViewController ()

@property (nonatomic, strong) NSString *discussionString;

@property (strong, nonatomic) IBOutlet UITextField *discussionTextField;

- (IBAction)savePressed:(UIBarButtonItem *)sender;

@end

@implementation AddDiscussionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *color = [UIColor blackColor];
    self.discussionTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"What would you like to discuss?" attributes:@{NSForegroundColorAttributeName: color}];
    
    NSLog(@"TOPIC: %@", self.topic);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePressed:(UIBarButtonItem *)sender {
    
    self.discussionString = [self.discussionTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([self.discussionString length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Please enter some text."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else {
        
        if ([[DataSource sharedInstance] filterForProfanity:self.discussionString] == NO) {
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
    PFObject *newDiscussion = [PFObject objectWithClassName:@"Discussions"];
    newDiscussion[@"DiscussionText"] = self.discussionString;
    newDiscussion[@"DiscussionTopic"] = self.topic;
    newDiscussion[@"author"] = [PFUser currentUser];
    
    [newDiscussion saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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
