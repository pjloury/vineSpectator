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
@property NSMutableDictionary *bottlesDictionary;
@property NSArray *filteredArrayDictionaryArray;
@property NSString *previousFilter;

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
    return self.filteredArrayDictionaryArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // the fADA is missing the cab!
    NSDictionary *bottlesDictionary = self.filteredArrayDictionaryArray[section];
    NSArray *arrayContainingArray = [bottlesDictionary allValues];
    NSArray *bottlesForSection = arrayContainingArray.firstObject;
    return  bottlesForSection.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *bottlesForGrapeVariety = self.filteredArrayDictionaryArray[section];
    return bottlesForGrapeVariety.allKeys.firstObject;
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
    [self generateDataModelForFilter:self.previousFilter dirty:YES];
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
    NSMutableDictionary *section = self.filteredArrayDictionaryArray[indexPath.section];
    NSArray *rows = section.allValues.firstObject;
    VSBottle *selectedBottle = rows[indexPath.row];
    return selectedBottle.objectId;
}

# pragma mark - Generators
- (void)fetchBottlesForUser:(PFUser *)user withCompletion:(void (^)())completion
{
    // find out the list of tags
    PFQuery *query =  [PFQuery queryWithClassName:@"Bottle"];
    
//    NSString *userID = @"";
//    user = [PFQuery getUserObjectWithId:userID];
//    [query whereKey:@"owner" equalTo:user];
    
    [query whereKeyDoesNotExist:@"owner"];
    
    //[query fromLocalDatastore];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.bottles = [objects mutableCopy];
        [PFObject pinAllInBackground:objects];
        self.bottlesDictionary = [self transformBottlesArrayToDictionary:self.bottles]; // this is ALL the bottles
        self.filteredArrayDictionaryArray = [self bottlesArrayDictionaryArrayForFilter:@"Unopened"];
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

- (void)generateDataModelForFilter:(NSString *)filter dirty:(BOOL)dirty;
{
    if (![filter isEqualToString:self.previousFilter] || dirty) {
        self.previousFilter = filter; // TODO: Don't need this one again
        self.filteredArrayDictionaryArray = [self bottlesArrayDictionaryArrayForFilter:filter];
    }
}

- (void)regenerateDataModel
{
    [self generateDataModelForFilter:self.previousFilter dirty:YES];
}

- (NSArray *)bottlesArrayDictionaryArrayForFilter:(NSString *)filter
{
    NSMutableArray *arrayDictionaryArray = [NSMutableArray array];
    NSMutableDictionary *filteredDictionary = [self.bottlesDictionary mutableCopy]; //starts from the bas dictionary
    
    if ([filter isEqualToString:@"None"]) {
        for (NSString *key in filteredDictionary.allKeys) { // cycle through the varieties
            NSMutableArray *bottlesForGrapeVariety = [filteredDictionary objectForKey:key];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"vineyardName" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            NSArray *sortedBottlesForGrapeVariety = [bottlesForGrapeVariety sortedArrayUsingDescriptors:sortDescriptors];
            [arrayDictionaryArray addObject:@{key:sortedBottlesForGrapeVariety}];
        }
    }
    else {
        // ie for tag "red", filter out all that aren't red
        // TODO: if Tag is Equal to a grape variety in bottlesDictionary (ie one of the keys), then return just that Grape Variety
        for (NSString *key in filteredDictionary.allKeys)
        {
            NSMutableArray *bottlesForGrapeVariety = [filteredDictionary objectForKey:key];
            NSMutableArray *filteredBottlesForGrapeVariety = [bottlesForGrapeVariety mutableCopy];
            for (VSBottle *bottle in bottlesForGrapeVariety) {
                if (![bottle containsTag:filter]) {
                    [filteredBottlesForGrapeVariety removeObject:bottle]; // make sure that this is removeable!
                } // the cab is getting removed when it shouldn't !!!!
            }
            if (filteredBottlesForGrapeVariety.count != 0) {
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"vineyardName" ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                NSArray *sortedBottlesForGrapeVariety = [filteredBottlesForGrapeVariety sortedArrayUsingDescriptors:sortDescriptors];
                [arrayDictionaryArray addObject:@{key:sortedBottlesForGrapeVariety}];
            }
        }
    }
    self.previousFilter = filter;
    
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
