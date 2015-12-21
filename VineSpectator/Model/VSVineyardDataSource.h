//
//  VSVineyardDataSource.h
//  VineSpectator
//
//  Created by PJ Loury on 11/27/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSVineyard.h"
#import "HTAutocompleteTextField.h"

@interface VSVineyardDataSource : NSObject <HTAutocompleteDataSource>

+ (VSVineyardDataSource *)sharedInstance;

@property (readonly) NSArray *grapeVarieties;

- (VSVineyard *)vineyardForString:(NSString *)string;

@end
