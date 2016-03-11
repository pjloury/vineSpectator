//
//  VSBottle.h
//  
//
//  Created by PJ Loury on 11/22/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "VSVineyard.h"
#import <Parse/Parse.h>
#import "VSGrapeVariety.h"

NS_ASSUME_NONNULL_BEGIN

@class VSGrapeVariety;

typedef NS_ENUM(NSInteger, VSWineColorType) {
    VSWineColorTypeUnspecified,
    VSWineColorTypeRed,
    VSWineColorTypeWhite,
    VSWineColorTypeRose,
    VSWineColorTypeSparkling,
    VSWineColorTypeDessert
};

@interface VSBottle : PFObject<PFSubclassing>

+ (NSString *)parseClassName;
// Insert code here to declare functionality of your managed object subclass

@property NSString *bottleDescription;
@property PFFile *cloudImage;
@property NSDate *dateDrank;
@property BOOL drank;
@property VSGrapeVariety *grapeVariety;
@property (nonatomic, readwrite) VSWineColorType color;
@property NSString *grapeVarietyName;
@property (nonatomic) BOOL hasImage;
@property NSString *name;
@property PFUser *owner;
@property (nonatomic, readwrite) NSArray *tags;
@property VSVineyard *vineyard;
@property NSString *vineyardName;
@property NSInteger year;

- (BOOL)containsText:(NSString *)text;
- (BOOL)containsTag:(NSString *)tag;
- (UIImage *)image;

@end

NS_ASSUME_NONNULL_END

