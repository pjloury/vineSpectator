//
//  VSVineyard.m
//  VineSpectator
//
//  Created by PJ Loury on 11/27/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSVineyard.h"
#import <Parse/PFObject+Subclass.h>

@implementation VSVineyard

@dynamic name;
@dynamic location;

+ (void)load {
    [VSVineyard registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Vineyard";
}

@end
