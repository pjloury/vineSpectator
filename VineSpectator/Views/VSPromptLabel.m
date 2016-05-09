//
//  VSPromptLabel.m
//  VineSpectator
//
//  Created by PJ Loury on 12/24/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSPromptLabel.h"

@implementation VSPromptLabel

- (instancetype)initWithString:(NSString *)string
{
    self = [super initWithFrame:CGRectZero];
    self.font = [UIFont fontWithName:@"Palatino-Bold" size:18.0];
    self.textColor = [UIColor redInkColor];
    self.text = string;
    [self sizeToFit];
    return self;
}

@end
