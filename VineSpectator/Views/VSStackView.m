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

@property NSString *selectedTag;
@property (nonatomic) UIStackView *stackView;
@property BOOL searchOpen;
@property UIButton *addButton;

@end

@implementation VSStackView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _searchField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
        _searchField.backgroundColor = [UIColor roseColor];
        _searchField.textColor = [UIColor goldColor];
        _searchField.placeholder = @"Search For Bottle";
        _searchField.font = [UIFont fontWithName:@"Athelas-Regular" size:20];
        _searchField.autocorrectionType = UITextAutocorrectionTypeNo;
        [_searchField mas_makeConstraints:^(MASConstraintMaker *make){
            make.width.equalTo(@150);
            make.height.equalTo(@50);
        }];
    }    
    return self;
}

- (void)reloadData
{
    self.userInteractionEnabled = YES;
    NSMutableArray *views = [NSMutableArray array];
    [self.stackView removeFromSuperview];
    for (int i = 0; i < [self.dataSource numberOfViewsInStack]; i++) {
        // view for index 2
        UIView *view = [self.dataSource viewForIndex:i];
        view.tag = i;
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagViewWasTapped:)];
        [view addGestureRecognizer:tapRec];
        UIButton *button = (UIButton *)view;
        if([self.selectedTag isEqualToString:[self.dataSource textForStackIndex:i]]) {
            button.backgroundColor = [UIColor roseColor];
            [button setSelected:YES];
        }
        [views addObject:view];
    }
    self.addButton = views.firstObject;
    self.stackView = [[UIStackView alloc ] initWithArrangedSubviews:views];
    if (self.searchOpen) {
        [self revealSearchField];
    }
    
    self.stackView.alignment = UIStackViewAlignmentCenter;
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
//    self.stackView.distribution = UIStackViewDistributionEqualSpacing;
    self.stackView.spacing = 0.0f;
    [self addSubview:self.stackView];
    
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.bottom.right.equalTo(self);
    }];
}

- (void)revealSearchField
{
    self.searchOpen = YES;
    [self.stackView insertArrangedSubview:self.searchField atIndex:1];
    [self.searchField becomeFirstResponder];
}

- (void)dismissSearchField
{
    self.searchOpen = NO;
    self.searchField.text = @"";
    [self.searchField resignFirstResponder];
    [self.stackView removeArrangedSubview:self.searchField];
    [self.searchField removeFromSuperview];
    [self reloadData];
}

- (void)tagViewWasTapped:(UIGestureRecognizer *)sender
{
    UIButton *button = (UIButton *)sender.view;
    if (button.tag != self.dataSource.numberOfViewsInStack-1) {
        button.selected = !button.selected;
        if (button.selected) {
            self.selectedTag = [self.dataSource textForStackIndex:button.tag];
            [self unSelectAllButtonsExcept:button.tag];
            button.backgroundColor = [UIColor roseColor];
            [self.delegate stackView:self didSelectViewAtIndex:sender.view.tag];
        } else {
            self.selectedTag = nil;
            button.backgroundColor = [UIColor lightSalmonColor];
            [self.delegate stackView:self didDeselectViewAtIndex:sender.view.tag];
        }
    } else {
        [self.delegate stackView:self didSelectViewAtIndex:sender.view.tag];
    }
}

- (void)unSelectAllButtonsExcept:(NSInteger)tag
{
    for (NSInteger i = 0; i < self.dataSource.numberOfViewsInStack; i++) {
        UIButton *button = (UIButton *)self.stackView.arrangedSubviews[i];
        if (button.tag != tag && ![button isKindOfClass:[UITextField class]]) {
            button.backgroundColor = [UIColor lightSalmonColor];
            button.selected = NO;
        }
    }
}

- (CGSize)intrinsicContentSize
{
    NSInteger totalWidth;
    for (NSInteger i = 0; i < self.dataSource.numberOfViewsInStack; i++) {
        UIButton *button = (UIButton *)self.stackView.arrangedSubviews[i];
        NSLog(@"%f",button.frame.size.width);
        totalWidth += (button.frame.size.width + 20);
    }
    return CGSizeMake(totalWidth, 50);
}

@end
