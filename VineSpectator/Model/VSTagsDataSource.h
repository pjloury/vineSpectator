//
//  VSTagsDataSource.h
//  VineSpectator
//
//  Created by PJ Loury on 12/26/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSBottleDataSource.h"
#import "VSStackView.h"

@interface VSTagsDataSource : NSObject <UICollectionViewDataSource, VSStackViewDataSource>

- (instancetype)initWithBottleDataSource:(VSBottleDataSource *)bottleDataSource;
- (instancetype)initWithBottleDataSource:(VSBottleDataSource *)bottleDataSource bottleID:(NSString *)bottleID;

@property (nonatomic) NSArray *userTags;
@property (readonly, nonatomic) NSArray *allTags;

- (void)addTag:(NSString *)tag;
- (void)removeTag:(NSString *)tag;
- (void)saveTags;
- (NSString *)textForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)textForStackIndex:(NSInteger)stackIndex;


@end
