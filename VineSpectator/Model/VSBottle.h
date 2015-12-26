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

@property NSString *bottleDescription;
@property PFFile *cloudImage;
@property BOOL drank;
@property VSGrapeVariety *grapeVariety;
@property NSString *grapeVarietyName;
@property (nonatomic) BOOL hasImage;
@property NSString *name;
@property PFUser *owner;
@property NSArray *tags;
@property VSVineyard *vineyard;
@property NSString *vineyardName;
@property NSInteger year;

- (BOOL)containsTag:(NSString *)tag;
- (UIImage *)image;

@end

NS_ASSUME_NONNULL_END

