//
//  ResponsesTableViewController.h
//  DogApp
//
//  Created by Matt Maher on 4/17/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface ResponsesTableViewController : PFQueryTableViewController

@property (nonatomic, strong) PFObject *discussion;

@end
