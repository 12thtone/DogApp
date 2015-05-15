//
//  SearchTableViewCell.h
//  DogApp
//
//  Created by Matt Maher on 5/14/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *searchLabel;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;

@end
