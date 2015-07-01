//
//  FullResponseViewController.m
//  DogApp
//
//  Created by Matthew Maher on 7/1/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import "FullResponseViewController.h"
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>

@interface FullResponseViewController () <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageProfile;
@property (strong, nonatomic) IBOutlet UILabel *fullRespHeadline;
@property (strong, nonatomic) IBOutlet UITextView *fullRespText;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
- (IBAction)shareResponse:(id)sender;
- (IBAction)reportViolation:(id)sender;

@end

@implementation FullResponseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    self.tabBarController.tabBar.alpha = 0.7;
    [self.tabBarController.tabBar setBarTintColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"HelveticaNeue-Light" size:22],NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Full Response", nil)];
    
    PFUser *user = [self.response objectForKey:@"author"];
    [user fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        self.usernameLabel.text = [object objectForKey:@"username"];
        
        NSLog(@"%@", [self.response objectForKey:@"username"]);
        
        PFFile *pictureFile = [user objectForKey:@"picture"];
        [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error){
                
                [self.imageProfile setImage:[UIImage imageWithData:data]];
                self.fullRespHeadline.text = [self.response objectForKey:@"DiscussionText"];
                self.fullRespText.text = [self.response objectForKey:@"responseBody"];
                
            }
            else {
                NSLog(@"no data!");
            }
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareResponse:(id)sender {
    NSString *messageBody = [NSString stringWithFormat:@"%@ found a response for you on Vitalidog!\n\n%@ wrote the following:\n\n%@\n\nTo view this response, and tons more like it, download Vitalidog!\n\nhttp://www.12thtone.com", [[PFUser currentUser] username], [[self.response objectForKey:@"author"] username], [self.response objectForKey:@"responseBody"]];
    
    NSMutableArray *articleToShare = [NSMutableArray array];
    [articleToShare addObject:messageBody];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:articleToShare applicationActivities:nil];
    
    if (!([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)) {
        activityVC.popoverPresentationController.sourceView = self.view;
    }
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
    if (UIActivityTypeMail) {
        [activityVC setValue:@"Vitalidog" forKey:@"subject"];
    }
}

- (IBAction)reportViolation:(id)sender {
    
    MFMailComposeViewController *violationReport = [[MFMailComposeViewController alloc] init];
    violationReport.mailComposeDelegate = self;
    
    NSString *emailBody = [NSString stringWithFormat:@"Reporting User: %@ \n\nViolating User: %@ \n\nPost Number: %@ \n\nAdditional Details: \n\nWe will review your report within 24 hours. Rule violations are taken very seriously.\n\nThank you very much for helping to make Vitalidog a better place!", [[PFUser currentUser] username], [[self.response objectForKey:@"author"] username], [[self.response objectForKey:@"author"] objectId]];
    
    [violationReport setSubject:@"Vitalidog Violation - URGENT"];
    [violationReport setMessageBody:emailBody isHTML:NO];
    [violationReport setToRecipients:[NSArray arrayWithObjects:@"contact@12thtone.com",nil]];
    
    [self presentViewController:violationReport animated:YES completion:NULL];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
