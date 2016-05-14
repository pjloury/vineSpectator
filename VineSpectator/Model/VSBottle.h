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
    VSWineColorTypeRed, // 1
    VSWineColorTypeWhite, // 2
    VSWineColorTypeRose,
    VSWineColorTypeSparkling,
    VSWineColorTypeDessert,
};

@interface VSBottle : PFObject<PFSubclassing>

+ (NSString *)parseClassName;
// Insert code here to declare functionality of your managed object subclass

@property NSString *bottleDescription;
@property PFFile *cloudImage;
@property NSInteger color;
@property NSDate *dateDrank;
@property BOOL drank;
@property VSGrapeVariety *grapeVariety;
@property NSString *grapeVarietyName;
@property (nonatomic) BOOL hasImage;
@property NSString *name;
@property PFUser *owner;
@property (nonatomic) NSArray *tags;
@property VSVineyard *vineyard;
@property NSString *vineyardName;
@property NSInteger year;


- (VSWineColorType)computedColor;
- (BOOL)containsText:(NSString *)text;
- (BOOL)containsTag:(NSString *)tag;
- (UIImage *)image;

typedef void (^VSImageCompletion)(UIImage *image);

- (void)imageWithCompletion:(VSImageCompletion)completion;

- (NSArray *)computedTags;

@end

NS_ASSUME_NONNULL_END

