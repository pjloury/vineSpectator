//
//  VSBottle.h
//  
//
//  Created by PJ Loury on 11/22/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "VSGrapeVariety.h"
#import "VSVineyard.h"
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VSWineColorType) {
    VSWineColorTypeRed,
    VSWineColorTypeWhite,
    VSWineColorTypeRose,
    VSWineColorTypeSparkling,
    VSWineColorTypeDessert
};

@interface VSBottle : PFObject<PFSubclassing>

+ (NSString *)parseClassName;
// Insert code here to declare functionality of your managed object subclass

@property PFFile *image;
@property BOOL hasImage;
@property NSInteger year;
@property NSString *name;
@property NSString *grapeVarietyName;
@property VSGrapeVariety *grapeVariety;
@property NSString *vineyardName;
@property VSVineyard *vineyard;
@property PFUser *owner;
@property NSArray *tags;

- (BOOL)containsTag:(NSString *)tag;
- (UIImage *)cachedImage;

@end

NS_ASSUME_NONNULL_END

