//
//  AddForumTopViewController.m
//  DogApp
//
//  Created by Matt Maher on 4/23/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import "AddForumTopViewController.h"
#import "DataSource.h"
#import <Parse/Parse.h>

@interface AddForumTopViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *forumTopicName;
@property (strong, nonatomic) IBOutlet UIImageView *topicImage;
//- (IBAction)imageLibrary:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
//- (IBAction)imageCamera:(id)sender;

@property (nonatomic, strong) NSString *topicString;
@property (weak, nonatomic) UIImage *chosenImage;

@end

@implementation AddForumTopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    self.tabBarController.tabBar.alpha = 0.7;
    [self.tabBarController.tabBar setBarTintColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"HelveticaNeue-Light" size:22],NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Add Forum Topic", nil)];
    
    UITapGestureRecognizer *tapDismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapDismissKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.forumTopicName resignFirstResponder];
}

- (IBAction)save:(UIBarButtonItem *)sender {
    
    self.topicString = [self.forumTopicName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([self.topicString length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Please enter some text."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else if ([self.topicString length] > 11) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Must be 11 characters or less."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else {
        
        if ([[DataSource sharedInstance] filterForProfanity:self.topicString] == NO) {
            [self saveTopic];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Uh oh!"
                                                                message:@"We found a banned word."
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }
    
    
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveTopic
{    
    //NSData *imageData = UIImageJPEGRepresentation(self.chosenImage, 0.0f);
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"FurLong.png"], 0.0f);
    //NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"placeholder.png"]);
    PFFile *imageFile = [PFFile fileWithName:@"Profileimage.png" data:imageData];
    
    PFObject *newTopic = [PFObject objectWithClassName:@"ForumTopics"];
    newTopic[@"topicName"] = self.topicString;
    newTopic[@"picture"] = imageFile;
    
    [newTopic saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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
/*
#pragma mark - Images

- (IBAction)imageLibrary:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.chosenImage = info[UIImagePickerControllerEditedImage];
    self.topicImage.image = self.chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)imageCamera:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                              message:@"This device has no camera."
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}
*/
@end
