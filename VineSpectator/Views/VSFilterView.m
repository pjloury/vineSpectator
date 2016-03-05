//
//  VSFilterView.m
//  VineSpectator
//
//  Created by PJ Loury on 12/26/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSFilterView.h"

@interface VSFilterView ()

@end

@implementation VSFilterView


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (selected) {
        self.backgroundColor = [UIColor roseColor];
    } else {
        self.backgroundColor = [UIColor lightSalmonColor];
    }
}

@end
