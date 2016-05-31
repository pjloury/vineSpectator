//
//  VSBottleDataSource.h
//  VineSpectator
//
//  Created by PJ Loury on 11/22/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSBottle.h"
#import "VSFilterStackViewController.h"

@interface VSBottleDataSource: NSObject <UITableViewDataSource>

@property BOOL showImages;

// Generators
//- (BOOL)generateDataModelForFilter:(NSString *)filter dirty:(BOOL)dirty;
- (BOOL)generateDataModelForFilterType:(VSFilterType)type tag:(NSString *)tag dirty:(BOOL)dirty;
- (BOOL)regenerateDataModel;

// Mutators
- (NSString *)insertBottleWithImage:(UIImage *)image name:(NSString *)name year:(NSString *)year grapeVariety:(NSString *)grapeVariety
                           vineyard:(NSString *)vineyard;
- (void)updateBottleWithBottleID:(NSString *)bottleID image:(UIImage *)image name:(NSString *)name year:(NSString *)year
                    grapeVariety:(NSString *)grapeVariety vineyard:(NSString *)vineyard;

// Accessors
- (void)fetchBottlesForUser:(PFUser *)user withCompletion:(void (^)())completion;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)saveBottleImage:(UIImage *)image withUUID:(NSString *)UUID;

- (VSBottle *)bottleForID:(NSString *)bottleID;
- (NSString *)bottleIDForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray *)allBottles;
- (void)deleteBottleWithID:(NSString *)bottleID;
- (NSString *)numberTextForSection:(NSInteger) section;

- (BOOL)shouldShowEmptyMessageForState;

@end
