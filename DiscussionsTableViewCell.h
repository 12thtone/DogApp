//
//  DiscussionsTableViewCell.h
//  DogApp
//
//  Created by Matt Maher on 4/16/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscussionsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *userImageButton;
//@property (strong, nonatomic) IBOutlet UIButton *userImage;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *discussionText;
@property (strong, nonatomic) IBOutlet UILabel *username;

@end
