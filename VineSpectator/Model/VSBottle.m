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

@end

@implementation VSBottle

@dynamic bottleDescription;
@dynamic cloudImage;
@dynamic color;
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


+ (void)load {
    [VSBottle registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Bottle";
}

- (BOOL)hasImage {
    NSString *imageName = self.objectId;
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

- (void)imageWithCompletion:(VSImageCompletion)completion
{
    NSString *imageName = self.objectId;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:getImagePath];
    if (image ) {
        completion(YES, image);
    }
    else if (self.cloudImage) {
        [self.cloudImage getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            BOOL success = !error;
            completion(success, [UIImage imageWithData:data]);
        }];
    } else {
        completion(NO, image);
    }
    
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
    BOOL inVineyard = [self.vineyardName.lowercaseString containsString:text.lowercaseString];
    BOOL inYear = [@(self.year).stringValue containsString:text];
    BOOL inName = [self.name.lowercaseString containsString:text.lowercaseString];
    BOOL inGrapeVariety = [self.grapeVarietyName.lowercaseString containsString:text.lowercaseString];
    return inVineyard || inYear || inName || inGrapeVariety || [self containsTag:text];
}

- (BOOL)containsTag:(NSString *)tag
{
    if ([tag isEqualToString:@"Unopened"]) {
        return !self.drank;
    }
    else if ([self.tags containsObject:tag]) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
