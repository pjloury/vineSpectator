//
//  VSTagsViewController.m
//  VineSpectator
//
//  Created by PJ Loury on 3/4/16.
//  Copyright © 2016 PJ Loury. All rights reserved.
//

#import "VSTagsViewController.h"
#import "VSTagsDataSource.h"
#import "VSTextView.h"

@interface VSTagsViewController ()

@property (nonatomic) VSTagsDataSource *dataSource;
@property (nonatomic) VSTextView *textView;
@property (nonatomic) UILabel *instructionsLabel;
@property (nonatomic) UITapGestureRecognizer *dismissKeyboardTapGestureRecognizer;

@end

@implementation VSTagsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataSource = [[VSTagsDataSource alloc] init];
        _instructionsLabel = [[UILabel alloc] init];
        _textView = [[VSTextView alloc] init];
        _dismissKeyboardTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(dismissKeyboard)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:self.dismissKeyboardTapGestureRecognizer];
    
    [self.view addSubview:self.instructionsLabel];
    [self.instructionsLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view.centerX);
        make.left.equalTo(self.view.left).offset(30);
        make.top.equalTo(self.view.top).offset(40);
    }];
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view.centerX);
        make.left.equalTo(self.view.left).offset(30);
        make.top.equalTo(self.instructionsLabel.bottom).offset(20);
        make.bottom.equalTo(self.view.bottom).offset(-250);
    }];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissView:)];
    self.navigationItem.rightBarButtonItem = done;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor parchmentColor];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 40.0f;
    paragraphStyle.maximumLineHeight = 40.0f;
    paragraphStyle.minimumLineHeight = 10.0f;
    
    NSString *string = [[self.dataSource.userTags valueForKey:@"description"] componentsJoinedByString:@",   "];
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : [UIColor redInkColor],
                                 NSFontAttributeName : [UIFont fontWithName:@"Athelas-Regular" size:20],
                                 NSParagraphStyleAttributeName : paragraphStyle,
                                 };
    
    self.textView.attributedText = [[NSAttributedString alloc] initWithString:string attributes:attributes];
    
    self.instructionsLabel.font = [UIFont fontWithName:@"Athelas-Bold" size:20];
    self.instructionsLabel.numberOfLines = 0;
    self.instructionsLabel.textColor = [UIColor goldColor];
    self.instructionsLabel.text = @"Add tags to organize your Wine Collection:";
    [self.instructionsLabel sizeToFit];

}

- (void)dismissKeyboard
{
    [self.textView endEditing:YES];
}

- (void)dismissView:(id)sender
{
    self.dataSource.userTags = [[self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@","];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
