//
//  VSFilterStackViewController.h
//  VineSpectator
//
//  Created by PJ Loury on 12/26/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VSFilterStackViewController;

@protocol VSFilterSelectionDelegate

- (void)filterStackViewController:(VSFilterStackViewController *)viewController didSelectTag:(NSString *)tag;

@end

@interface VSFilterStackViewController : UIViewController

@property (nonatomic, weak) id<VSFilterSelectionDelegate> delegate;

@end
