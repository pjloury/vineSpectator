//
//  VSTextView.m
//  VineSpectator
//
//  Created by PJ Loury on 3/4/16.
//  Copyright © 2016 PJ Loury. All rights reserved.
//

#import "VSTextView.h"

@implementation VSTextView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor lightSalmonColor];
        [[UITextView appearance] setTintColor:[UIColor redInkColor]];
    }
    return self;
}

@end
