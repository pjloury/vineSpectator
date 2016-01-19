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

- (NSString *)textForStackIndex:(NSInteger)stackIndex;
- (NSString *)textForIndexPath:(NSIndexPath *)indexPath;
@property (readonly, nonatomic) NSMutableArray *userTags;
@property (readonly, nonatomic) NSMutableArray *allTags;


- (void)removeTag:(NSString *)tag;
- (void)addTag:(NSString *)tag;
- (void)saveTags;

@end
