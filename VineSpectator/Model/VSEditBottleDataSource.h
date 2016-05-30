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
@class VSTagsDataSource;

@protocol VSImageSelectionDelegate;

@interface VSEditBottleDataSource : NSObject<UITableViewDataSource>

@property UIButton *imageButton;

@property (nonatomic) NSString *bottleID;
@property (nonatomic) VSTagsDataSource *tagsDataSource;

@property (nonatomic) NSString *grapeVariety;
@property (nonatomic) NSString *vineyard;
@property (nonatomic) NSString *year;
@property (nonatomic) NSString *name;
@property (nonatomic) UIImage *image;
//@property (nonatomic) NSArray *tags;

@property (nonatomic, weak) id<VSImageSelectionDelegate> imageSelectionDelegate;

- (instancetype)initWithTableView:(UITableView *)tableView bottleDataSource:(VSBottleDataSource *)bottleDataSource tagsDataSource:(VSTagsDataSource *)tagsDataSource bottleID:(NSString *)bottleID;

@end
