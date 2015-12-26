//
//  VSEditBottleDataSource.h
//  VineSpectator
//
//  Created by PJ Loury on 12/24/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VSBottleDataSource;
@class VSBotle;

@protocol VSImageSelectionDelegate;

@interface VSEditBottleDataSource : NSObject<UITableViewDataSource>

@property UIButton *imageButton;

@property (nonatomic) NSString *bottleID;

@property (nonatomic) NSString *grapeVariety;
@property (nonatomic) NSString *vineyard;
@property (nonatomic) NSString *year;
@property (nonatomic) NSString *name;
@property (nonatomic) UIImage *image;
@property (nonatomic, weak) id<VSImageSelectionDelegate> imageSelectionDelegate;

- (instancetype)initWithBottleDataSource:(VSBottleDataSource *)bottleDataSource bottleID:(NSString *)bottleID;

@end
