//
//  VSDetailViewController.h
//  VineSpectator
//
//  Created by PJ Loury on 11/23/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSBottleDataSource.h"

@interface VSDetailViewController : VSViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) BOOL editMode;
- (instancetype)initWithBottleDataSource:(VSBottleDataSource *)bottleDataSource bottleID:(NSString *)bottleID;

@end

@protocol VSImageSelectionDelegate

- (void)imageButtonWasPressed:(id)button;

@end
