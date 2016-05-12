//
//  VSBottle.m
//  
//
//  Created by PJ Loury on 11/22/15.
//
//

#import "VSBottle.h"
#import <Parse/PFObject+Subclass.h>
#import "VSGrapeVarietyDataSource.h"

@interface VSBottle ()

//@property BOOL hasImage;

@end

@implementation VSBottle

@dynamic bottleDescription;
@dynamic cloudImage;

@dynamic dateDrank;
@dynamic drank;
@dynamic grapeVariety;
@dynamic grapeVarietyName;
@dynamic hasImage;
@dynamic name;
@dynamic owner;
@dynamic tags;
@dynamic vineyard;
@dynamic vineyardName;
@dynamic year;

@dynamic color;
//@synthesize color;
//@synthesize tags;

+ (void)load {
    [VSBottle registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Bottle";
}

/*
- (VSWineColorType)computedColor
{
    if (color) {
        return color;
    } else if ([[VSGrapeVarietyDataSource sharedInstance] colorForGrapeVariety:self.grapeVarietyName]) {
        return [[VSGrapeVarietyDataSource sharedInstance] colorForGrapeVariety:self.grapeVarietyName];
    } else {
        return VSWineColorTypeUnspecified;
    }
}
*/

- (BOOL)hasImage {
    NSString *imageName = self.objectId;
    //NSLog(@"Looking for %@", imageName);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:getImagePath] || self.cloudImage;
}

- (UIImage *)image {
    NSString *imageName = self.objectId;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:getImagePath];
    if (!image) {
        image = [UIImage imageWithData:[self.cloudImage getData]];
    }
    return image;
}

- (NSArray *)computedTags
{
    NSArray *possibleTags = [[PFUser currentUser] objectForKey:@"tags"];
    NSMutableArray *actualTags = [NSMutableArray array];
    for (NSString *tag in self.tags){
        if ([possibleTags containsObject:tag]) {
            [actualTags addObject:tag];
        }
    }
    return actualTags;
}

- (BOOL)containsText:(NSString *)text
{
    if ([text isEqualToString:@"PJLOURY"]) {
        return YES;
    }
    BOOL inVineyard = [self.vineyardName containsString:text];
    BOOL inYear = [@(self.year).stringValue containsString:text];
    BOOL inName = [self.name containsString:text];
    BOOL inGrapeVariety = [self.grapeVarietyName containsString:text];
    return inVineyard || inYear || inName || inGrapeVariety || [self containsTag:text];
}

- (BOOL)containsTag:(NSString *)tag
{
    if ([tag isEqualToString:@"Unopened"]) {
        return !self.drank;
    }
//    else if ([self.grapeVariety.color isEqualToString:tag]) {
//        return YES;
//    }
    else if ([self.tags containsObject:tag]) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
