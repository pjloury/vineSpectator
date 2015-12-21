//
//  VSVineyard.h
//  VineSpectator
//
//  Created by PJ Loury on 11/27/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface VSVineyard : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property NSString *name;
@property PFGeoPoint *location;

@end
