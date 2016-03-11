//
//  VSBottleDataSource.m
//  VineSpectator
//
//  Created by PJ Loury on 11/22/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSBottleDataSource.h"
#import "VSTableViewCell.h"
#import "VSBottle.h"
#import "VSGrapeVarietyDataSource.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface VSBottleDataSource ()

@property NSMutableArray *bottles;
// The master set of GrapeVariety: Bottles
@property NSMutableDictionary *bottlesDictionary;
@property NSArray *filteredArrayDictionaryArray;
@property NSArray *chronoArrayDictionaryArray;
@property NSString *previousFilter;
@property VSFilterType previousType;

//
@property NSMutableArray *filteredBottles;
//

// the "sections" will be the

// White tab
// Chardonnay:
    // Char 1
    // Char 2
// Riesling:
    // R 1
    // R 2
    // R 3

// No tab
// Cab
    //
    //
    //
    //
    //
    //
// Char
    //
    //
// Malbec
    //
// Riesling
    //
    //
    //

@end


@implementation VSBottleDataSource

#pragma mark - Table view data source

- (instancetype)init
{
    self = [super init];
    [VSGrapeVarietyDataSource sharedInstance];
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.bottles.count == 0) {
        return 1;
    } else {
        return self.filteredArrayDictionaryArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.bottles.count == 0) {
        return 1;
    } else {
        NSDictionary *bottlesDictionary = self.filteredArrayDictionaryArray[section];
        NSArray *arrayContainingArray = [bottlesDictionary allValues];
        NSArray *bottlesForSection = arrayContainingArray.firstObject;
        return  bottlesForSection.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *string;
    if (self.filteredArrayDictionaryArray.count > 0) {
        NSDictionary *bottlesForGrapeVariety = self.filteredArrayDictionaryArray[section];
        string = bottlesForGrapeVariety.allKeys.firstObject;
    }
    return string;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    VSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[VSTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (self.bottles.count == 0) {
        //cell.textLabel.text = bottle.vineyardName;
        cell.detailTextLabel.text = @"Press below to get started.";
    } else {
        NSDictionary *bottlesDictionaryForGrapeVariety = self.filteredArrayDictionaryArray[indexPath.section];
        NSArray *bottlesForGrapeVariety = [bottlesDictionaryForGrapeVariety allValues].firstObject; // there is only 1 value. an array. Give me that array.
        VSBottle *bottle = [bottlesForGrapeVariety objectAtIndex:indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = bottle.vineyardName;
        cell.detailTextLabel.text = bottle.name;
        cell.yearLabel.text = @(bottle.year).stringValue; //@"2007";
        if (bottle.name) {
            cell.detailTextLabel.hidden = NO;
        }
        else {
            cell.detailTextLabel.hidden = YES;
        }
        
        if (bottle.image) {
            cell.imageView.image = bottle.image;
            cell.imageView.hidden = NO;
        }
        else {
            cell.imageView.hidden = YES;
        }
        
    //    [cell.bottomBorder mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(cell.left);
    //        make.right.equalTo(cell.right);
    //        make.top.equalTo(cell.bottom);
    //        make.height.equalTo(@(1.0));
    //    }];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *bottleID = [self bottleIDForRowAtIndexPath:indexPath];
        [self deleteBottleWithID:bottleID];
        [tableView reloadData];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)deleteBottleWithID:(NSString *)bottleID
{
    VSBottle *bottle = [self bottleForID:bottleID];
    [bottle deleteInBackground];
    [self.bottles removeObject:bottle];
    self.bottlesDictionary = [self transformBottlesArrayToDictionary:self.bottles];
    [self regenerateDataModel];
}


// only use a network op when you have to
- (NSArray *)grapeVarieties
{
    NSMutableSet *grapeVarieties = [[NSMutableSet alloc] init];
    for (VSBottle *bottle in self.bottles) {
        [grapeVarieties addObject:bottle.grapeVariety];
    }
    return [grapeVarieties.allObjects.mutableCopy sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (NSArray *)_grapeVarietiesWithTag:(NSString *)tag
{
    NSMutableSet *grapeVarieties = [[NSMutableSet alloc] init];
    for (VSBottle *bottle in self.bottles) {
        //        if ([bottle.tags containsObject:tag])
        //        [grapeVarieties addObject:bottle.grapeVariety];
    }
    return nil;
}

- (NSArray *)_bottlesWithTag:(NSString *)tag
{
    return nil;
}

- (NSString *)bottleIDForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: parse with section logic
    if (self.filteredArrayDictionaryArray.count > 0) {
        NSMutableDictionary *section = self.filteredArrayDictionaryArray[indexPath.section];
        NSArray *rows = section.allValues.firstObject;
        VSBottle *selectedBottle = rows[indexPath.row];
        return selectedBottle.objectId;
    } else {
        return nil;
    }
}

# pragma mark - Generators
- (void)fetchBottlesForUser:(PFUser *)user withCompletion:(void (^)())completion
{
    // find out the list of tags
    PFQuery *query =  [PFQuery queryWithClassName:@"Bottle"];
    
    // MANAGE LOGIN FLOW FOR USER. Capture Email and Password!
    //    NSString *userID = @"";
    //    user = [PFQuery getUserObjectWithId:userID];
    //    [query whereKey:@"owner" equalTo:user];
    [query whereKeyDoesNotExist:@"owner"];
    
    //[query fromLocalDatastore];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.bottles = [objects mutableCopy];
        [PFObject pinAllInBackground:objects];
        self.bottlesDictionary = [self transformBottlesArrayToDictionary:self.bottles]; // this is ALL the bottles
        self.chronoArrayDictionaryArray = [self transformBottlesArrayToChronoArrayDictionaryArray:self.bottles];
        
        self.filteredArrayDictionaryArray = [self bottlesArrayDictionaryArrayForFilterType:VSFilterTypeAll tag:nil];
        if (completion) {
            completion();
        }
    }];
}

- (NSMutableDictionary *)transformBottlesArrayToDictionary:(NSArray *)bottles
{
    NSMutableDictionary* bottlesDict = [NSMutableDictionary dictionary];
    for (VSBottle *bottle in bottles) {
        NSString *grapeVarietyKey = bottle.grapeVarietyName;
        NSAssert(grapeVarietyKey, @"can't be nil!");
        NSMutableArray *bottlesForGrapeVariety = [bottlesDict objectForKey:grapeVarietyKey];
        if (!bottlesForGrapeVariety) {
            NSMutableArray *newBottlesForGrapeVariety = [NSMutableArray array];
            [newBottlesForGrapeVariety addObject:bottle];
            [bottlesDict setObject:newBottlesForGrapeVariety forKey:grapeVarietyKey];
        }
        else {
            [bottlesForGrapeVariety addObject:bottle];
        }
    }
    return bottlesDict;
}

- (NSArray *)transformBottlesArrayToChronoArrayDictionaryArray:(NSArray *)bottles
{
    NSMutableArray *chrono = [NSMutableArray array];
    for (VSBottle *bottle in bottles) {
        // for this bottle's year, does a dictionary exist?
        [self array:chrono addBottle:bottle];
    }
    
    // Sort the array of variety dictionaries by variety
    return [chrono sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *yearA = [(NSDictionary *)a allKeys].firstObject; //  { "Malbec": [ b1, b2, b3  ] }
        NSString *yearB = [(NSDictionary *)b allKeys].firstObject;
        return [@(yearA.intValue) compare:@(yearB.intValue)];
    }];
    return chrono;
}

// Creates a /adds to a new dictionary: array
- (void)array:(NSMutableArray *)array addBottle:(VSBottle *)bottle
{
    NSString *key = [NSString stringWithFormat: @"%ld", (long)bottle.year];
    BOOL foundYear = NO;
    for (NSMutableDictionary *dict in array) {
        if ([dict.allKeys.firstObject isEqualToString:key]) {
            NSMutableArray *bottleArray = [dict objectForKey:key];
            [bottleArray addObject:bottle];
            foundYear = YES;
            
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"vineyardName" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            [bottleArray sortUsingDescriptors:sortDescriptors];
            break;
        }
    }
    if (foundYear == NO) {
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        NSMutableArray *newBottleArray = [NSMutableArray array];
        [newBottleArray addObject:bottle];
        [mDict setObject:newBottleArray forKey:key];
        [array addObject:mDict];
    }
}

- (BOOL)generateDataModelForFilterType:(VSFilterType)type tag:(NSString *)tag dirty:(BOOL)dirty;
{
    if (![tag isEqualToString:self.previousFilter] || dirty || type != self.previousType) {
        self.previousType = type;
        if (!tag) tag = @"";
        self.previousFilter = tag; // TODO: Don't need this one again
        self.filteredArrayDictionaryArray = [self bottlesArrayDictionaryArrayForFilterType:type tag:tag];
        return self.filteredArrayDictionaryArray.count > 0;
    } else {
        return NO;
    }
}

- (void)regenerateDataModel
{
    [self generateDataModelForFilterType:self.previousType tag:self.previousFilter dirty:YES];
}

- (NSArray *)bottlesArrayDictionaryArrayForFilterType:(VSFilterType)type
                                                  tag:(NSString *)tag
{
    NSMutableArray *arrayDictionaryArray = [NSMutableArray array];
    NSMutableDictionary *filteredDictionary = [self.bottlesDictionary mutableCopy];
    for (NSString *key in filteredDictionary.allKeys)
    {
        NSMutableArray *bottlesForGrapeVariety = [filteredDictionary objectForKey:key];
        NSMutableArray *filteredBottlesForGrapeVariety = [bottlesForGrapeVariety mutableCopy];
        for (VSBottle *bottle in bottlesForGrapeVariety) {
            // TODO: by calling containsTag instead OPTIMIZE
            switch (type) {
                case VSFilterTypeAll:
                    break;
                case VSFilterTypeSearch:
                    if (![bottle containsText:tag]) {
                        [filteredBottlesForGrapeVariety removeObject:bottle];
                    }
                    break;
                case VSFilterTypeChrono:
                    return self.chronoArrayDictionaryArray;
                    break;
                case VSFilterTypeDrank:
                    if (!bottle.drank) {
                        [filteredBottlesForGrapeVariety removeObject:bottle];
                    }
                    break;
                case VSFilterTypeRed:
                    if (bottle.color != VSWineColorTypeRed) {
                        [filteredBottlesForGrapeVariety removeObject:bottle];
                    }
                    break;
                case VSFilterTypeWhite:
                    if (bottle.color != VSWineColorTypeWhite) {
                        [filteredBottlesForGrapeVariety removeObject:bottle];
                    }
                    break;
                case VSFilterTypeTag:
                    if (![bottle containsTag:tag]) {
                        [filteredBottlesForGrapeVariety removeObject:bottle];
                    }
                    break;
            }
        }
        if (filteredBottlesForGrapeVariety.count != 0) {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"vineyardName" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            NSArray *sortedBottlesForGrapeVariety = [filteredBottlesForGrapeVariety sortedArrayUsingDescriptors:sortDescriptors];
            [arrayDictionaryArray addObject:@{key:sortedBottlesForGrapeVariety}];
        }
    }
    
    self.previousFilter = tag;
    
    // Sort the array of variety dictionaries by variety
    return [arrayDictionaryArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *grapeVarietyA = [(NSDictionary *)a allKeys].firstObject; //  { "Malbec": [ b1, b2, b3  ] }
        NSString *grapeVarietyB = [(NSDictionary *)b allKeys].firstObject;
        return [grapeVarietyA compare:grapeVarietyB];
    }];
}

# pragma mark - Mutators

//- (NSString *)insertBottleWithImage:(UIImage *)image name:(NSString *)name year:(NSString *)year grapeVariety:(NSString *)grapeVariety
//                           vineyard:(NSString *)vineyard tags:(NSArray *)tags
- (NSString *)insertBottleWithImage:(UIImage *)image name:(NSString *)name year:(NSString *)year grapeVariety:(NSString *)grapeVariety
                           vineyard:(NSString *)vineyard
{
    VSBottle *bottle = [VSBottle object];
    // HANDLE IMAGE
    bottle.drank = NO;
    bottle.name = name ? name : @"";
    bottle.year = year.integerValue;
    VSGrapeVariety *grapeVarietyObject = [[VSGrapeVarietyDataSource sharedInstance] grapeVarietyForString:grapeVariety?:@""];
    NSAssert(grapeVarietyObject, @"grape variety cannot be nil");
    bottle.grapeVariety = grapeVarietyObject;
    bottle.grapeVarietyName = grapeVariety;
    NSAssert(bottle.grapeVarietyName, @"grape variety cannot be nil");
    bottle.vineyardName = vineyard;
    VSVineyard *vineyardObject = [VSVineyard object];
    vineyardObject.name = vineyard;
    [vineyardObject saveInBackground];
    bottle.vineyard = vineyardObject;
    bottle.owner = [PFUser currentUser];
    bottle.tags = [[NSMutableArray alloc] init];
    [bottle save];
    
    if (image) bottle.hasImage = YES;
    [self saveBottleImage:image withUUID:bottle.objectId];
    [self.bottles addObject:bottle];
    self.bottlesDictionary = [self transformBottlesArrayToDictionary:self.bottles];
    
    return bottle.objectId;
}


- (void)updateBottleWithBottleID:(NSString *)bottleID image:(UIImage *)image name:(NSString *)name year:(NSString *)year
                    grapeVariety:(NSString *)grapeVariety vineyard:(NSString *)vineyard
//- (void)updateBottleWithBottleID:(NSString *)bottleID image:(UIImage *)image name:(NSString *)name year:(NSString *)year
//                    grapeVariety:(NSString *)grapeVariety vineyard:(NSString *)vineyard tags:(NSArray *)tags
{
    VSBottle *bottle = [self bottleForID:bottleID];
    bottle.name = name ? name : @"";
    bottle.year = year.integerValue;
    VSGrapeVariety *grapeVarietyObject = [[VSGrapeVarietyDataSource sharedInstance] grapeVarietyForString:grapeVariety?:@""];
    NSAssert(grapeVarietyObject, @"grape variety cannot be nil");
    bottle.grapeVariety = grapeVarietyObject;
    bottle.grapeVarietyName = grapeVariety;
    NSAssert(bottle.grapeVarietyName, @"grape variety cannot be nil");
    bottle.vineyardName = vineyard;
    bottle.vineyard.name = vineyard ? vineyard : @"";
    
    if (image) bottle.hasImage = YES;
    [bottle saveInBackground];
    [self saveBottleImage:image withUUID:bottleID];
}

//- (BOOL)_changesMade
//{
//    VSBottle *bottle = [self.bottleDataSource bottleForID:self.bottleID];
//    BOOL nameChanged = ![bottle.name isEqualToString: self.addBottleView.nameTextField.text];
//    BOOL yearChanged = !(bottle.year == self.addBottleView.yearTextField.text.integerValue);
//    BOOL grapeVarietyChanged = ![bottle.grapeVariety.name isEqualToString:self.addBottleView.grapeVarietyTextField.text];
//    // TODO: Compare the string to the vineyard
//    //BOOL vineyardChanged = ![bottle.vineyard isEqualToString:self.addBottleView.vineyardTextField.text];
//    return (nameChanged || yearChanged || grapeVarietyChanged); //|| vineyardChanged);
//}

- (BOOL)_image:(UIImage *)image changedForID:(NSString *)bottleID
{
    VSBottle *bottle = [self bottleForID:bottleID];
    return ![bottle.image isEqual:bottle.image] && ![bottle.image isEqual:[UIImage imageNamed:@"add-photo"]];
}

- (void)saveBottleImage:(UIImage *)image withUUID:(NSString *)UUID// completion:
{
    if (!image) return;
    
    if (!UUID) {
        VSBottle *bottle = [VSBottle object];
        //bottle.grapeVarietyName = @"Other";
        [bottle save];
        UUID = bottle.objectId;
    }
    
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if ([self _image:image changedForID:UUID]) {
            NSData *data = UIImageJPEGRepresentation(image, 0.5);
            NSLog(@"*** SIZE *** : Saving file of size %lu", (unsigned long)[data length]);
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:UUID];
            [fileManager createFileAtPath:fullPath contents:data attributes:nil];
            
            VSBottle *bottle = [self bottleForID:UUID];
            bottle.hasImage = YES;
            bottle.cloudImage = image?[PFFile fileWithName:UUID data:UIImageJPEGRepresentation(image, 0.5) contentType:@"jpg"]:nil;
            [bottle saveInBackground];
        }
    //});
}

- (VSBottle *)bottleForID:(NSString *)bottleID
{
    for (VSBottle *bottle in self.bottles) {
        if ([bottle.objectId isEqualToString:bottleID]) {
            return bottle;
        }
    }
    NSAssert(YES, @"Requested ID not amongst bottles");
    return nil;
}

@end
