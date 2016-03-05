//
//  VSTextView.m
//  VineSpectator
//
//  Created by PJ Loury on 3/4/16.
//  Copyright © 2016 PJ Loury. All rights reserved.
//

#import "VSTextView.h"

@implementation VSTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor lightSalmonColor];
        [[UITextView appearance] setTintColor:[UIColor redInkColor]];
    }
    return self;
}

//- (CGRect)caretRectForPosition:(UITextPosition *)position {
//    CGRect originalRect = [super caretRectForPosition:position];
//    originalRect.size.height = 18.0;
//    originalRect.origin.y += 40;
//    return originalRect;
//}
@end
