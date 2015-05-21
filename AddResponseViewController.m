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
@property (nonatomic, strong) NSString *responseBodyString;

@property (strong, nonatomic) IBOutlet UITextField *responseTextField;
@property (strong, nonatomic) IBOutlet UITextView *responseTextBody;

- (IBAction)savePressed:(UIBarButtonItem *)sender;

@end

@implementation AddResponseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    self.tabBarController.tabBar.alpha = 0.7;
    [self.tabBarController.tabBar setBarTintColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"HelveticaNeue-Light" size:16],NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.title = [NSString stringWithFormat:@"%@", [self.discussion objectForKey:@"DiscussionText"]];
    
    UIColor *color = [UIColor blackColor];
    self.responseTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Response Headline" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.responseTextBody.layer.cornerRadius = 8.0;
    self.responseTextBody.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapDismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapDismissKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.responseTextField resignFirstResponder];
    [self.responseTextBody resignFirstResponder];
}

- (IBAction)savePressed:(UIBarButtonItem *)sender {
    
    self.responseString = [self.responseTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.responseBodyString = [self.responseTextBody.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *tooLongString = [NSString stringWithFormat:@"The headline must be under 40 characters. Currently, it is %ld characters", (long)[self.responseString length]];
    
    if ([self.responseString length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Please enter some text."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else if ([self.responseBodyString length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Please enter some text."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else if ([self.responseString length] > 40) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:tooLongString
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
    newResponse[@"responseBody"] = self.responseBodyString;
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
    
}

@end
