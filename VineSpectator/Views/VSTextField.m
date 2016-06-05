//
//  VSTextField.m
//  VineSpectator
//
//  Created by PJ Loury on 12/24/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSTextField.h"

@implementation VSTextField

- (instancetype)initWithString:(NSString *)string
{
    self = [super initWithFrame:CGRectZero];
    self.font = [UIFont fontWithName:@"Belfast-Regular" size:20.0];
    self.textColor = [UIColor oliveInkColor];
    self.text = string;
    self.adjustsFontSizeToFitWidth = YES;
    self.backgroundColor = [UIColor textFieldBackgroundColor];    
    self.returnKeyType = UIReturnKeyNext;
    return self;
}

@end
