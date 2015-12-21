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

// 1 select a tag
// 2 reloadData

@implementation VSBottleDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.filteredArrayDictionaryArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    //cell.textLabel.text = bottle.name;po
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = bottle.vineyardName;
    cell.detailTextLabel.text = @(bottle.year).stringValue;
    if (bottle.hasImage) {
        cell.imageView.image = bottle.cachedImage;
        cell.imageView.hidden = NO;
    }
    else {
        cell.imageView.hidden = YES;
    }
    
    //cell.bottleImageView.image = bottle.cachedImage;
    [cell setNeedsLayout];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        VSBottle * b = [self.bottles objectAtIndex:indexPath.row];
        [b deleteInBackground];
        [self.bottles removeObjectAtIndex:indexPath.row];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

# pragma mark - Generators
- (void)fetchBottlesWithCompletion:(void (^)())completion
{
    // find out the list of tags
    
    PFQuery *query =  [PFQuery queryWithClassName:@"Bottle"];
    [query whereKeyDoesNotExist:@"owner"];
    
    [query fromLocalDatastore];
    // i should only have to fetch bottles on launch, otherwise they can be updated in memory.
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.bottles = [objects mutableCopy];
        [PFObject pinAllInBackground:objects];
        self.bottlesDictionary = [self transformBottlesArrayToDictionary:self.bottles];
        self.filteredArrayDictionaryArray = [self bottlesArrayDictionaryArrayForFilter:@"None"];
        if (completion) {
            completion();
        }
    }];
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

// TODO should i transform directly into the ADA?

// The alternate approach would be to query each grape variety to see if the own has any bottles in this category
//
//- (NSMutableArray *)transformBottlesToArrayDictionaryArray:(NSArray *)bottles
//{
//    NSMutableArray *arrayDictionaryArray = [NSMutableArray array];
//    
//    for (VSBottle *bottle in bottles) {
//        NSString *grapeVarietyKey = bottle.grapeVariety.name;
//        // have we seen this grape variety?
//
//        // does the array contain a DICTIONARY with a KEY that matches this variety?
//        [self dictionaryForGrapeVariety contains
//        
//        NSMutableArray *bottlesForGrapeVariety = [bottlesDict objectForKey:grapeVarietyKey];
//        if (!bottlesForGrapeVariety) { // if we've never seen this grape variety before
//            NSMutableArray *newBottlesForGrapeVariety = [NSMutableArray array];
//            [newBottlesForGrapeVariety addObject:bottle];
//            [bottlesDict setObject:newBottlesForGrapeVariety forKey:grapeVarietyKey];
//        }
//        else {
//            [bottlesForGrapeVariety addObject:bottle];
//        }
//    }
//    return bottlesDict;
//}
//
//- ([self dictionaryForGrapeVariety contains

- (NSMutableDictionary *)transformBottlesArrayToDictionary:(NSArray *)bottles
{
    NSMutableDictionary* bottlesDict = [NSMutableDictionary dictionary];
    for (VSBottle *bottle in bottles) {
        NSString *grapeVarietyKey = bottle.grapeVarietyName;
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

- (void)generateDataModelForFilter:(NSString *)filter;
{
    if (![filter isEqualToString:self.previousFilter]) {
        self.previousFilter = filter;
        self.filteredArrayDictionaryArray = [self bottlesArrayDictionaryArrayForFilter:filter];
    }
}

- (NSArray *)bottlesArrayDictionaryArrayForFilter:(NSString *)filter
{
    NSMutableArray *arrayDictionaryArray = [NSMutableArray array];
    NSMutableDictionary *filteredDictionary = [self.bottlesDictionary mutableCopy];
    
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
            NSMutableArray *filteredBottlesForGrapeVariety = [bottlesForGrapeVariety copy];
            for (VSBottle *bottle in filteredBottlesForGrapeVariety) {
                if (![bottle containsTag:filter]) {
                    [filteredBottlesForGrapeVariety removeObject:bottle]; // make sure that this is removeable!
                }
            }
            if (filteredBottlesForGrapeVariety.count != 0) {
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"vineyardName" ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                NSArray *sortedBottlesForGrapeVariety = [filteredBottlesForGrapeVariety sortedArrayUsingDescriptors:sortDescriptors];
                [arrayDictionaryArray addObject:@{key:sortedBottlesForGrapeVariety}];
            }
        }
    }
    
    // Sort the array of variety dictionaries by variety
    return [arrayDictionaryArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *grapeVarietyA = [(NSDictionary *)a allKeys].firstObject; //  { "Malbec": [ b1, b2, b3  ] }
        NSString *grapeVarietyB = [(NSDictionary *)b allKeys].firstObject;
        return [grapeVarietyA compare:grapeVarietyB];
    }];
}

- (NSMutableArray *)_fetchBottlesTEST
{
    // find out the list of tags
    PFQuery *query =  [PFQuery queryWithClassName:@"Bottle"];
    [query whereKeyDoesNotExist:@"owner"];
    
    [query fromLocalDatastore];
    // i should only have to fetch bottles on launch, otherwise they can be updated in memory.
    
    NSArray *objects = [query findObjects];
    [PFObject pinAllInBackground:objects];
    return [objects mutableCopy];
}


- (NSMutableArray *)_fetchBottles
{
    // find out the list of tags
    if ([PFUser currentUser]) {
        PFQuery *query =  [PFQuery queryWithClassName:@"Bottle"];
        [query whereKey:@"owner" equalTo:[PFUser currentUser]];
        
        // i should only have to fetch bottles on launch, otherwise they can be updated in memory.
        return [[query findObjects] mutableCopy];
    }
    else {
        return [NSMutableArray array];
    }
}


# pragma mark - Mutators
- (void)insertBottleWithImage:(UIImage *)image name:(NSString *)name
                         year:(NSString *)year grapeVariety:(NSString *)grapeVariety vineyard:vineyard
{
    VSBottle *bottle = [VSBottle object];
    // HANDLE IMAGE
    bottle.image = image?[PFFile fileWithName:name data:UIImageJPEGRepresentation(image, 1.0) contentType:@"jpg"]:nil;
    bottle.name = name ? name : @"";
    bottle.year = year.integerValue;
    bottle.grapeVarietyName = grapeVariety;
    bottle.grapeVariety = [[VSGrapeVarietyDataSource sharedInstance] grapeVarietyForString:grapeVariety];
    bottle.vineyardName = vineyard;
    bottle.vineyard = nil;
    bottle.owner = [PFUser currentUser];
    [bottle saveInBackground];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self saveBottleImage:image withName:name uuid:bottle.objectId];
    });

    
    [self.bottles addObject:bottle];
}

- (void)updateBottleWithImage:(UIImage *)image name:(NSString *)name year:(NSString *)year
                 grapeVariety:(NSString *)grapeVariety vineyard:vineyard bottleID:(NSString *)bottleID
{
    VSBottle *bottle = [self bottleForID:bottleID];
    bottle.image = image ? [PFFile fileWithName:bottle.objectId data:UIImageJPEGRepresentation(image, 0.5) contentType:@"jpg"]:nil;
    bottle.name = name ? name : @"";
    bottle.year = year.integerValue;
    bottle.grapeVarietyName = grapeVariety;
    bottle.grapeVariety = [[VSGrapeVarietyDataSource sharedInstance] grapeVarietyForString:grapeVariety];
    bottle.vineyardName = vineyard;
    bottle.vineyard = nil;
    [bottle saveInBackground];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self saveBottleImage:image withName:name uuid:bottle.objectId];
    });
}

- (void)saveBottleImage:(UIImage *)image withName:(NSString *)name uuid:(NSString *)uuid
{
    // NSData  *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    NSLog(@"*** SIZE *** : Saving file of size %lu", (unsigned long)[data length]);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", uuid]];
    [fileManager createFileAtPath:fullPath contents:data attributes:nil];
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

//# pragma mark - CORE DATA
//- (void)addBottle
//{
//    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    VSBottle *bottle = (VSBottle*)[NSEntityDescription insertNewObjectForEntityForName:@"Bottle" inManagedObjectContext:app.managedObjectContext];
//    bottle.name = @"Tizzle Syrah";
//    bottle.vineyard = @"Napa Winez";
//    bottle.year = 2007;
//    self.bottles = [self _fetchBottlesTEST];
//}
//
//
//- (NSArray *)bottlesForTag:(NSString *)tag
//{
//    return nil;
//}
//
//- (void)updateOrInsertCoreDataBottleWithImage:(UIImage *)image name:(NSString *)name
//                                         year:(NSString *)year grapeVariety:(NSString *)grapeVariety vineyard:vineyard;
//{
//    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    VSBottle *bottle = (VSBottle*)[NSEntityDescription insertNewObjectForEntityForName:@"Bottle" inManagedObjectContext:app.managedObjectContext];
//    
//    bottle.name = @"Petite Syrah";
//    bottle.vineyard = @"Napa Winez";
//    bottle.year = 2007;
//    self.bottles = [self _fetchBottlesCD];
//}
//
//- (NSMutableArray *)_fetchBottlesCD
//{
//    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Bottle"];
//    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    NSError *error = nil;
//    NSMutableArray *fetchedBottles = [[app.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
//    return fetchedBottles;
//    // find out the list of tags
//}

@end
