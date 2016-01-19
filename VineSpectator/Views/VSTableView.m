//
//  VSScrollView.m
//  
//
//  Created by PJ Loury on 1/17/16.
//
//

#import "VSTableView.h"

@implementation VSTableView

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    if ( [view isKindOfClass:[UIButton class]] ) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

@end
