//
//  VSVineyardDataSource.m
//  VineSpectator
//
//  Created by PJ Loury on 11/27/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSVineyardDataSource.h"
#import <Parse/Parse.h>

@interface VSVineyardDataSource ()

@property NSArray *vineyards;
@property (nonatomic) NSArray *vineyardNames;

@end

@implementation VSVineyardDataSource

+ (VSVineyardDataSource *)sharedInstance
{
    static dispatch_once_t pred;
    static VSVineyardDataSource *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[VSVineyardDataSource alloc] init];
        [shared _fetchVineyards];
    });
    return shared;
}

- (void)_fetchVineyards
{
    PFQuery *query =  [PFQuery queryWithClassName:@"Vineyard"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        self.vineyards = objects;
    }];
}

- (VSVineyard *)vineyardForString:(NSString *)string
{
    for (VSVineyard *variety in self.vineyards)
    {
        if ([variety.name isEqualToString:string]) {
            return variety;
        }
    }
    return [self vineyardForString:@"Other"];
}

- (NSArray *)vineyardNames
{
    NSMutableArray *names = [NSMutableArray array];
    for (VSVineyard *variety in self.vineyards) {
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
                      colorAutocompleteArray = self.vineyardNames;
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


@end
