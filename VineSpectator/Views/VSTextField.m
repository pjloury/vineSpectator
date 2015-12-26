//
//  VSTextField.m
//  VineSpectator
//
//  Created by PJ Loury on 12/24/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSTextField.h"

@implementation VSTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithString:(NSString *)string
{
    self = [super initWithFrame:CGRectZero];
    self.font = [UIFont fontWithName:@"YuMin-Medium" size:20.0];
    self.textColor = [UIColor oliveInkColor];
    self.text = string;
    self.adjustsFontSizeToFitWidth = YES;
    self.backgroundColor = [UIColor lightSalmonColor];
//    self.layer.borderColor = [UIColor lightSalmonColor].CGColor;
//    self.layer.borderWidth = 5.0f;
    
//    CALayer *upperBorder = [CALayer layer];
//    upperBorder.backgroundColor = [[UIColor lightSalmonColor] CGColor];
//    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 5.0f);
//    [self.layer addSublayer:upperBorder];
//    
//    CALayer *lowerBorder = [CALayer layer];
//    lowerBorder.backgroundColor = [[UIColor lightSalmonColor] CGColor];
//    lowerBorder.frame = CGRectMake(0, CGRectGetHeight(self.frame)-2, CGRectGetWidth(self.frame), 1.0f);
//    [self.layer addSublayer:lowerBorder];
    
    self.returnKeyType = UIReturnKeyNext;
    return self;
}

@end
