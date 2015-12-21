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
- (void)generateDataModelForFilter:(NSString *)filter;

// Mutators
- (void)updateBottleWithImage:(UIImage *)image name:(NSString *)name year:(NSString *)year
                 grapeVariety:(NSString *)grapeVariety vineyard:vineyard bottleID:(NSString *)bottleID;
- (void)insertBottleWithImage:(UIImage *)image name:(NSString *)name
                                 year:(NSString *)year grapeVariety:(NSString *)grapeVariety vineyard:vineyard;


// Accessors
- (void)fetchBottlesWithCompletion:(void (^)())completion;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;


- (VSBottle *)bottleForID:(NSString *)bottleID;
- (NSArray *)bottlesForTag:(NSString *)tag;
- (NSString *)bottleIDForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
