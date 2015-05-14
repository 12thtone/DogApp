//
//  FullSearchResultTableViewController.h
//  DogApp
//
//  Created by Matt Maher on 5/14/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface FullSearchResultTableViewController : UITableViewController

@property (nonatomic, strong) PFObject *postForum;
@property (nonatomic, strong) PFObject *postReference;

@end
