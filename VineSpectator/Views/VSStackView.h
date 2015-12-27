//
//  VSStackView.h
//  VineSpectator
//
//  Created by PJ Loury on 12/26/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VSStackViewDataSourcing;
@protocol VSStackViewDelegating;

@interface VSStackView : UIStackView

@property (nonatomic, weak, nullable) id <VSStackViewDataSourcing> dataSource;
@property (nonatomic, weak, nullable) id <VSStackViewDelegating> delegate;

@end
