//
//  VSStackViewDelegate.h
//  VineSpectator
//
//  Created by PJ Loury on 12/26/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSStackView.h"

@protocol VSStackViewDelegating

- (void)stackView:(VSStackView *)stackView didSelectViewAtIndex:(NSInteger)index;
// When the user taps the filter, it should tell the table controller that a

@end

@interface VSStackViewDelegate : NSObject<VSStackViewDelegating>

@end
