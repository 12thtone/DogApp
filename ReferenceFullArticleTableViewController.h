//
//  ReferenceFullArticleTableViewController.h
//  DogApp
//
//  Created by Matt Maher on 4/23/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface ReferenceFullArticleTableViewController : UITableViewController

@property (nonatomic, strong) PFObject *article;

@end
