//
//  VSStackView.m
//  VineSpectator
//
//  Created by PJ Loury on 12/26/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSStackView.h"
#import "VSFilterView.h"

@interface VSStackView ()

@property (nonatomic) UIStackView *stackView;

@end

@implementation VSStackView

- (void)reloadData
{
    self.userInteractionEnabled = YES;
    NSMutableArray *views = [NSMutableArray array];
    for (int i = 0; i < [self.dataSource numberOfViewsInStack]; i++) {
        
        UIView *view = [self.dataSource viewForIndex:i];
        view.tag = i;
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagViewWasTapped:)];
        [view addGestureRecognizer:tapRec];
        [views addObject:view];
    }
    self.stackView = [[UIStackView alloc ] initWithArrangedSubviews:views];
    self.stackView.alignment = UIStackViewAlignmentCenter;
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
    self.stackView.distribution = UIStackViewDistributionEqualSpacing;
    self.stackView.spacing = 0.0f;
    [self addSubview:self.stackView];
    
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.bottom.right.equalTo(self);
    }];
}

- (void)tagViewWasTapped:(UIGestureRecognizer *)sender
{
    UIButton *button = (UIButton *)sender.view;
    button.selected = !button.selected;
    if (button.selected) {
        [self unSelectAllButtonsExcept:button.tag];
        button.backgroundColor = [UIColor roseColor];
        [self.delegate stackView:self didSelectViewAtIndex:sender.view.tag];
    } else {
        button.backgroundColor = [UIColor lightSalmonColor];
        [self.delegate stackView:self didDeselectViewAtIndex:sender.view.tag];
    }
}

- (void)unSelectAllButtonsExcept:(NSInteger)tag
{
    for (NSInteger i = 0; i < self.dataSource.numberOfViewsInStack; i++) {
        UIButton *button = (UIButton *)self.stackView.arrangedSubviews[i];
        if (button.tag != tag) {
            button.backgroundColor = [UIColor lightSalmonColor];
            button.selected = NO;
        }
    }
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake( ([self.dataSource numberOfViewsInStack]-2) * 90 + 2 * 73, 50);
}


@end
