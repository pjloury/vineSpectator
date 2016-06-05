//
//  VSGrapeVarietyDataSource.m
//  VineSpectator
//
//  Created by PJ Loury on 11/27/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSGrapeVarietyDataSource.h"
#import <Parse/Parse.h>

@interface VSGrapeVarietyDataSource ()

@property NSArray *grapeVarieties;
@property (nonatomic) NSArray *grapeVarietyNames;
@property VSReachability *reachability;

@end

@implementation VSGrapeVarietyDataSource

+ (VSGrapeVarietyDataSource *)sharedInstance
{
    static dispatch_once_t pred;
    static VSGrapeVarietyDataSource *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[VSGrapeVarietyDataSource alloc] init];
        [shared _fetchGrapeVarieties];
        shared.reachability = [VSReachability reachabilityForInternetConnection];
    });
    return shared;
}

- (void)_fetchGrapeVarieties
{
    PFQuery *query =  [PFQuery queryWithClassName:@"GrapeVariety"];
    if (![self.reachability isReachable]) {
        [query fromLocalDatastore];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        [VSGrapeVariety pinAllInBackground:objects];
        self.grapeVarieties = objects;
    }];
}

- (VSGrapeVariety *)grapeVarietyForString:(NSString *)string
{
    for (VSGrapeVariety *variety in self.grapeVarieties)
    {
        if ([variety.name isEqualToString:string]) {
            return variety;
        }
    }
    if (self.grapeVarieties.count > 0) {
        return [self grapeVarietyForString:@"Other"];
    }
    else {
        return nil;
    }
}

- (NSArray *)grapeVarietyNames
{
    NSMutableArray *names = [NSMutableArray array];
    for (VSGrapeVariety *variety in self.grapeVarieties) {
        [names addObject:variety.name];
    }
    return names;
}

- (NSString*)textField:(HTAutocompleteTextField*)textField
   completionForPrefix:(NSString*)prefix
            ignoreCase:(BOOL)ignoreCase
{
    static dispatch_once_t colorOnceToken;
    static NSArray *colorAutocompleteArray;
    dispatch_once(&colorOnceToken, ^
                  {
                      colorAutocompleteArray = self.grapeVarietyNames;
                  });
    
    NSString *stringToLookFor;
    NSArray *componentsString = [prefix componentsSeparatedByString:@","];
    NSString *prefixLastComponent = [componentsString.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (ignoreCase)
    {
        stringToLookFor = [prefixLastComponent lowercaseString];
    }
    else
    {
        stringToLookFor = prefixLastComponent;
    }
    
    for (NSString *stringFromReference in colorAutocompleteArray)
    {
        NSString *stringToCompare;
        if (ignoreCase)
        {
            stringToCompare = [stringFromReference lowercaseString];
        }
        else
        {
            stringToCompare = stringFromReference;
        }
        
        if ([stringToCompare hasPrefix:stringToLookFor])
        {
            return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
        }
    }
    
    return @"";
}

- (VSWineColorType)colorForGrapeVariety:(NSString *)grapeVariety
{
    VSGrapeVariety *variety = [self grapeVarietyForString:grapeVariety];
    if (variety) {
        return variety.color;
    } else {
        return VSWineColorTypeUnspecified;
    }
}

@end
