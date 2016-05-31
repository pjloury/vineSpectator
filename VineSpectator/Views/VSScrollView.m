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

/*
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.clipsToBounds && !self.hidden && self.alpha > 0) {
        for (UIView *subview in self.subviews.reverseObjectEnumerator) {
            CGPoint subPoint = [subview convertPoint:point fromView:self];
            UIView *result = [subview hitTest:subPoint withEvent:event];
            if (result != nil) {
                return result;
            }
        }
    }
    
    return nil;
}
*/

@end
