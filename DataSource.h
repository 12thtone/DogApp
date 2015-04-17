//
//  DataSource.h
//  DogApp
//
//  Created by Matt Maher on 4/16/15.
//  Copyright (c) 2015 Matt Maher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseUI/ParseUI.h>

@interface DataSource : NSObject

+ (instancetype) sharedInstance;

- (PFQuery *)queryForTable:(NSString *)className;

- (BOOL)emailNotificationAllowed:(BOOL)yesOrNo;

-(BOOL)filterForProfanity:(NSString *)text;

@end
