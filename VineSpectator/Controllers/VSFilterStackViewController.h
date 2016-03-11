//
//  VSFilterStackViewController.h
//  VineSpectator
//
//  Created by PJ Loury on 12/26/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSStackView.h"

typedef NS_ENUM(NSInteger, VSFilterType) {
    VSFilterTypeAll = -1,
    VSFilterTypeSearch = 0,
    VSFilterTypeChrono = 1,
    VSFilterTypeDrank = 2,
    VSFilterTypeRed = 3,
    VSFilterTypeWhite = 4,
    VSFilterTypeTag = 5
};

@class VSFilterStackViewController;

@protocol VSFilterSelectionDelegate

- (void)didPressViewAllTags:(id)sender;
- (void)filterStackViewController:(VSFilterStackViewController *)viewController didSelectFilter:(VSFilterType)tag;
- (void)filterStackViewController:(VSFilterStackViewController *)viewController didSelectTag:(NSString *)tag;
- (void)filterStackViewController:(VSFilterStackViewController *)viewController didDeselectTag:(NSString *)tag;
- (void)filterStackViewController:(VSFilterStackViewController *) viewController didReceiveSearchText:(NSString *)text;

@end

@interface VSFilterStackViewController : UIViewController

@property VSStackView *stackView;
@property (nonatomic, weak) id<VSFilterSelectionDelegate> delegate;

@end
