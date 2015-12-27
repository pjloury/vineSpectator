//
//  VSTableViewController.m
//  VineSpectator
//
//  Created by PJ Loury on 11/22/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSTableViewController.h"
#import "VSDetailViewController.h"
#import "VSBottleDataSource.h"

#import "VSStackViewDelegate.h"
#import "VSStackViewDataSource.h"

#import "Masonry.h"

@interface VSTableViewController () <UITableViewDelegate, VSFilterSelectionDelegate>

// save VSShortcutViewController for last!

// Might not need a stack view controller!

@property VSDetailViewController *detailViewController;
@property UINavigationController *detailNavigationController;

@property UIButton *addBottleButton;
@property VSBottleDataSource *bottleDataSource;
@property UIView *stackView;
@property UITableView *tableView;

@property VSStackViewDelegate *stackViewDelegate;
@property VSStackViewDataSource *stackViewDataSource;

@end

@implementation VSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor offWhiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.bottleDataSource = [[VSBottleDataSource alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.bottleDataSource;
    
    self.addBottleButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.addBottleButton addTarget:self action:@selector(didPressNewBottle:) forControlEvents:UIControlEventTouchUpInside];
    [self.addBottleButton setTitle:@"New Bottle" forState:UIControlStateNormal];
    self.addBottleButton.titleLabel.font = [UIFont fontWithName:@"YuMin-Demibold" size:24.0];
    [self.addBottleButton setTitleColor:[UIColor pateColor] forState:UIControlStateNormal];
    [self.addBottleButton setTitleColor:[UIColor highlightedPateColor] forState:UIControlStateHighlighted];
    self.addBottleButton.backgroundColor = [UIColor wineColor];
    [self.view addSubview:self.addBottleButton];
    
    [self.addBottleButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.addBottleButton.mas_top);
    }];
    
    [self.bottleDataSource fetchBottlesWithCompletion:^{
        //[self.bottleDataSource generateDataModelForFilter:@"Unopened" dirty:NO];
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.bottleDataSource generateDataModelForFilter:@"Unopened" dirty:YES];
    [self.tableView reloadData]; // get the edits made in the detail VC
}

//- (void)didPressNewBottle:(id)sender
//{
//    self.detailViewController = [[VSDetailViewController alloc] initWithBottleDataSource:self.bottleDataSource bottleID:nil];
//    self.detailViewController.editMode = YES;
//    //self.detailViewController = [[VSAddBottleViewController alloc] initWithBottleDataSource:self.bottleDataSource bottleID:nil];
//    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.detailViewController];
//    self.detailNavigationController = nc;
//    nc.navigationBar.translucent = NO;
//    
//    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
//    ipc.navigationBar.translucent = NO;
//    
//    ipc.delegate = self.detailViewController;
//    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
//        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
//    }
//    else {
//        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    }
//
//    [self presentViewController:nc animated:NO completion:nil];
//    [nc presentViewController:ipc animated:YES completion:nil];
//}

- (void)didPressNewBottle:(id)sender
{
    self.detailViewController = [[VSDetailViewController alloc] initWithBottleDataSource:self.bottleDataSource bottleID:nil];
    self.detailViewController.editMode = YES;
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.detailViewController];
    self.detailNavigationController = nc;
    
    [self presentViewController:nc animated:YES completion:nil];
}

# pragma mark UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 20)];
    view.backgroundColor = [UIColor parchmentColor];
    label.font = [UIFont fontWithName:@"Athelas-Regular" size:18];
    label.textColor = [UIColor oliveInkColor];
    
    NSString *string = [self.tableView.dataSource tableView:self.tableView titleForHeaderInSection:section];
    [label setText:string];
    [view addSubview:label];
    
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = [[UIColor borderGreyColor] CGColor];
    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), 1.0f);
    [view.layer addSublayer:upperBorder];
    
    CALayer *lowerBorder = [CALayer layer];
    lowerBorder.backgroundColor = [[UIColor borderGreyColor] CGColor];
    lowerBorder.frame = CGRectMake(0, CGRectGetHeight(view.frame)-2, CGRectGetWidth(view.frame), 1.0f);
    [view.layer addSublayer:lowerBorder];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *bottleID = [self.bottleDataSource bottleIDForRowAtIndexPath:indexPath];
    VSBottle *bottle = [self.bottleDataSource bottleForID:bottleID];
    
    if (!bottle.hasImage) {
        return 80.0f;
    }
    else {
        return 385.0f;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *bottleID = [self.bottleDataSource bottleIDForRowAtIndexPath:indexPath];
    VSDetailViewController *vc = [[VSDetailViewController alloc] initWithBottleDataSource:self.bottleDataSource bottleID:bottleID];
    [self.navigationController pushViewController:vc animated:YES];
}

# pragma mark - VSFilterSelectionDelegate

- (void)stackViewDelegate:(VSStackViewDelegate *)delegate didSelectFilter:(NSString *)filter
{
    [self.bottleDataSource generateDataModelForFilter:filter dirty:YES];
    [self.tableView reloadData];
}

@end
