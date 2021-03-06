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

@property UIBarButtonItem *logoutButton;

@property UILabel *totalBottlesLabel;
@property UIButton *addBottleButton;
@property VSBottleDataSource *bottleDataSource;
@property UILabel *errorMessageLabel;
@property UIActivityIndicatorView *activityIndicator;

@property UITableView *tableView;
@property VSFilterStackViewController *filterViewController;
@property BOOL firstLoad;

@end

@implementation VSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor offWhiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.scrollsToTop = YES;
    self.tableView.bounces = YES;
    [self.view addSubview:self.tableView];
    
    self.firstLoad = YES;
    
    self.bottleDataSource = [[VSBottleDataSource alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.bottleDataSource;
    [self.tableView setRowHeight:80];
    
    self.filterViewController = [[VSFilterStackViewController alloc] init];
    self.filterViewController.delegate = self;
    [self addChildViewController:self.filterViewController];
    
    self.totalBottlesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,40)];
    self.totalBottlesLabel.backgroundColor = [UIColor lightSalmonColor];
    self.totalBottlesLabel.textAlignment = NSTextAlignmentCenter;
    self.totalBottlesLabel.font = [UIFont systemFontOfSize:16.0];
    self.totalBottlesLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14.0];
    
    self.totalBottlesLabel.textColor = [UIColor oliveInkColor];
    [self.view addSubview:self.totalBottlesLabel];
    
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = [[UIColor borderGreyColor] CGColor];
    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 1.0f);
    [self.totalBottlesLabel.layer addSublayer:upperBorder];

    CALayer *lowerBorder = [CALayer layer];
    lowerBorder.backgroundColor = [[UIColor borderGreyColor] CGColor];
    lowerBorder.frame = CGRectMake(0, CGRectGetHeight(self.totalBottlesLabel.frame)-2, CGRectGetWidth(self.totalBottlesLabel.frame), 1.0f);
    [self.totalBottlesLabel.layer addSublayer:lowerBorder];
    
    self.addBottleButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.addBottleButton addTarget:self action:@selector(didPressNewBottle:) forControlEvents:UIControlEventTouchUpInside];
    [self.addBottleButton setTitle:@"New Bottle" forState:UIControlStateNormal];
    self.addBottleButton.titleLabel.font = [UIFont fontWithName:@"MinionPro-Bold" size:24.0];
    [self.addBottleButton setTitleColor:[UIColor pateColor] forState:UIControlStateNormal];
    [self.addBottleButton setTitleColor:[UIColor highlightedPateColor] forState:UIControlStateHighlighted];
    self.addBottleButton.backgroundColor = [UIColor wineColor];
    [self.view addSubview:self.addBottleButton];
    [self.view addSubview:self.filterViewController.view];

    [self.totalBottlesLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.addBottleButton.top);
        make.height.equalTo(31);
    }];
    
    [self.addBottleButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(52);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.filterViewController.view.bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.totalBottlesLabel.top);
    }];
    
    self.view.backgroundColor = [UIColor offWhiteColor];
    
    self.errorMessageLabel = [UILabel new];
    self.errorMessageLabel.backgroundColor = [UIColor clearColor];
    self.errorMessageLabel.textColor = [UIColor goldColor];
    self.errorMessageLabel.font = [UIFont fontWithName:@"Athelas-Regular" size:20];
    self.errorMessageLabel.numberOfLines = 2;
    [self.view addSubview:self.errorMessageLabel];
    self.errorMessageLabel.hidden = YES;
    [self.errorMessageLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view.left).offset(20);
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(self.filterViewController.view.bottom).offset(20);
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
    self.logoutButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = self.logoutButton;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapNavBar)];
    [self.navigationItem.titleView addGestureRecognizer:tapRecognizer];
    
    [self.filterViewController.view mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    self.tableView.hidden = YES;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasBottles"] isEqual: @(YES)]) {
        self.errorMessageLabel.hidden = YES;
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
    } else {
        self.errorMessageLabel.hidden = NO;
        self.errorMessageLabel.text = @"Tap below to add a bottle.";
        self.activityIndicator.hidden = YES;
        [self.activityIndicator stopAnimating];
    }
    
    [self.bottleDataSource fetchBottlesForUser:[PFUser currentUser] withCompletion:^{
        self.firstLoad = NO;
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasBottles"] isEqual: @(YES)]) {
           self.errorMessageLabel.hidden = YES;
           self.activityIndicator.hidden = YES;
           [self.activityIndicator stopAnimating];
           self.tableView.hidden = NO;
           [self.tableView reloadData];
           [self reloadFooter];
        } else {
            self.errorMessageLabel.hidden = NO;
            self.errorMessageLabel.text = @"Tap below to add a bottle.";
            self.activityIndicator.hidden = YES;
            [self.activityIndicator stopAnimating];
            self.tableView.hidden = YES;
            self.totalBottlesLabel.text = @"";
        }
    }];
}

- (void)reloadFooter {
    if ([self.bottleDataSource currentNumberOfBottles] > 1) {
        self.totalBottlesLabel.text = [NSString stringWithFormat:@"%d bottles",[self.bottleDataSource currentNumberOfBottles]];
    }
    else if ([self.bottleDataSource currentNumberOfBottles]  == 1)
        self.totalBottlesLabel.text = [NSString stringWithFormat:@"%d bottle",[self.bottleDataSource currentNumberOfBottles]];
    else {
        self.totalBottlesLabel.text = @"";
    }
}

- (void)didTapNavBar
{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    BOOL withBottles = [self.bottleDataSource regenerateDataModel];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasBottles"] isEqual: @(YES)]) {
        self.tableView.hidden = NO;
        if (!withBottles && !self.firstLoad) {
            self.errorMessageLabel.hidden = NO;
            self.errorMessageLabel.text = @"No bottles found.";
        }
        else {
            self.errorMessageLabel.hidden = YES;
        }
        [self.tableView reloadData];
        [self reloadFooter];
    } else if (!self.firstLoad){
        self.errorMessageLabel.hidden = NO;
        self.errorMessageLabel.text = @"No bottles found.";
        self.tableView.hidden = YES;
        self.totalBottlesLabel.text = @"";
    }
}

- (void)didPressActionButton:(UIBarButtonItem *)sender
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
    if ( [controller respondsToSelector:@selector(popoverPresentationController)] ) {
        controller.popoverPresentationController.barButtonItem = sender;
    }
    [self presentViewController:controller animated:YES completion:nil];
}

// Use sidways share button
- (void)didPressLogoutButton:(UIButton *)sender
{
    UIAlertAction *act = [UIAlertAction actionWithTitle:@"Log out" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        [self logOut];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Nevermind" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}];
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Log out?" message:@"Are you sure? We'll miss you!" preferredStyle:UIAlertControllerStyleActionSheet];
    [ac addAction:act];
    [ac addAction:cancel];
    if ( [ac respondsToSelector:@selector(popoverPresentationController)] ) {
        ac.popoverPresentationController.barButtonItem = self.logoutButton;
    }
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)didPressNewBottle:(id)sender
{
    if([[VSReachability reachabilityForInternetConnection] isReachable]) {
        self.detailViewController = [[VSDetailViewController alloc] initWithBottleDataSource:self.bottleDataSource bottleID:nil];
        self.detailViewController.editMode = YES;
        
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.detailViewController];
        self.detailNavigationController = nc;
        
        [self presentViewController:nc animated:YES completion:nil];
    } else {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"No Internet access"
                                              message:@"Find reception to add a bottle"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
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

- (void)filterStackViewController:(VSFilterStackViewController *)viewController didSelectTag:(NSString *)tag
{
    BOOL containsValues = [self.bottleDataSource generateDataModelForFilterType:VSFilterTypeTag tag:tag dirty:YES];
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
    self.tableView.hidden = NO;
    
    if (containsValues) {
        self.errorMessageLabel.hidden = YES;
        self.activityIndicator.hidden = NO;
        [self.activityIndicator stopAnimating];
        self.tableView.hidden = NO;
    } else {
        self.errorMessageLabel.hidden = NO;
        self.errorMessageLabel.text = self.bottleDataSource.shouldShowEmptyMessageForState? @"Tap below to add a bottle." : @"No bottles found.";
        self.tableView.hidden = YES;
    }
    [self.tableView reloadData];
    [self reloadFooter];
}

- (void)filterStackViewController:(VSFilterStackViewController *)viewController didSelectFilter:(VSFilterType)type
{
    BOOL containsValues = [self.bottleDataSource generateDataModelForFilterType:type tag:nil dirty:YES];
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
    if (containsValues) {
        self.errorMessageLabel.hidden = YES;
        self.activityIndicator.hidden = NO;
        [self.activityIndicator stopAnimating];
        self.tableView.hidden = NO;
    } else {
        self.errorMessageLabel.hidden = NO;
        self.errorMessageLabel.text = self.bottleDataSource.shouldShowEmptyMessageForState? @"Tap below to add a bottle." : @"No bottles found.";
        self.tableView.hidden = YES;
    }
    [self.tableView reloadData];
    [self reloadFooter];
}

- (void)filterStackViewController:(VSFilterStackViewController *)viewController didDeselectTag:(NSString *)tag
{
    BOOL containsValues = [self.bottleDataSource generateDataModelForFilterType:VSFilterTypeAll tag:nil dirty:YES];
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
    if (containsValues) {
        self.errorMessageLabel.hidden = YES;
        self.activityIndicator.hidden = NO;
        [self.activityIndicator stopAnimating];
        self.tableView.hidden = NO;
    } else {
        self.errorMessageLabel.hidden = NO;
        self.errorMessageLabel.text = self.bottleDataSource.shouldShowEmptyMessageForState? @"Tap below to add a bottle." : @"No bottles found.";
        self.tableView.hidden = YES;
    }
    [self.tableView reloadData];
    [self reloadFooter];
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
        [self reloadFooter];
    } else {
        self.errorMessageLabel.hidden = NO;
        self.errorMessageLabel.text = @"No bottles found.";
        self.tableView.hidden = YES;
        self.totalBottlesLabel.text = @"";
    }
}

# pragma mark UITableViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.filterViewController.stackView.searchField resignFirstResponder];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 35)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor parchmentColor];
    label.font = [UIFont fontWithName:@"Athelas-Regular" size:18];
    label.textColor = [UIColor oliveInkColor];
    

    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width-70, 8, 70, 20)];
    numberLabel.font = [UIFont systemFontOfSize:14.0];
    numberLabel.textColor = [UIColor oliveInkColor];
    numberLabel.text = [self.bottleDataSource numberTextForSection:section];
    numberLabel.textAlignment = NSTextAlignmentRight;

     NSString *string = [self.tableView.dataSource tableView:self.tableView titleForHeaderInSection:section];
    [label setText:string];
    [label sizeToFit];
    [view addSubview:label];
    [view addSubview:numberLabel];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.left.equalTo(view.left).offset(10);
    }];
    
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
    lowerBorder.frame = CGRectMake(0, CGRectGetHeight(view.frame)-1, CGRectGetWidth(view.frame), 1.0f);
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

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *bottleID = [self.bottleDataSource bottleIDForRowAtIndexPath:indexPath];
    VSDetailViewController *vc = [[VSDetailViewController alloc] initWithBottleDataSource:self.bottleDataSource bottleID:bottleID];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
