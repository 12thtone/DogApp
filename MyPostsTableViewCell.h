//
//  MyPostsTableViewCell.h
//  DogApp
//
//  Created by Matt Maher on 5/13/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPostsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *postName;
@property (strong, nonatomic) IBOutlet UIButton *deletePostButton;

@end
