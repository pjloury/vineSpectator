//
//  VSFilterStackViewController.m
//  VineSpectator
//
//  Created by PJ Loury on 12/26/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSFilterStackViewController.h"
#import "VSStackView.h"
#import "VSTagsDataSource.h"
#import "VSScrollView.h"

@interface VSFilterStackViewController () <VSStackViewDelegate, UITextFieldDelegate>

@property VSScrollView *stackScrollView;
@property VSTagsDataSource *tagsDataSource;

@end

@implementation VSFilterStackViewController

- (instancetype)init
{
    self = [super init];
    self.tagsDataSource = [[VSTagsDataSource alloc] init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightSalmonColor];
    self.stackScrollView = [[VSScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,50)];
    
    [self.view addSubview:self.stackScrollView];
    self.stackScrollView.canCancelContentTouches = YES;
    self.stackScrollView.showsHorizontalScrollIndicator = NO;
    
    self.stackView = [[VSStackView alloc] init];
    self.stackView.searchField.delegate = self;
    self.stackView.delegate = self;
    self.stackView.dataSource = self.tagsDataSource;
    
    [self.stackScrollView addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.stackScrollView.top);
        make.height.equalTo(self.stackScrollView.height);
    }];
    
    self.stackScrollView.contentOffset = CGPointZero;
    self.stackScrollView.userInteractionEnabled = YES;
    
    [self.stackView reloadData];
    
    self.stackScrollView.contentSize = self.stackView.intrinsicContentSize;
    self.stackScrollView.alwaysBounceHorizontal = YES;
    self.stackScrollView.scrollEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.stackView reloadData];
    self.stackScrollView.contentSize = self.stackView.intrinsicContentSize;
}

# pragma mark - VSStackViewDelegate
- (void)stackView:(VSStackView *)stackView didDeselectViewAtIndex:(NSInteger)index
{
    NSString *tag = [self.tagsDataSource textForStackIndex:index];
    if ([tag isEqualToString:@"Search"]) {
        self.stackScrollView.contentOffset = CGPointZero;
        [self.stackView dismissSearchField];
    }
    else if (![tag isEqualToString:@"Edit"]) {
        NSString *tag = [self.tagsDataSource textForStackIndex:index];
        [self.delegate filterStackViewController:self didDeselectTag:tag];
    }
}

- (void)stackView:(VSStackView *)stackView didSelectViewAtIndex:(NSInteger)index
{
    NSInteger totalTags = self.tagsDataSource.allTags.count;
    switch (index) {
        case VSFilterTypeSearch:
            [self.stackView revealSearchField];
            break;
        case VSFilterTypeChrono:
            [self.stackView dismissSearchField];
            [self.delegate filterStackViewController:self didSelectFilter:VSFilterTypeChrono];
            break;
        case VSFilterTypeDrank:
            [self.stackView dismissSearchField];
            [self.delegate filterStackViewController:self didSelectFilter:VSFilterTypeDrank];
            break;
        case VSFilterTypeRed:
            [self.stackView dismissSearchField];
            [self.delegate filterStackViewController:self didSelectFilter:VSFilterTypeRed];
            break;
        case VSFilterTypeWhite:
            [self.stackView dismissSearchField];
            [self.delegate filterStackViewController:self didSelectFilter:VSFilterTypeWhite];
            break;
        default:
            if (index == totalTags -1) {
                [self.stackView dismissSearchField];
                [self.delegate didPressViewAllTags:self];
            } else {
                [self.stackView dismissSearchField];
                 NSString *tag = [self.tagsDataSource textForStackIndex:index];
                [self.delegate filterStackViewController:self didSelectTag:tag];
            }
            break;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.delegate filterStackViewController:self didReceiveSearchText:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    return YES;
}

@end
