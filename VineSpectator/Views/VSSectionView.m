//
//  VSSectionView.m
//  VineSpectator
//
//  Created by PJ Loury on 12/23/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSSectionView.h"

@implementation VSSectionView

- (instancetype)initWithTableView:(UITableView *)tableView title:(NSString *)title height:(CGFloat)height;
{
    self = [super initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 20)];
    self.backgroundColor = [UIColor parchmentColor];
    label.font = [UIFont fontWithName:@"Athelas-Bold" size:20.0];
    label.textColor = [UIColor oliveInkColor];
    label.text = title;
    [label sizeToFit];
    self.label = label;
    
    [self addSubview:label];
    
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = [[UIColor borderGreyColor] CGColor];
    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 1.0f);
    [self.layer addSublayer:upperBorder];
    
    CALayer *lowerBorder = [CALayer layer];
    lowerBorder.backgroundColor = [[UIColor borderGreyColor] CGColor];
    lowerBorder.frame = CGRectMake(0, CGRectGetHeight(self.frame)-2, CGRectGetWidth(self.frame), 1.0f);
    [self.layer addSublayer:lowerBorder];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.centerY);
        make.left.equalTo(self.left).offset(15);
    }];

    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
