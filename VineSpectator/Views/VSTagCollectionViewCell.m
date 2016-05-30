//
//  VSTagCollectionViewCell.m
//  VineSpectator
//
//  Created by PJ Loury on 1/17/16.
//  Copyright © 2016 PJ Loury. All rights reserved.
//

#import "VSTagCollectionViewCell.h"

@interface VSTagCollectionViewCell()

@property UILabel *tagLabel;

@end

@implementation VSTagCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor parchmentColor];
    self.layer.borderColor = [UIColor wineColor].CGColor;
    self.layer.cornerRadius = 5.0f;
    self.layer.borderWidth = 1.0f;
    UILabel *tagLabel = [[UILabel alloc] init];
    tagLabel.font = [UIFont fontWithName:@"Belfast-Regular" size:15.0];
    tagLabel.textColor = [UIColor redInkColor];
    self.tintColor = [UIColor wineColor];
    [self addSubview:tagLabel];
    
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(self);
    }];
    
    self.tagLabel = tagLabel;
    
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = [UIColor wineColor];
        self.tagLabel.textColor = [UIColor parchmentColor];
    } else {
        self.backgroundColor = [UIColor parchmentColor];
        self.tagLabel.textColor = [UIColor redInkColor];
    }
}

- (void)setTag:(NSString *)tag
{
    self.tagLabel.text = tag;
    [self.tagLabel sizeToFit];
    [self setNeedsLayout];
}

@end
