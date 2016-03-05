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

@interface VSFilterStackViewController () <VSStackViewDelegate>

@property VSStackView *stackView;
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
    self.stackView.delegate = self;
    self.stackView.dataSource = self.tagsDataSource;
    
    [self.stackScrollView addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make){
        //make.left.equalTo(self.stackScrollView.left);
        make.top.equalTo(self.stackScrollView.top);
        make.height.equalTo(self.stackScrollView.height);
    }];
    
    self.stackScrollView.contentOffset = CGPointZero;
    
    //self.stackView.frame.origin = self.stackScrollView.frame.origin;
    //self.stackView.frame = CGRectMake(0,0,self.stackView.intrinsicContentSize.width,self.stackView.intrinsicContentSize.height);
    self.stackScrollView.userInteractionEnabled = YES;
    
    [self.stackView reloadData];
//    [self.stackView sizeToFit];
    
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
    if (index != self.tagsDataSource.allTags.count) {
        NSString *tag = [self.tagsDataSource textForStackIndex:index];
        [self.delegate filterStackViewController:self didDeselectTag:tag];
    }
}

- (void)stackView:(VSStackView *)stackView didSelectViewAtIndex:(NSInteger)index
{
    if (index == self.tagsDataSource.allTags.count) {
        [self.delegate didPressViewAllTags:self];
    } else {
        NSString *tag = [self.tagsDataSource textForStackIndex:index];
        [self.delegate filterStackViewController:self didSelectTag:tag];
    }
}

@end
