//
//  ReferenceArticlesTableViewController.h
//  DogApp
//
//  Created by Matt Maher on 4/23/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface ReferenceArticlesTableViewController : PFQueryTableViewController

@property (nonatomic, strong) PFObject *topic;

@end
