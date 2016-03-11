//
//  VSDetailViewController.m
//  VineSpectator
//
//  Created by PJ Loury on 11/23/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSDetailViewController.h"
#import "VSTableViewCell.h"
#import "VSSectionView.h"
#import "VSTableView.h"
#import "VSPromptLabel.h"
#import "VSEditBottleDelegate.h"
#import "VSEditBottleDataSource.h"
#import "VSTagCollectionViewCell.h"
#import "VSTagsDataSource.h"

#import "KTCenterFlowLayout.h"

@interface VSDetailViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, VSImageSelectionDelegate>

// Views
@property (nonatomic) VSTableView *tableView;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UITextView *descriptionTextView;

@property (nonatomic) UILabel *tagsPromptLabel;
@property (nonatomic) UICollectionView *tagsCollectionView;
@property (nonatomic) VSTagsDataSource *tagsDataSource;

@property (nonatomic) UILabel *ratingPromptLabel;
@property (nonatomic) UIView *ratingView;

@property (nonatomic) UIButton *drunkButton;
@property (nonatomic) UIButton *editButton;
@property (nonatomic) UIButton *doneButton;

// Edit Mode
@property VSEditBottleDataSource *editBottleDataSource;
@property VSEditBottleDelegate *editBottleDelegate;

// Models
@property VSBottleDataSource *bottleDataSource;
@property NSString *bottleID;

@property UITapGestureRecognizer *dismissKeyboardTapGesutreRecognizer;

// State
@property BOOL createMode;

@end

@implementation VSDetailViewController

- (instancetype)initWithBottleDataSource:(VSBottleDataSource *)bottleDataSource bottleID:(NSString *)bottleID
{
    self = [super init];
    if (self) {
        _bottleDataSource = bottleDataSource;
        _bottleID = bottleID;
        _tagsDataSource = [[VSTagsDataSource alloc] initWithBottleDataSource:bottleDataSource bottleID:bottleID];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    self.tableView = [[VSTableView alloc] initWithFrame:CGRectZero];
    self.tableView.canCancelContentTouches = YES;
    self.tableView.backgroundColor = [UIColor offWhiteColor];
    self.tableView.allowsSelection = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.doneButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.doneButton addTarget:self action:@selector(didPressDone:) forControlEvents:UIControlEventTouchUpInside];
    self.doneButton.titleLabel.font = [UIFont fontWithName:@"YuMin-Demibold" size:24.0];
    [self.doneButton setTitleColor:[UIColor pateColor] forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor highlightedPateColor] forState:UIControlStateHighlighted];
    self.doneButton.backgroundColor = [UIColor wineColor];
    [self.view addSubview:self.doneButton];
    
    [self setupUI];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.doneButton.mas_top);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)setupUI
{
    if (self.editMode) {
        // New bottle
        [self setupEditMode:nil];
        self.createMode = YES;
    }
    else {
        // Existing bottle
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    }
}

# pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tag = [self.tagsDataSource textForIndexPath:indexPath];
    [self.tagsDataSource addTag:tag];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tag = [self.tagsDataSource textForIndexPath:indexPath];
    [self.tagsDataSource removeTag:tag];
}

# pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [self.tagsDataSource textForIndexPath:indexPath];
    CGSize size = [text sizeWithAttributes:@{@"NSFontAttributeName": [UIFont fontWithName:@"YuMin-Medium" size:15.0]}];
    size.height += 10;
    size.width += 30;
    return size;
}

# pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSBottle *bottle = [self.bottleDataSource bottleForID:self.bottleID];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) { // bottle info
                case 0: // contains the image and description
                default: {
                    CGFloat height = 500;
                    if (!bottle.bottleDescription) {
                        height -=100;
                    }
                    return height;
                }
            }
        case 1:
            switch (indexPath.row) { // additional info
                case 0: // contains the image and description
                default:
                    return 120;
            }
        case 2:
        case 3:
        default:
            switch (indexPath.row) { // mark as drunk info
                case 0:
                default:
                    return 15.0;
              }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 70.0;
        case 1:
            return 40.0;
        case 2:
        case 3:
        default:
            return 50.0;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView;
    VSBottle *bottle = [self.bottleDataSource bottleForID:self.bottleID];
    
    switch (section) {
        case 0: {
            sectionView = [[VSSectionView alloc] initWithTableView:self.tableView title:@"" height:70.0];
            UILabel *vineyardLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            vineyardLabel.textColor = [UIColor redInkColor];
            vineyardLabel.font = [UIFont fontWithName:@"STKaiti-SC-Bold" size:23.0];
            vineyardLabel.text = bottle.vineyardName;
            [vineyardLabel sizeToFit];
            [sectionView addSubview:vineyardLabel];
            
            UILabel *grapeVarietyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            grapeVarietyLabel.text = bottle.grapeVarietyName;
            grapeVarietyLabel.textColor = [UIColor oliveInkColor];
            grapeVarietyLabel.font = [UIFont fontWithName:@"STKaiti-SC-Regular" size:20.0];
            [grapeVarietyLabel sizeToFit];
            grapeVarietyLabel.numberOfLines = 1;
            grapeVarietyLabel.adjustsFontSizeToFitWidth = YES;
            grapeVarietyLabel.minimumScaleFactor = 0.75;
            [grapeVarietyLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
            [sectionView addSubview:grapeVarietyLabel];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            nameLabel.text = bottle.name;
            nameLabel.textColor = [UIColor oliveInkColor];
            nameLabel.textAlignment = NSTextAlignmentRight;
            nameLabel.font = [UIFont fontWithName:@"STKaiti-SC-Regular" size:20.0];
            nameLabel.adjustsFontSizeToFitWidth = YES;
            nameLabel.minimumScaleFactor = 0.75;
            nameLabel.numberOfLines = 1;
            [nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
            //[nameLabel sizeToFit];
            [sectionView addSubview:nameLabel];
            
            UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            NSInteger year = bottle.year;
            if (year > 0)  yearLabel.text = @(bottle.year).stringValue;
            yearLabel.textAlignment = NSTextAlignmentRight;
            yearLabel.textColor = [UIColor oliveInkColor];
            yearLabel.font = [UIFont fontWithName:@"Avenir-Book" size:18.0];
            [yearLabel sizeToFit];
            [sectionView addSubview:yearLabel];
            
            [vineyardLabel mas_makeConstraints:^(MASConstraintMaker *make){
                    make.left.equalTo(sectionView).offset(10);
                    make.top.equalTo(sectionView).offset(8);
            }];
            
            [yearLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.right.equalTo(sectionView.right).offset(-20);
                if (vineyardLabel.text.length > 0) {
                    make.centerY.equalTo(vineyardLabel.centerY);
                } else {
                    make.top.equalTo(sectionView.top).offset(8);
                }
            }];
            
            [grapeVarietyLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(sectionView.left).offset(10);
                if (vineyardLabel.text.length > 0) {
                    make.top.equalTo(vineyardLabel.bottom).offset(-3);
                } else {
                    make.bottom.equalTo(sectionView.bottom).offset(-5);
                }
            }];
            
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.right.equalTo(sectionView.right).offset(-20);
                make.left.equalTo(grapeVarietyLabel.right).offset(10);
                if (vineyardLabel.text.length > 0) {
                    make.top.equalTo(vineyardLabel.bottom).offset(-3);
                } else {
                    make.bottom.equalTo(sectionView.bottom).offset(-5);
                }
            }];
            
            break;
        }
        case 1:
            sectionView = [[VSSectionView alloc] initWithTableView:self.tableView title:@"Additional" height:40.0];
            break;
        case 2: {
            sectionView = [[VSSectionView alloc] initWithTableView:self.tableView title:@"" height:50.0];
            UIButton *drunkButton = [[UIButton alloc] initWithFrame:sectionView.frame];
            [drunkButton setTitle:@"Mark as Drunk" forState:UIControlStateNormal];
            [drunkButton setTitle:@"Drank!" forState:UIControlStateSelected];
            drunkButton.titleLabel.font = [UIFont fontWithName:@"STKaiti-SC-Bold" size:24.0];
            drunkButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            [drunkButton setTitleColor:[UIColor redInkColor] forState:UIControlStateNormal];
            [drunkButton setTitleColor:[UIColor redInkColor] forState:UIControlStateSelected];
            [drunkButton setTitleColor:[UIColor highlightedRedInkColor] forState:UIControlStateHighlighted];
            [drunkButton addTarget:self action:@selector(didPressMarkAsDrunk:) forControlEvents:UIControlEventTouchUpInside];
            self.drunkButton = drunkButton;
            [sectionView addSubview:drunkButton];
            break;
        }
        case 3: {
            sectionView = [[VSSectionView alloc] initWithTableView:self.tableView title:@"" height:50.0];
            UIButton *editBottleButton = [[UIButton alloc] initWithFrame:sectionView.frame];
            [editBottleButton setTitle:@"Edit Bottle" forState:UIControlStateNormal];
            editBottleButton.titleLabel.font = [UIFont fontWithName:@"STKaiti-SC-Bold" size:24.0];
            editBottleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            [editBottleButton setTitleColor:[UIColor redInkColor] forState:UIControlStateNormal];
            [editBottleButton setTitleColor:[UIColor highlightedRedInkColor] forState:UIControlStateHighlighted];
            [editBottleButton addTarget:self action:@selector(didPressEditBottle:) forControlEvents:UIControlEventTouchUpInside];
            self.editButton = editBottleButton;
            [sectionView addSubview:editBottleButton];
            break;
        }
    }
    return sectionView;
}

# pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DetailCell";
    VSTableViewCell *cell = [[VSTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    VSBottle *bottle = [self.bottleDataSource bottleForID:self.bottleID];
    switch (indexPath.section) {
        case 0: {
            self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            self.imageView.userInteractionEnabled = YES;
            [cell addSubview:self.imageView];
            [self.imageView mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.equalTo(cell.top).offset(20);
                make.centerX.equalTo(cell.centerX);
                make.left.equalTo(cell.left).offset(10);
                make.height.equalTo(self.imageView.width);
            }];
            self.imageView.layer.borderColor = [UIColor brownInkColor].CGColor;
            self.imageView.layer.borderWidth = 5.0;
            if (bottle.image) {
                self.imageView.image = bottle.image;
            }
            else {
                UIButton *addPhotoButton = [[UIButton alloc] init];
                [addPhotoButton setTitle:@"Press to add a Photo" forState:UIControlStateNormal];
                addPhotoButton.titleLabel.font = [UIFont fontWithName:@"STKaiti-SC-Bold" size:20.0];
                [addPhotoButton setTitleColor:[UIColor brownInkColor] forState:UIControlStateNormal];
                addPhotoButton.backgroundColor = [UIColor warmTanColor];
                [self.imageView addSubview:addPhotoButton];
                [addPhotoButton addTarget:self action:@selector(imageButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
                [addPhotoButton mas_makeConstraints:^(MASConstraintMaker *make){
                    make.edges.equalTo(self.imageView);
                }];
            }
            
            self.descriptionTextView = [[UITextView alloc] initWithFrame:CGRectZero];
            self.descriptionTextView.text = @"Loren Ipsum dolor";
            self.descriptionTextView.font = [UIFont fontWithName:@"Baskerville" size:20.0];
            self.descriptionTextView.textColor = [UIColor oliveInkColor];
            [cell addSubview:self.descriptionTextView];
            [self.descriptionTextView mas_makeConstraints:^(MASConstraintMaker *make){
                if (bottle.hasImage) {
                    make.top.equalTo(self.imageView.top).offset(20);
                }
                else {
                    make.top.equalTo(cell.top).offset(30);
                }
                make.left.equalTo(cell.left).offset(30);
                make.centerX.equalTo(cell.centerX);
                [self.descriptionTextView sizeToFit];
            }];
            break;
        }
        case 1: {
            KTCenterFlowLayout *layout = [KTCenterFlowLayout new];
            layout.minimumInteritemSpacing = 10.f;
            layout.minimumLineSpacing = 10.f;
            
            VSPromptLabel *tagsLabel = [[VSPromptLabel alloc] initWithString:@"Tags"];
            [cell addSubview:tagsLabel];
            
            UIView *spacer1 = [[UIView alloc] initWithFrame:CGRectZero];
            UIView *spacer2 = [[UIView alloc] initWithFrame:CGRectZero];
            [cell addSubview:spacer1];
            [cell addSubview:spacer2];
            
            self.tagsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
            self.tagsCollectionView.allowsMultipleSelection = YES;
            self.tagsCollectionView.backgroundColor = [UIColor clearColor];
            self.tagsCollectionView.dataSource = self.tagsDataSource;

            self.tagsCollectionView.delegate = self;
            [self.tagsCollectionView registerClass:[VSTagCollectionViewCell class] forCellWithReuseIdentifier:@"TagCell"];
            [cell addSubview:self.tagsCollectionView];

            [spacer1 mas_makeConstraints:^(MASConstraintMaker *make){
                make.width.equalTo(@25);
                make.left.equalTo(tagsLabel.right);
                make.height.equalTo(cell.height);
                make.top.equalTo(cell.top);
            }];
            
            [spacer2 mas_makeConstraints:^(MASConstraintMaker *make){
                make.width.equalTo(spacer1);
                make.right.equalTo(cell.right);
                make.height.equalTo(cell.height);
                make.top.equalTo(cell.top);
            }];
            
            [tagsLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(cell.left).offset(15);
                make.top.equalTo(self.tagsCollectionView.top).offset(-5);
            }];
                        
            [self.tagsCollectionView mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(spacer1.right);
                make.right.equalTo(spacer2.left);
                make.top.equalTo(cell.top).offset(20);
                make.bottom.equalTo(cell.bottom).offset(-20);
            }];

            break;
        }
    }
    return cell;
}

# pragma mark - Tap Handlers

- (void)didPressDone:(id)sender
{
    if (self.editMode) { //pressed "save"
        [self.editBottleDataSource.tagsDataSource saveTags];
        self.editMode = NO;
        [self setupViewMode];
    }
    else {
        [self.tagsDataSource saveTags];
        if (self.createMode) {
            // Done Creating, slide down
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            // Done with Detail, slide right
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    // There's the initial save: it should say "Save", you should then press done to return
}

- (void)didPressEditBottle:(id)sender
{
    self.editMode = YES;
    [self.tagsDataSource saveTags];
    [self setupEditMode:sender];
}

- (void)setupViewMode
{
    NSString *grapeVariety = self.editBottleDataSource.grapeVariety;
    NSString *vineyard = self.editBottleDataSource.vineyard;
    NSString *year = self.editBottleDataSource.year;
    NSString *name = self.editBottleDataSource.name;
    UIImage *image = self.editBottleDataSource.image;
    
    //NSArray *tags = self.editBottleDataSource.tags;
    
    if (self.bottleID) {
        [self.bottleDataSource updateBottleWithBottleID:self.bottleID image:image name:name year:year
                                           grapeVariety:grapeVariety vineyard:vineyard];
    } else {
        self.bottleID = [self.bottleDataSource insertBottleWithImage:image name:name year:year
                                                        grapeVariety:grapeVariety vineyard:vineyard];
    }
    
    if (self.editBottleDelegate.tapRecognizer) {
        [self.tableView removeGestureRecognizer:self.editBottleDelegate.tapRecognizer];
    }
    if (self.dismissKeyboardTapGesutreRecognizer) {
        [self.tableView removeGestureRecognizer:self.dismissKeyboardTapGesutreRecognizer];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:YES];
    [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
}

- (void)setupEditMode:(id)sender
{
    self.editBottleDataSource = [[VSEditBottleDataSource alloc] initWithBottleDataSource:self.bottleDataSource bottleID:self.bottleID];
    self.editBottleDataSource.imageSelectionDelegate = self;
    
    self.editBottleDelegate = [[VSEditBottleDelegate alloc] initWithTableView:self.tableView bottleDataSource:self.bottleDataSource bottleID:self.bottleID];
    
    self.tableView.dataSource = self.editBottleDataSource;
    self.tableView.delegate = self.editBottleDelegate;
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:YES];
    
    self.dismissKeyboardTapGesutreRecognizer = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(dismissKeyboard)];
    [self.tableView addGestureRecognizer:self.dismissKeyboardTapGesutreRecognizer];
    [self.doneButton setTitle:@"Save" forState:UIControlStateNormal];
}

- (void)didPressMarkAsDrunk:(id)sender
{
    self.drunkButton.selected = !self.drunkButton.isSelected;
    VSBottle *bottle = [self.bottleDataSource bottleForID:self.bottleID];
    bottle.drank = self.drunkButton.isSelected;
    [bottle saveInBackground];
}


# pragma mark - VSImageSelectionDelegate

- (void)imageButtonWasPressed:(id)button
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Add a Photo"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self showImageSelectionFlowForType:UIImagePickerControllerSourceTypeCamera];
                                                          }];
    [alert addAction:defaultAction];
    alert.preferredAction = defaultAction;
    
    UIAlertAction* secondaryOption = [UIAlertAction actionWithTitle:@"Photos" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self showImageSelectionFlowForType:UIImagePickerControllerSourceTypePhotoLibrary];
                                                          }];
    [alert addAction:secondaryOption];
    
    UIAlertAction* cancelOption = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                            handler:^(UIAlertAction * action) {
                                                            }];
    [alert addAction:cancelOption];    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showImageSelectionFlowForType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    ipc.navigationBar.translucent = NO;

    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        ipc.sourceType = sourceType;
    }
    else {
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    }
    [self presentViewController:ipc animated:YES completion:nil];
}

# pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    UIImage *croppedImage = [self cropImage:chosenImage];
    
    NSString *grapeVariety = self.editBottleDataSource.grapeVariety;
    NSString *vineyard = self.editBottleDataSource.vineyard;
    NSString *year = self.editBottleDataSource.year;
    NSString *name = self.editBottleDataSource.name;
//    NSArray *tags = self.editBottleDataSource.tags;
    
    if (self.bottleID) {
        [self.bottleDataSource updateBottleWithBottleID:self.bottleID image:croppedImage name:name year:year
                                                                          grapeVariety:grapeVariety vineyard:vineyard ];
    } else {
        self.bottleID = [self.bottleDataSource insertBottleWithImage:croppedImage name:name year:year
                                                        grapeVariety:grapeVariety vineyard:vineyard];
        self.editBottleDataSource.bottleID = self.bottleID;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)cropImage:(UIImage *)original
{
    float originalWidth  = original.size.width; // 5
    float originalHeight = original.size.height; // 8
    
    float edge = fminf(originalWidth, originalHeight); // 5
    
    float posX = (originalWidth   - edge) / 2.0f; // ( 5 - 5 = 0
    float posY = (originalHeight  - edge) / 2.0f; // ( 8 - 5 = 3
    
    CGRect cropSquare;
    
    if(original.imageOrientation == UIImageOrientationLeft ||
       original.imageOrientation == UIImageOrientationRight) {
        cropSquare = CGRectMake(posY, posX,
                                edge, edge);
    }
    else {
        cropSquare = CGRectMake(posX, posY,
                                edge, edge);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([original CGImage], cropSquare);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef
                                                scale:original.scale
                                          orientation:original.imageOrientation];
    CGImageRelease(imageRef);
    return croppedImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UILabel *vineSpectator = [[UILabel alloc] initWithFrame:CGRectMake(0,0,250.0,CGRectGetHeight(self.navigationController.navigationBar.frame))];
    
    UIFont *vineFont = [UIFont fontWithName:@"Didot-Bold" size:24.0];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSDictionary *vineAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor pateColor], NSForegroundColorAttributeName,
                                    vineFont, NSFontAttributeName, paragraphStyle, NSParagraphStyleAttributeName,nil];
    NSMutableAttributedString *vineSpectatorString = [[NSMutableAttributedString alloc] initWithString:@"Vine " attributes:vineAttributes];
    
    
    UIFont *spectatorFont = [UIFont fontWithName:@"Athelas-Bold" size:24.0];
    NSDictionary *spectatorAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIColor goldColor], NSForegroundColorAttributeName,
                                         spectatorFont, NSFontAttributeName, nil];
    NSMutableAttributedString *spectatorString = [[NSMutableAttributedString alloc] initWithString:@"Spectator" attributes:spectatorAttributes];
    [vineSpectatorString appendAttributedString:spectatorString];
    
    vineSpectator.attributedText = vineSpectatorString;
    viewController.navigationItem.titleView = vineSpectator;
    navigationController.navigationBar.tintColor = [UIColor pateColor];
    
    viewController.view.backgroundColor = [UIColor offWhiteColor];
}

- (void)dismissKeyboard
{
    [self.tableView endEditing:YES];
}

@end
