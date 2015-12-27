//
//  VSTableViewController.h
//  VineSpectator
//
//  Created by PJ Loury on 11/22/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VSStackViewDelegate;

@protocol VSFilterSelectionDelegate

- (void)stackViewDelegate:(VSStackViewDelegate *)delegate didSelectFilter:(NSString *)filter;

@end


@interface VSTableViewController : VSViewController


@end
