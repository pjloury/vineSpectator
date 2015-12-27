//
//  VSGrapeVarietyDataSource.h
//  VineSpectator
//
//  Created by PJ Loury on 11/27/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSGrapeVariety.h"
#import "HTAutocompleteTextField.h"
#import "VSBottle.h"

@interface VSGrapeVarietyDataSource : NSObject <HTAutocompleteDataSource>

+ (VSGrapeVarietyDataSource *)sharedInstance;

@property (readonly) NSArray *grapeVarieties;

- (VSGrapeVariety *)grapeVarietyForString:(NSString *)string;
- (VSWineColorType)colorForGrapeVariety:(NSString *)grapeVariety;

@end
