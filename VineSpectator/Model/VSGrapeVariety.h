//
//  VSGrapeVariety.h
//  VineSpectator
//
//  Created by PJ Loury on 11/27/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface VSGrapeVariety : PFObject<PFSubclassing>

@property NSString *name;
@property NSString *color;

@end
