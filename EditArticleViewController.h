//
//  EditArticleViewController.h
//  DogApp
//
//  Created by Matthew Maher on 6/28/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface EditArticleViewController : UIViewController

@property (nonatomic, strong) PFObject *article;

@end
