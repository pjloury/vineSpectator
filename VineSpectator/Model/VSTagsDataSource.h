//
//  VSTagsDataSource.h
//  VineSpectator
//
//  Created by PJ Loury on 12/26/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSBottleDataSource.h"

@interface VSTagsDataSource : NSObject

- (instancetype)initWithBottleDataSource:(VSBottleDataSource *)bottleDataSource;
@property (readonly, nonatomic) NSMutableSet *allTags;
@property (readonly, nonatomic) NSMutableArray *orderedTags;

@end
