//
//  VSAddBottleViewController.h
//  VineSpectator
//
//  Created by PJ Loury on 11/22/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSBottleDataSource.h"
#import "VSGrapeVarietyDataSource.h"

@interface VSAddBottleViewController : VSViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (instancetype)initWithBottleDataSource:(VSBottleDataSource *)bottleSource bottleID:(NSString *)bottleID;

@end
