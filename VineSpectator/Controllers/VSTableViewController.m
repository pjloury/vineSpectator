//
//  VSTableViewController.m
//  VineSpectator
//
//  Created by PJ Loury on 11/22/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSTableViewController.h"
#import "VSAddBottleViewController.h"
#import "VSBottleDataSource.h"
#import "Masonry.h"

@interface VSTableViewController () <UITableViewDelegate>

// save VSShortcutViewController for last!
@property VSAddBottleViewController *detailViewController;
@property UINavigationController *detailNavigationController;

@property UIButton *addBottleButton;
@property VSBottleDataSource *bottleDataSource;
@property UIStackView *stackView;
@property UITableView *tableView;

@end

@implementation VSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.bottleDataSource = [[VSBottleDataSource alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.bottleDataSource;
    
    self.addBottleButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.addBottleButton addTarget:self action:@selector(didPressNewBottle:) forControlEvents:UIControlEventTouchUpInside];
    [self.addBottleButton setTitle:@"New Bottle" forState:UIControlStateNormal];
    self.addBottleButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.addBottleButton];

    self.navigationController.title = @"Vine Spectator";
//    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
//    UIBarButtonItem *addBottle = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didPressAddBottle:)];
//    self.navigationItem.rightBarButtonItem = addBottle;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.addBottleButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.addBottleButton.mas_top);
    }];
    
    NSString *filter = @"None"; // filterFor...
    
    [self.bottleDataSource fetchBottlesWithCompletion:^{
        [self.tableView reloadData];
    }];
    
    [self.bottleDataSource generateDataModelForFilter:filter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didPressNewBottle:(id)sender
{
//    [self.bottleDataSource addBottle];
//    [self.tableView reloadData];
    
    self.detailViewController = [[VSAddBottleViewController alloc] initWithBottleDataSource:self.bottleDataSource bottleID:nil];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.detailViewController];
    self.detailNavigationController = nc;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
    ipc.delegate = self.detailViewController;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:nc animated:NO completion:nil];
    [self presentViewController:ipc animated:YES completion:nil];
}

# pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell =[self.bottleDataSource tableView:self.tableView cellForRowAtIndexPath:indexPath];
//    [cell layoutIfNeeded];
//    return cell.frame.size.height;
    //NSString *bottleID = [self.bottleDataSource bottleIDForRowAtIndexPath:indexPath];
    
    NSString *bottleID = [self.bottleDataSource bottleIDForRowAtIndexPath:indexPath];
    VSBottle *bottle = [self.bottleDataSource bottleForID:bottleID];
    if (!bottle.hasImage) {
        return 90.0f;
    }
    else {
        return 285.0f;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Drank!";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *bottleID = [self.bottleDataSource bottleIDForRowAtIndexPath:indexPath];
    VSAddBottleViewController *vc = [[VSAddBottleViewController alloc]                                          initWithBottleDataSource:self.bottleDataSource bottleID:bottleID];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
