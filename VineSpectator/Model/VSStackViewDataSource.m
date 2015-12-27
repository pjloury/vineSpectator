//
//  VSStackViewDataSource.m
//  VineSpectator
//
//  Created by PJ Loury on 12/26/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSStackViewDataSource.h"
#import "VSTagsDataSource.h"

@interface VSStackViewDataSource()

@property VSTagsDataSource *tagsDataSource;

@end

@implementation VSStackViewDataSource

- (NSInteger)numberOfViewsInStack
{
    return 0;
}

- (UIView *)viewForIndex:(NSInteger)index
{
    return nil;
}


@end
