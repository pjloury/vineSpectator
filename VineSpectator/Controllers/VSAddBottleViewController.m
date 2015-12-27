//
//  VSAddBottleViewController.m
//  VineSpectator
//
//  Created by PJ Loury on 11/22/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSAddBottleViewController.h"
#import "VSBottleDataSource.h"
#import "VSAddBottleView.h"
#import "Masonry.h"
#import <Parse/Parse.h>
#import "TRAutocompleteView.h"
#import "VSGrapeVarietyDataSource.h"

@interface VSAddBottleViewController ()<VSImageButtonSelectionDelegate>

@property VSAddBottleView *addBottleView;
@property UIButton *addBottleButton;
@property VSBottleDataSource *bottleDataSource;
@property NSString *bottleID;

@end

@implementation VSAddBottleViewController

- (instancetype)initWithBottleDataSource:(VSBottleDataSource *)bottleSource bottleID:(NSString *)bottleID;
{
    self = [super init];
    if (self) {
        _bottleDataSource = bottleSource;
        _bottleID = bottleID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.addBottleView = [[VSAddBottleView alloc] initWithFrame:self.view.frame];
    self.addBottleView.delegate = self;
    self.addBottleView.grapeVarietyTextField.autocompleteDataSource = [VSGrapeVarietyDataSource sharedInstance];
    
//    self.addBottleView.autocompleteView = [TRAutocompleteView autocompleteViewBindedTo:_textField
//                                                                           usingSource:
//                                                                           cellFactory:
//                                                                          presentingIn:self];
    
    [self.view addSubview:self.addBottleView];
    
    self.addBottleButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.addBottleButton addTarget:self action:@selector(didPressAddBottle:) forControlEvents:UIControlEventTouchUpInside];
    [self.addBottleButton setTitle:@"Add Bottle!" forState:UIControlStateNormal];
    self.addBottleButton.backgroundColor = [UIColor wineColor];
    [self.view addSubview:self.addBottleButton];
    
    if (self.bottleID) {
        self.addBottleButton.hidden = YES;
        
        self.navigationItem.hidesBackButton = NO;
        UIBarButtonItem *editBottle = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(didPressEdit:)];
        self.navigationItem.rightBarButtonItem = editBottle;
        
        [self configureBottleViewWithID:self.bottleID];
        self.addBottleView.editMode = NO;
    }
    else {
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,50,150)];
        cancelButton.titleLabel.font = [UIFont fontWithName:@"STKaiti-SC-Bold" size:16.0];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor pateColor] forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor highlightedPateColor] forState:UIControlStateHighlighted];
        [cancelButton addTarget:self action:@selector(didPressCancel:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *cancelBottle = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
        self.navigationItem.leftBarButtonItem = cancelBottle;
        
        self.addBottleView.editMode = YES;
        [self.addBottleView setImage:[UIImage imageNamed:@"add-photo"]];
        self.addBottleView.yearTextField.placeholder = @"Year";
        self.addBottleView.nameTextField.placeholder = @"Name";
        self.addBottleView.grapeVarietyTextField.placeholder = @"Variety";
        self.addBottleView.vineyardTextField.placeholder = @"vineyard";
//
//        self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
//        UIBarButtonItem *saveBottle = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(didPressSave:)];
//        self.navigationItem.rightBarButtonItem = saveBottle;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.addBottleButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [self.addBottleView mas_makeConstraints:^(MASConstraintMaker *make){
        //make.top.equalTo(self.navigationController.navigationBar.mas_bottom);
        make.top.equalTo(@(self.topLayoutGuide.length));
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.addBottleButton.mas_top);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{

}

- (void)configureBottleViewWithID:(NSString *)bottleID
{
    NSLog(@"BOTTLE ID: %@", bottleID);
    VSBottle *bottle = [self.bottleDataSource bottleForID:bottleID];
    if (!bottle.hasImage) {
        [self.addBottleView setImage:[UIImage imageNamed:@"add-photo"]];
    }
    else {
        [self.addBottleView setImage:bottle.image];
    }
    self.addBottleView.yearTextField.text = [NSString stringWithFormat:@"%ld",bottle.year];
    //self.addBottleView.nameTextField.text = bottle.name;
    self.addBottleView.grapeVarietyTextField.text = bottle.grapeVarietyName;
    self.addBottleView.vineyardTextField.text = bottle.vineyardName;
}

- (void)didPressAddBottle:(id)sender
{
    [self _saveData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didPressSave:(id)sender
{
    [self.addBottleView dismissKeyboard];
    [self _saveData];
}

- (void)_saveData
{
    UIImage *image = [self.addBottleView.imageButton imageForState:UIControlStateNormal];
    NSString *name = self.addBottleView.nameTextField.text;
    NSString *year = self.addBottleView.yearTextField.text;
    NSString *grapeVariety = self.addBottleView.grapeVarietyTextField.text;
    NSString *vineyard = self.addBottleView.vineyardTextField.text;
    if ([image isEqual:[UIImage imageNamed:@"add-photo"]]) image = nil;
    
    if (self.bottleID) {
        [self.bottleDataSource updateBottleWithBottleID:self.bottleID image:image name:name year:year
                                           grapeVariety:grapeVariety vineyard:vineyard tags:nil];
    }
    else {
        [self.bottleDataSource insertBottleWithImage:image name:name
                                                year:year grapeVariety:grapeVariety vineyard:vineyard tags:nil];
    }
}

- (void)didPressEdit:(id)sender
{
    [self.addBottleView setEditMode:YES];
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    UIBarButtonItem *saveBottle = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(didPressSave:)];
    [self.navigationItem setRightBarButtonItem:saveBottle animated:YES];
    
    // now show the save button instead!
}

- (void)didPressCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma market VSImageButtonSelectionDelegate
- (void)shouldPresentImage:(UIButton *)button
{
    // present image fullscreen
}

- (void)shouldEditImage:(UIButton *)button
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
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
    
    [self.addBottleView setImage:croppedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [self _saveData];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
