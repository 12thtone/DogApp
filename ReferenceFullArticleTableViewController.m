//
//  ReferenceFullArticleTableViewController.m
//  DogApp
//
//  Created by Matt Maher on 4/23/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import "ReferenceFullArticleTableViewController.h"
#import <Parse/Parse.h>

@interface ReferenceFullArticleTableViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *fullArtImage;
@property (strong, nonatomic) IBOutlet UILabel *fullArtTitle;
@property (strong, nonatomic) IBOutlet UITextView *fullArtText;

@end

@implementation ReferenceFullArticleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    self.tabBarController.tabBar.alpha = 0.6;
    [self.tabBarController.tabBar setBarTintColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"HelveticaNeue-Light" size:22],NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Full Article", nil)];
    
    [self.article fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        PFFile *pictureFile = [self.article objectForKey:@"picture"];
        
        [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error){
                
                [self.fullArtImage setImage:[UIImage imageWithData:data]];
                
                self.fullArtTitle.text = [self.article objectForKey:@"articleTitle"];
                self.fullArtText.text = [self.article objectForKey:@"articleText"];
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

@end
