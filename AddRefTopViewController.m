//
//  AddRefTopViewController.m
//  DogApp
//
//  Created by Matt Maher on 4/23/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import "AddRefTopViewController.h"
#import "DataSource.h"
#import <Parse/Parse.h>

@interface AddRefTopViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *referenceTopicName;
@property (strong, nonatomic) IBOutlet UIImageView *topicImage;
- (IBAction)imageLibrary:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@property (nonatomic, strong) NSString *topicString;
@property (weak, nonatomic) UIImage *chosenImage;

@end

@implementation AddRefTopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    self.tabBarController.tabBar.alpha = 0.7;
    [self.tabBarController.tabBar setBarTintColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"HelveticaNeue-Light" size:22],NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Add Ref Topic", nil)];
    
    UITapGestureRecognizer *tapDismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapDismissKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.referenceTopicName resignFirstResponder];
}

- (IBAction)save:(UIBarButtonItem *)sender {
    
    self.topicString = [self.referenceTopicName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([self.topicString length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Please enter some text."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else if (!self.chosenImage) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Please choose an image."
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
    NSData *imageData = UIImageJPEGRepresentation(self.chosenImage, 0.0f);
    PFFile *imageFile = [PFFile fileWithName:@"Profileimage.png" data:imageData];
    
    PFObject *newTopic = [PFObject objectWithClassName:@"ReferenceTopics"];
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

#pragma mark - Image Library

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

@end
