//
//  VSBottle.m
//  
//
//  Created by PJ Loury on 11/22/15.
//
//

#import "VSBottle.h"
#import <Parse/PFObject+Subclass.h>

@implementation VSBottle

@dynamic image;
@dynamic hasImage;
@dynamic year;
@dynamic name;
@dynamic grapeVariety;
@dynamic vineyard;
@dynamic owner;
@dynamic tags;


+ (void)load {
    [VSBottle registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Bottle";
}

- (BOOL)hasImage {
    NSString *imageName = self.objectId;
    NSLog(@"Looking for %@", imageName);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:getImagePath];
}

- (UIImage *)cachedImage {
    NSString *imageName = self.objectId;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:getImagePath];
    return image;
}

- (BOOL)containsTag:(NSString *)tag
{
    if ([self.grapeVariety.color isEqualToString:tag]) {
        return YES;
    }
    else if ([self.tags containsObject:tag]) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
