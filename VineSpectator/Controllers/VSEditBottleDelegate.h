//
//  VSEditBottleDelegate.h
//  VineSpectator
//
//  Created by PJ Loury on 12/24/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSDetailViewController.h"

@class VSBottleDataSource;
@class VSBotle;

@interface VSEditBottleDelegate : NSObject<UITableViewDelegate>

@property (weak)  VSDetailViewController *viewController;
@property UITapGestureRecognizer *tapRecognizer;
- (instancetype)initWithTableView:(UITableView *)tableView bottleDataSource:(VSBottleDataSource *)bottleDataSource bottleID:(NSString *)bottleID;

@end
