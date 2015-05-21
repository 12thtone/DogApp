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
    
    [self.tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    self.tabBarController.tabBar.alpha = 0.7;
    [self.tabBarController.tabBar setBarTintColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"HelveticaNeue-Light" size:22],NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.title = [NSString stringWithFormat:@"%@", [self.topic objectForKey:@"topicName"]];
    
    UIColor *color = [UIColor blackColor];
    self.discussionTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"What would you like to discuss?" attributes:@{NSForegroundColorAttributeName: color}];
    
    UITapGestureRecognizer *tapDismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapDismissKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.discussionTextField resignFirstResponder];
}

- (IBAction)savePressed:(UIBarButtonItem *)sender {
    
    self.discussionString = [self.discussionTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *tooLongString = [NSString stringWithFormat:@"The discussion title must be under 70 characters. Currently, it is %ld characters", (long)[self.discussionString length]];
    
    if ([self.discussionString length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Please enter some text."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else if ([self.discussionString length] > 70) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:tooLongString
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
}

@end
