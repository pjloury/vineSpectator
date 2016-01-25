//
//  VSBottle.m
//  
//
//  Created by PJ Loury on 11/22/15.
//
//

#import "VSBottle.h"
#import <Parse/PFObject+Subclass.h>

@interface VSBottle ()

//@property BOOL hasImage;

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

- (VSWineColorType)color
{
    return self.grapeVariety.color;
}

- (BOOL)hasImage {
//    if (_hasImage) {
//        return _hasImage;
//    }
//    else {
        NSString *imageName = self.objectId;
        NSLog(@"Looking for %@", imageName);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        return [fileManager fileExistsAtPath:getImagePath] || self.cloudImage;
//    }
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
