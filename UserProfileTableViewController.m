//
//  UserProfileTableViewController.m
//  DogApp
//
//  Created by Matt Maher on 4/23/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import "UserProfileTableViewController.h"
#import <Parse/Parse.h>

@interface UserProfileTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *usernameProfile;
@property (weak, nonatomic) IBOutlet UITextView *descriptionProfile;
@property (weak, nonatomic) IBOutlet UIImageView *imageProfile;
@property (weak, nonatomic) IBOutlet UILabel *realNameLabel;

//@property (weak, nonatomic) PFUser *user;

- (IBAction)closeProfile:(id)sender;

@end

@implementation UserProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    self.tabBarController.tabBar.alpha = 0.6;
    [self.tabBarController.tabBar setBarTintColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"HelveticaNeue-Light" size:22],NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"User Profile", nil)];
    
    [self.imageProfile setImage:[UIImage imageNamed:@"placeholder.png"]];
    
    self.descriptionProfile.layer.cornerRadius = 8.0;
    self.descriptionProfile.layer.masksToBounds = YES;
    
    //[self.descriptionProfile setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
    //[self.descriptionProfile setAlpha:0.7];
    
    [self.userToProfile fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        PFFile *pictureFile = [self.userToProfile objectForKey:@"picture"];
        
        [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error){
                
                [self.imageProfile setImage:[UIImage imageWithData:data]];
                
                self.descriptionProfile.text = [self.userToProfile objectForKey:@"description"];
                //self.usernameProfile.text = [self.userToProfile objectForKey:@"username"];
                self.usernameProfile.text = [self.userToProfile username];
                self.realNameLabel.text = [self.userToProfile objectForKey:@"realName"];
                
            }
            else {
                NSLog(@"no data!");
            }
        }];
    }];
    
    //[self tabbersQuery];
    //[self jokeQuery];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[self userTabbingQuery];
}

#pragma mark - PFQuery
/*
- (void)tabbersQuery {
    NSMutableArray *tabberArray = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Tab"];
    
    [query whereKey:@"tabReceiver" equalTo:self.user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *tabber in objects) {
            [tabberArray addObject:tabber];
            
            self.theTabbers = [tabberArray copy];
        }
        
        self.tabbersCount = self.theTabbers.count;
        
        NSString *totalTabberString = [NSString stringWithFormat:@"%lu", (unsigned long)self.self.tabbersCount];
        self.totalTabbers.text = totalTabberString;
    }];
}
*//*
- (void)userTabbingQuery {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Tab"];
    
    [query whereKey:@"tabReceiver" equalTo:self.user];
    [query whereKey:@"tabMaker" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count == 0) {
            [self.keepTabsButton setTitle:@" Keep Tabs" forState:UIControlStateNormal];
            [self.keepTabsButton setImage:[UIImage imageNamed:@"tag-plus-7@3x.png"] forState:UIControlStateNormal];
        } else {
            [self.keepTabsButton setTitle:@" Untab" forState:UIControlStateNormal];
            [self.keepTabsButton setImage:[UIImage imageNamed:@"tag-minus-7@3x.png"] forState:UIControlStateNormal];
        }
    }];
}
*//*
- (void)jokeQuery {
    NSMutableArray *jokeArray = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Question"];
    
    [query whereKey:@"author" equalTo:self.user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *joke in objects) {
            [jokeArray addObject:joke];
            
            self.theJokes = [jokeArray copy];
        }
        
        NSString *totalJokesString = [NSString stringWithFormat:@"%lu", (unsigned long)self.theJokes.count];
        self.jokesCount.text = totalJokesString;
        
    }];
}
*//*
- (void)untabDeleteQuery {
    NSMutableArray *untabArray = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Tab"];
    
    [query whereKey:@"tabMaker" equalTo:[PFUser currentUser]];
    [query whereKey:@"tabReceiver" equalTo:self.user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *tabber in objects) {
            [untabArray addObject:tabber];
            
            [tabber deleteInBackground];
        }
        
        self.tabbersCount = self.tabbersCount - 1;
        NSString *totalTabberString = [NSString stringWithFormat:@"%lu", (unsigned long)self.tabbersCount];
        self.totalTabbers.text = totalTabberString;
    }];
}
*//*
- (void)setTabData:(NSMutableArray *)tabData {
    [self tabbersQuery];
    self.theTabbers = tabData;
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeProfile:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
- (void)keepTabs:(id)sender {
    
    NSMutableArray *tabbersList = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Tab"];
    
    [query whereKey:@"tabReceiver" equalTo:self.user];
    [query whereKey:@"tabMaker" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFUser *aUser in objects) {
            [tabbersList addObject:aUser];
        }
        
        if (tabbersList.count == 0) {
            
            [self saveTabs];
        } else {
            [self deleteTabs];
        }
    }];
    
}
*//*
- (IBAction)viewUserQuestions:(id)sender {
}

- (void)saveTabs {
    
    PFObject *newTab = [PFObject objectWithClassName:@"Tab"];
    newTab[@"tabMaker"] = [PFUser currentUser];
    newTab[@"tabReceiver"] = self.user;
    
    NSString *userString = [NSString stringWithFormat:@"You're keeping tabs on %@", [self.user username]];
    
    [newTab saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Tabs!"
                                                                message:userString
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        
        [self.keepTabsButton setTitle:@" Untab" forState:UIControlStateNormal];
        [self.keepTabsButton setImage:[UIImage imageNamed:@"tag-minus-7@3x.png"] forState:UIControlStateNormal];
        
        self.tabbersCount = self.tabbersCount + 1;
        NSString *totalTabberString = [NSString stringWithFormat:@"%lu", (unsigned long)self.tabbersCount];
        self.totalTabbers.text = totalTabberString;
        
    }];
}
*//*
- (void)deleteTabs {
    
    NSString *userString = [NSString stringWithFormat:@"You're no longer keeping tabs on %@", [self.user username]];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Untabbed"
                                                        message:userString
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
    [self.keepTabsButton setTitle:@" Keep Tabs" forState:UIControlStateNormal];
    [self.keepTabsButton setImage:[UIImage imageNamed:@"tag-plus-7@3x.png"] forState:UIControlStateNormal];
    [self untabDeleteQuery];
    
}
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /*
    if ([segue.identifier isEqualToString:@"viewTabbers"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        AllTabbersTableViewController *allTabbersTableViewController = (AllTabbersTableViewController * )navigationController.topViewController;
        allTabbersTableViewController.user = self.user;
    }
    *//*
    if ([segue.identifier isEqualToString:@"viewUserQuestions"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        UserJokeTableViewController *userQuestionTableViewController = (UserJokeTableViewController * )navigationController.topViewController;
        userQuestionTableViewController.user = self.user;
    }
       */
}

@end