//
//  VSAddBottleView.h
//  VineSpectator
//
//  Created by PJ Loury on 11/22/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTAutocompleteTextField.h"

@protocol VSImageButtonSelectionDelegate

@required
- (void)shouldPresentImage:(UIButton *)button;
- (void)shouldEditImage:(UIButton *)button;

@end

@interface VSAddBottleView : UIScrollView

@property (weak) id<VSImageButtonSelectionDelegate> delegate;

@property (nonatomic) UIButton *imageButton;
@property (nonatomic) UITextField *yearTextField;
@property (nonatomic) HTAutocompleteTextField *grapeVarietyTextField;
@property (nonatomic) UITextField *nameTextField;
@property (nonatomic) UITextField *vineyardTextField;

//@property TRAutocompleteView *autocompleteView;

@property (nonatomic) BOOL editMode;

- (void)setImage:(UIImage *)image;

//- (void)setGrapeVarietyLabel:(NSString *)text;
//- (void)setYearLabel:(NSString *)text;
//- (void)setvineyardLabel:(NSString *)text;
//- (void)setDescriptionLabel:(NSString *)text;

@end
