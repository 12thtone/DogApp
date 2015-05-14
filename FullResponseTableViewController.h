//
//  FullResponseTableViewController.h
//  DogApp
//
//  Created by Matt Maher on 5/13/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface FullResponseTableViewController : UITableViewController

@property (nonatomic, strong) PFObject *response;

@end
