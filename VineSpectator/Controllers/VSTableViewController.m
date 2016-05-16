//
//  VSTableViewController.m
//  VineSpectator
//
//  Created by PJ Loury on 11/22/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSTableViewController.h"
#import "VSDetailViewController.h"
#import "VSFilterStackViewController.h"
#import "VSTagsViewController.h"
#import "VSBottleDataSource.h"
#import "AppDelegate.h"

@interface VSTableViewController () <UITableViewDelegate, VSFilterSelectionDelegate, UIScrollViewDelegate>

// save VSShortcutViewController for last!
// Might not need a stack view controller!

@property VSDetailViewController *detailViewController;
@property UINavigationController *detailNavigationController;

@property UIButton *addBottleButton;
@property VSBottleDataSource *bottleDataSource;
@property UILabel *errorMessageLabel;
@property UILabel *emptyMessageLabel;
@property UIActivityIndicatorView *activityIndicator;

@property UITableView *tableView;
@property VSFilterStackViewController *filterViewController;

@end

@implementation VSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor offWhiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    self.tableView.bounces = YES;
    [self.view addSubview:self.tableView];
    
    self.bottleDataSource = [[VSBottleDataSource alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.bottleDataSource;
    
    self.filterViewController = [[VSFilterStackViewController alloc] init];
    self.filterViewController.delegate = self;
    [self addChildViewController:self.filterViewController];
    
    self.addBottleButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.addBottleButton addTarget:self action:@selector(didPressNewBottle:) forControlEvents:UIControlEventTouchUpInside];
    [self.addBottleButton setTitle:@"New Bottle" forState:UIControlStateNormal];
    self.addBottleButton.titleLabel.font = [UIFont fontWithName:@"MinionPro-Bold" size:24.0];
    [self.addBottleButton setTitleColor:[UIColor pateColor] forState:UIControlStateNormal];
    [self.addBottleButton setTitleColor:[UIColor highlightedPateColor] forState:UIControlStateHighlighted];
    self.addBottleButton.backgroundColor = [UIColor wineColor];
    [self.view addSubview:self.addBottleButton];
    [self.view addSubview:self.filterViewController.view];

    self.view.backgroundColor = [UIColor parchmentColor];
    
    self.errorMessageLabel = [UILabel new];
    self.errorMessageLabel.backgroundColor = [UIColor clearColor];
    self.errorMessageLabel.textColor = [UIColor goldColor];
    self.errorMessageLabel.font = [UIFont fontWithName:@"Athelas-Regular" size:20];
    [self.view addSubview:self.errorMessageLabel];
    self.errorMessageLabel.hidden = YES;
    self.errorMessageLabel.text = @"No results found.";
    [self.errorMessageLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view.left).offset(20);
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(self.filterViewController.view.bottom).offset(20);
        make.height.equalTo(@25);
    }];
    
    self.emptyMessageLabel = [UILabel new];
    self.emptyMessageLabel.backgroundColor = [UIColor clearColor];
    self.emptyMessageLabel.textColor = [UIColor goldColor];
    self.emptyMessageLabel.font = [UIFont fontWithName:@"Athelas-Regular" size:20];
    [self.view addSubview:self.emptyMessageLabel];
    self.emptyMessageLabel.hidden = YES;
    self.emptyMessageLabel.text = @"Tap below to get started.";
    [self.emptyMessageLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view.left).offset(20);
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(self.filterViewController.view.bottom).offset(20);
        make.height.equalTo(@25);
    }];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.hidden = YES;
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(self.view);
    }];
    
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(didPressActionButton:)];
    actionButton.tintColor = [UIColor pateColor];
    self.navigationItem.rightBarButtonItem = actionButton;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0,25,25)];
    [button setTintColor:[UIColor pateColor]];
    [button addTarget:self action:@selector(didPressLogoutButton:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageNamed:@"logout"];
    [button setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = logoutButton;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapNavBar)];
    [self.navigationItem.titleView addGestureRecognizer:tapRecognizer];
    
    [self.filterViewController.view mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [self.addBottleButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.filterViewController.view.bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.addBottleButton.mas_top);
    }];
    
    self.tableView.hidden = YES;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasBottles"] isEqual: @(YES)]) {
        self.emptyMessageLabel.hidden = YES;
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
    } else {
        self.emptyMessageLabel.hidden = NO;
        self.activityIndicator.hidden = YES;
        [self.activityIndicator stopAnimating];
    }
    
    [self.bottleDataSource fetchBottlesForUser:[PFUser currentUser] withCompletion:^{
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasBottles"] isEqual: @(YES)]) {
           self.emptyMessageLabel.hidden = YES;
           self.activityIndicator.hidden = YES;
           [self.activityIndicator stopAnimating];
           self.tableView.hidden = NO;
           [self.tableView reloadData];
        } else {
            self.emptyMessageLabel.hidden = NO;
            self.activityIndicator.hidden = YES;
            [self.activityIndicator stopAnimating];
            self.tableView.hidden = YES;
        }
    }];
}

- (void)titleViewTapped
{
    NSLog(@"WOW");
}

- (void)didTapNavBar
{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.bottleDataSource regenerateDataModel];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasBottles"] isEqual: @(YES)]) {
        self.emptyMessageLabel.hidden = YES;
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    } else {
        self.emptyMessageLabel.hidden = NO;
        self.tableView.hidden = YES;
    }
}

- (void)didPressActionButton:(id)sender
{
    NSString *highScore = @"Mange your wine collection from your phone- download Vine Spectator to get started!";
    NSString *urlString = [[PFConfig currentConfig] objectForKey:@"appURL"];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:highScore];
    if (url) [items addObject:url];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    NSArray *excludedActivities = @[
                                    UIActivityTypePostToWeibo,
                                    UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    controller.excludedActivityTypes = excludedActivities;
    [self presentViewController:controller animated:YES completion:nil];
}

// Use sidways share button
- (void)didPressLogoutButton:(id)sender
{
    UIAlertAction *act = [UIAlertAction actionWithTitle:@"Log out" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        [self logOut];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Nevermind" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}];
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Log out?" message:@"Are you sure? We'll miss you!" preferredStyle:UIAlertControllerStyleActionSheet];
    [ac addAction:act];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)didPressNewBottle:(id)sender
{
    self.detailViewController = [[VSDetailViewController alloc] initWithBottleDataSource:self.bottleDataSource bottleID:nil];
    self.detailViewController.editMode = YES;
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.detailViewController];
    self.detailNavigationController = nc;
    
    [self presentViewController:nc animated:YES completion:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<=0) {
        scrollView.contentOffset = CGPointZero;
    }
}

- (void)logOut
{
    [PFUser logOut];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate showLoginViewController];
// pop to some sort of login View Controller    [self ]
}

# pragma VSFilterSelectionDelegate
- (void)didPressViewAllTags:(id)sender
{
    VSTagsViewController *tagsVC = [[VSTagsViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:tagsVC];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)filterStackViewController:(VSFilterStackViewController *)viewController didSelectFilter:(VSFilterType)type
{
    [self.bottleDataSource generateDataModelForFilterType:type tag:nil dirty:YES];
    self.errorMessageLabel.hidden = YES;
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

- (void)filterStackViewController:(VSFilterStackViewController *)viewController didSelectTag:(NSString *)tag
{
    [self.bottleDataSource generateDataModelForFilterType:VSFilterTypeTag tag:tag dirty:YES];
    self.errorMessageLabel.hidden = YES;
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

- (void)filterStackViewController:(VSFilterStackViewController *)viewController didDeselectTag:(NSString *)tag
{
    [self.bottleDataSource generateDataModelForFilterType:VSFilterTypeAll tag:nil dirty:YES];
    self.errorMessageLabel.hidden = YES;
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

- (void)filterStackViewController:(VSFilterStackViewController *) viewController didReceiveSearchText:(NSString *)text
{
    BOOL reload = [self.bottleDataSource generateDataModelForFilterType:VSFilterTypeSearch tag:text dirty:YES];
    if (reload) {
        self.errorMessageLabel.hidden = YES;
        self.activityIndicator.hidden = NO;
        [self.activityIndicator stopAnimating];
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    } else {
        self.errorMessageLabel.hidden = NO;
        self.tableView.hidden = YES;
    }
}

# pragma mark UITableViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.filterViewController.stackView.searchField resignFirstResponder];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width-70, 20)];
    view.backgroundColor = [UIColor parchmentColor];
    label.font = [UIFont fontWithName:@"Athelas-Regular" size:18];
    label.textColor = [UIColor oliveInkColor];
    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width-70, 5, 70, 20)];
    numberLabel.font = [UIFont systemFontOfSize:14.0];
    numberLabel.textColor = [UIColor oliveInkColor];
    numberLabel.text = [self.bottleDataSource numberTextForSection:section];
    numberLabel.textAlignment = NSTextAlignmentRight;

     NSString *string = [self.tableView.dataSource tableView:self.tableView titleForHeaderInSection:section];
    [label setText:string];
    [label sizeToFit];
    [view addSubview:label];
    [view addSubview:numberLabel];
    
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.centerY);
        make.left.equalTo(label.right).offset(5);
    }];
    
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
    if (bottle) {
        if (!self.bottleDataSource.showImages) {
            return 80.0;
        }
        else {
            return bottle.hasImage ? 385.0 : 80.0;
        }
    } else {
        return self.tableView.frame.size.height;
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

@end
