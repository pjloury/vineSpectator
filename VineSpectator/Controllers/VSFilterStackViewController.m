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

@interface VSFilterStackViewController () <VSStackViewDelegate>

@property VSStackView *stackView;
@property UIScrollView *stackScrollView;
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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightSalmonColor];
    self.stackScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,50)];
    [self.view addSubview:self.stackScrollView];
    
    self.stackView = [[VSStackView alloc] initWithFrame:CGRectMake(0,0,650,50)];
    self.stackScrollView.showsHorizontalScrollIndicator = NO;
    //self.stackView.frame = CGRectMake(0,0,self.stackView.intrinsicContentSize.width,self.stackView.intrinsicContentSize.height);
    self.stackView.delegate = self;
    self.stackView.dataSource = self.tagsDataSource;
    [self.stackScrollView addSubview:self.stackView];
    
    [self.stackView reloadData];
    
    self.stackScrollView.contentSize = self.stackView.intrinsicContentSize;
    self.stackScrollView.alwaysBounceHorizontal = YES;
    self.stackScrollView.scrollEnabled = YES;
    
    //    UIView *foo = [[UIView alloc] initWithFrame:CGRectMake(0,0,500,500)];
    //    foo.backgroundColor = [UIColor orangeColor];
    //    [self.stackScrollView addSubview:foo];
    
    // size the stackview to FIT all its views
//    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.top.bottom.equalTo(self.stackScrollView);
//    }];
}

# pragma mark - VSStackViewDelegate

- (void)stackView:(VSStackView *)stackView didSelectViewAtIndex:(NSInteger)index
{
    NSString *tag = [self.tagsDataSource textForStackIndex:index];
    [self.delegate filterStackViewController:self didSelectTag:tag];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
