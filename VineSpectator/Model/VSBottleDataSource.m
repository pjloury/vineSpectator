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
#import "VSTagsDataSource.h"

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
    self.showImages = NO;
    self.previousType = VSFilterTypeAll;
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.bottles.count == 0) {
        return 0;
    } else {
        return self.filteredArrayDictionaryArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.bottles.count == 0) {
        return 0;
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

- (NSString *)numberTextForSection:(NSInteger) section
{
    NSString *string = @"";
    if (self.filteredArrayDictionaryArray.count > 0) {
        NSDictionary *bottlesForGrapeVariety = self.filteredArrayDictionaryArray[section];
        NSArray *bottles = bottlesForGrapeVariety[bottlesForGrapeVariety.allKeys.firstObject];
        if (bottles.count > 4) {
            string = [NSString stringWithFormat:@"(%ld)", bottles.count];
        }
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
    
    if (self.showImages) {
        if (bottle.image) {
            cell.imageView.image = bottle.image;
            cell.imageView.hidden = NO;
        }
    }
    else {
        cell.imageView.hidden = YES;
    }
    
    CALayer *lowerBorder = [CALayer layer];
    lowerBorder.backgroundColor = [[UIColor warmGray] CGColor];
    lowerBorder.frame = CGRectMake(18, 80-0.5, 1000, 0.5f);
    [cell.layer addSublayer:lowerBorder];
    
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)deleteBottleWithID:(NSString *)bottleID
{
    VSBottle *bottle = [self bottleForID:bottleID];
    [bottle deleteInBackground];
    [self.bottles removeObject:bottle];
    if (self.bottles.count == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"hasBottles"];
    }
    self.bottlesDictionary = [self transformBottlesArrayToDictionary:self.bottles];
    self.chronoArrayDictionaryArray = [self transformBottlesArrayToChronoArrayDictionaryArray:self.bottles];
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
    PFQuery *query =  [PFQuery queryWithClassName:@"Bottle"];
    [query whereKey:@"owner" equalTo:[PFUser currentUser]];
    //[query fromLocalDatastore];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.bottles = [objects mutableCopy];
        
        if (self.bottles.count > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"hasBottles"];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"hasBottles"];
        }

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
        if (!bottle.drank) {
            [self array:chrono addBottle:bottle];
        }
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
        NSLog(@"VSFilterType: %ld", type);
        NSLog(@"Tag: %@", tag);
        self.previousType = type;
        if (type == VSFilterTypeRed || type == VSFilterTypeDrank || type == VSFilterTypeWhite || type == VSFilterTypeChrono) {
            self.filteredArrayDictionaryArray = [self bottlesArrayDictionaryArrayForFilterType:type tag:@""];
        }
        else if ([tag isEqualToString:@""]) {
            self.previousFilter = @"";
            self.filteredArrayDictionaryArray = [self bottlesArrayDictionaryArrayForFilterType:VSFilterTypeAll tag:@""];
        } else {
            if (!tag) {
                tag =  @"";
                self.previousFilter = tag;
            }
            self.filteredArrayDictionaryArray = [self bottlesArrayDictionaryArrayForFilterType:type tag:tag];
        }
        
        return self.filteredArrayDictionaryArray.count > 0;
    } else {
        NSLog(@"NO, WON'T generate model!!");
        return NO;
    }
}

- (void)regenerateDataModel
{
    VSTagsDataSource *tags = [[VSTagsDataSource alloc] initWithBottleDataSource:self];
    if (![tags.allTags containsObject:self.previousFilter]) {
        self.previousFilter = @"";
        self.previousType = VSFilterTypeAll;
    }
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
                    if (bottle.drank) {
                        [filteredBottlesForGrapeVariety removeObject:bottle];
                    }
                    break;
                case VSFilterTypeSearch:
                    if (![bottle containsText:tag] || bottle.drank) {
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
                    if ((bottle.color != VSWineColorTypeRed && [[VSGrapeVarietyDataSource sharedInstance] colorForGrapeVariety:bottle.grapeVarietyName] != VSWineColorTypeRed) || bottle.drank) {
                        [filteredBottlesForGrapeVariety removeObject:bottle];
                    } else {
                        NSLog(@"Bro it's red");
                    }
                    break;
                case VSFilterTypeWhite:
                    if ((bottle.color != VSWineColorTypeWhite && [[VSGrapeVarietyDataSource sharedInstance] colorForGrapeVariety:bottle.grapeVarietyName] != VSWineColorTypeWhite) || bottle.drank) {
                        [filteredBottlesForGrapeVariety removeObject:bottle];
                    } else {
                        NSLog(@"Bro it's white");
                    }
                    break;
                case VSFilterTypeTag:
                        if (![bottle containsTag:tag] || bottle.drank) {
                        [filteredBottlesForGrapeVariety removeObject:bottle];
                    }
                    break;
            }
        }
        if (filteredBottlesForGrapeVariety.count != 0) {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"year" ascending:YES];
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
    if (self.bottles.count > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"hasBottles"];
    }
    self.bottlesDictionary = [self transformBottlesArrayToDictionary:self.bottles];
    self.chronoArrayDictionaryArray = [self transformBottlesArrayToChronoArrayDictionaryArray:self.bottles];
    
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
