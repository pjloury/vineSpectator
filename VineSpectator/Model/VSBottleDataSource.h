//
//  VSBottleDataSource.h
//  VineSpectator
//
//  Created by PJ Loury on 11/22/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSBottle.h"

@interface VSBottleDataSource: NSObject <UITableViewDataSource>

// State
@property (nonatomic) NSString *bottleTag;

// Generators
- (void)generateDataModelForFilter:(NSString *)filter dirty:(BOOL)dirty;

// Mutators
- (NSString *)insertBottleWithImage:(UIImage *)image name:(NSString *)name
                         year:(NSString *)year grapeVariety:(NSString *)grapeVariety vineyard:(NSString *)vineyard;
- (void)updateBottleWithImage:(UIImage *)image name:(NSString *)name year:(NSString *)year
                 grapeVariety:(NSString *)grapeVariety vineyard:(NSString *)vineyard bottleID:(NSString *)bottleID;

// Accessors
- (void)fetchBottlesWithCompletion:(void (^)())completion;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)saveBottleImage:(UIImage *)image withUUID:(NSString *)UUID;

- (VSBottle *)bottleForID:(NSString *)bottleID;
- (NSArray *)bottlesForTag:(NSString *)tag;
- (NSString *)bottleIDForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
