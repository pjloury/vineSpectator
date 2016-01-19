//
//  VSTableViewCell.m
//  VineSpectator
//
//  Created by PJ Loury on 11/22/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSTableViewCell.h"

CGFloat padding = 10.0f;

@interface VSTableViewCell ()

@end

@implementation VSTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier
{
    self = [super initWithStyle:style reuseIdentifier:identifier];
    self.backgroundColor = [UIColor offWhiteColor];
    self.textLabel.textColor = [UIColor redInkColor];
    self.textLabel.font = [UIFont fontWithName:@"BodoniSvtyTwoITCTT-Book" size:18];
    self.detailTextLabel.font = [UIFont fontWithName:@"Lucida Grande" size:14.0];
    self.detailTextLabel.textColor = [UIColor oliveInkColor];
    self.yearLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.yearLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14.0];
    self.yearLabel.textColor = [UIColor oliveInkColor];
    [self addSubview:self.yearLabel];
    
    self.imageView.layer.borderColor = [UIColor brownInkColor].CGColor;
    self.imageView.layer.borderWidth = 5.0;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.bottomBorder = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomBorder.backgroundColor = [UIColor borderGreyColor];
                                         //    lowerBorder.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 0.5f);
    [self addSubview:self.bottomBorder];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

//- (void)prepareForReuse
//{
//    self.imageView.layer.hidden = YES;
//}

- (void)layoutSubviews
{
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(15);
        make.left.equalTo(self.left).offset(18);
        make.width.equalTo(@200);
        make.height.equalTo(@22);
    }];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.bottom).offset(5);
        make.left.equalTo(self.textLabel.left).offset(1);
        make.width.equalTo(@200);
        make.height.equalTo(@18);
    }];
    
    [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textLabel.centerY);
        make.right.equalTo(self.right).offset(-padding);
        make.width.equalTo(@55);
        make.height.equalTo(@15);
    }];
    
    if (self.imageView.image != nil) {
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.detailTextLabel.bottom).offset(padding);
            make.centerX.equalTo(self.centerX);
            make.height.equalTo(@290);
            make.width.equalTo(self.imageView.height);
        }];
    }
        
    //    lowerBorder.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 0.5f);
}

@end
