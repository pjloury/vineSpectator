//
//  VSStackView.m
//  VineSpectator
//
//  Created by PJ Loury on 12/26/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSStackView.h"

@interface VSStackView ()

@property (nonatomic) UIStackView *stackView;

@end

@implementation VSStackView

- (void)reloadData
{
    NSMutableArray *views = [NSMutableArray array];
    for (int i = 0; i < [self.dataSource numberOfViewsInStack]; i++) {
        
        UIView *view = [self.dataSource viewForIndex:i];
        view.tag = i;
        UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagViewWasTapped:)];
        [view addGestureRecognizer:tapRec];
        [views addObject:[self.dataSource viewForIndex:i]];
    }
    self.stackView = [[UIStackView alloc ] initWithArrangedSubviews:views];
    self.stackView.alignment = UIStackViewAlignmentCenter;
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
    self.stackView.distribution = UIStackViewDistributionFillProportionally;
    self.stackView.spacing = 30.0f;
    [self addSubview:self.stackView];
    
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.bottom.right.equalTo(self);
        make.left.equalTo(self).offset(20);
    }];
}

- (void)tagViewWasTapped:(id)sender
{
    UIView *view = (UIView *)sender;
    [self.delegate stackView:self didSelectViewAtIndex:view.tag];
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake( ([self.dataSource numberOfViewsInStack]-2) * 90 + 2 * 73, 50);
}


@end
