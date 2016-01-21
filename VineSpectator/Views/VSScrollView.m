//
//  VSScrollView.m
//  VineSpectator
//
//  Created by PJ Loury on 1/19/16.
//  Copyright © 2016 PJ Loury. All rights reserved.
//

#import "VSScrollView.h"

@implementation VSScrollView

- (instancetype)initWithFrame:(CGRect)make
{
    self = [super initWithFrame:make];
    return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    if ( [view isKindOfClass:[UIButton class]] ) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

@end
