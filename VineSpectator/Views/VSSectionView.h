//
//  VSSectionView.h
//  VineSpectator
//
//  Created by PJ Loury on 12/23/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSSectionView : UIView

@property (nonatomic) UILabel *label;
- (instancetype)initWithTableView:(UITableView *)tableView title:(NSString *)title height:(CGFloat)height;

@end
