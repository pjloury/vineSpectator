//
//  VSTableViewCell.m
//  VineSpectator
//
//  Created by PJ Loury on 11/22/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSTableViewCell.h"

CGFloat padding = 10.0f;

@implementation VSTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier
{
    self = [super initWithStyle:style reuseIdentifier:identifier];
    //self.bottleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottle-and-glass"]];
    //self.bottleImageView = [[UIImageView alloc] init];
    //[self addSubview:self.bottleImageView];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.bottleImageView.contentMode = UIViewContentModeScaleAspectFit;
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(padding);
        make.left.equalTo(self.left).offset(15);
        make.right.equalTo(self.right).offset(-padding);
        make.height.equalTo(@30);
    }];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.bottom).offset(5);
        make.left.equalTo(self.left).offset(15);
        make.right.equalTo(self.right).offset(-padding);
        make.height.equalTo(@20);
    }];
    
    if (self.imageView.image != nil) {
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.detailTextLabel.bottom).offset(padding);
            make.left.equalTo(self.left).offset(padding);
            make.right.equalTo(self.right).offset(-padding);
            make.height.equalTo(@200);
        }];
    }
}

@end
