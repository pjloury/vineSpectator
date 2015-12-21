//
//  VSGrapeVariety.m
//  VineSpectator
//
//  Created by PJ Loury on 11/27/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSGrapeVariety.h"
#import <Parse/PFObject+Subclass.h>

@implementation VSGrapeVariety

@dynamic name;
@dynamic color;

+ (void)load {
    [VSGrapeVariety registerSubclass];
}

+ (NSString *)parseClassName {
    return @"GrapeVariety";
}

@end
