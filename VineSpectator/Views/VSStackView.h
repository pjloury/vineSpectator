//
//  VSStackView.h
//  VineSpectator
//
//  Created by PJ Loury on 12/26/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VSStackView;

@protocol VSStackViewDataSource

- (NSInteger)numberOfViewsInStack;
- (UIView *_Nonnull)viewForIndex:(NSInteger)index;

@end

@protocol VSStackViewDelegate

- (void)stackView:(VSStackView *_Nonnull)stackView didSelectViewAtIndex:(NSInteger)index;
- (void)stackView:(VSStackView *_Nonnull)stackView didDeselectViewAtIndex:(NSInteger)index;

@end


@interface VSStackView : UIView

- (void)reloadData;

@property (nonatomic, weak, nullable) id <VSStackViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id <VSStackViewDelegate> delegate;

@end
