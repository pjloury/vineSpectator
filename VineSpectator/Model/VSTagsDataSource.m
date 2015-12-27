//
//  VSTagsDataSource.m
//  VineSpectator
//
//  Created by PJ Loury on 12/26/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSTagsDataSource.h"

// I want this to be the only class that can access all of the bottles

@interface VSTagsDataSource ()

@property VSBottleDataSource *bottleDataSource;
@property (nonatomic) NSMutableSet *allTags;
@property (nonatomic) NSMutableArray *orderedTags;

@end

@implementation VSTagsDataSource

- (instancetype)initWithBottleDataSource:(VSBottleDataSource *)bottleDataSource
{
    self = [super init];
    _bottleDataSource = bottleDataSource;
    return self;
}

- (void)generateTags
{
    NSArray *bottles = [self.bottleDataSource allBottles];
    for (VSBottle *bottle in bottles) {
        for (NSString *tag in bottle.tags) {
            [self.allTags addObject:tag];
        }
    }
}

// Need both a data source for the views themselves
// A datasource for tapping
- (NSMutableArray *)orderedTags
{
    NSMutableArray *ot = [NSMutableArray array];
    [ot addObject:@"search"];
    return nil;
}

# pragma mark - VSStackViewDataSource

- (NSInteger)numberOfViewsInStack
{
    return self.allTags.count;
}

- (UIView *)viewForIndex:(NSInteger)index
{
    
    
    return nil;
}

@end
