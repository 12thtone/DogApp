//
//  ResponsesTableViewCell.h
//  DogApp
//
//  Created by Matt Maher on 4/17/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResponsesTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *userImageButton;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *responseTextLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;

@end
