//
//  VSTableViewCell.h
//  VineSpectator
//
//  Created by PJ Loury on 11/22/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSTableViewCell : UITableViewCell

@property (nonatomic) UILabel *yearLabel;
@property (nonatomic) UIView *bottomBorder;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier;

//[[VSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

@end
