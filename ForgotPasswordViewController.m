//
//  ForgotPasswordViewController.m
//  DogApp
//
//  Created by Matt Maher on 5/6/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import <Parse/Parse.h>

@interface ForgotPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userEmail;
@property (weak, nonatomic) IBOutlet UIButton *submitEmail;

- (IBAction)cancel:(id)sender;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    self.tabBarController.tabBar.alpha = 0.7;
    [self.tabBarController.tabBar setBarTintColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"HelveticaNeue-Light" size:22],NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Forgot", nil)];
    
    [self.submitEmail addTarget:self action:@selector(submitEmail:) forControlEvents:UIControlEventTouchUpInside];
    self.submitEmail.layer.cornerRadius = 8;
    self.submitEmail.layer.masksToBounds = YES;
    
    UIColor *color = [UIColor blackColor];
    self.userEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Address" attributes:@{NSForegroundColorAttributeName: color}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitEmail:(id)sender {
    
    if (self.userEmail.text.length == 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Please enter your email address."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else {
        
        NSString *email = [self.userEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [PFUser requestPasswordResetForEmailInBackground:email];
        
        [self usernameQuery];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (PFQuery *)usernameQuery {
    
    PFQuery *query = [PFUser query];
    
    [query whereKey:@"email" equalTo:self.userEmail.text];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *user in objects) {
            NSString *usernameString = [NSString stringWithFormat:@"%@, we sent you a link to reset your password.", [user objectForKey:@"username"]];
            NSString *username = [NSString stringWithFormat:@"Hey, %@!", [user objectForKey:@"username"]];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:username
                                                                message:usernameString
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
    
    return query;
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
