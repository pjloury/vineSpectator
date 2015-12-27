//
//  VSStackViewDataSource.h
//  VineSpectator
//
//  Created by PJ Loury on 12/26/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VSStackViewDataSourcing

- (NSInteger)numberOfViewsInStack;
- (UIView *)viewForIndex:(NSInteger)index;

@end

@interface VSStackViewDataSource : NSObject<VSStackViewDataSourcing>

@end
