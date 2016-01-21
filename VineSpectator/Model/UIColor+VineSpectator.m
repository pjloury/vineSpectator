//
//  UIColor+VineSpectator.m
//  VineSpectator
//
//  Created by PJ Loury on 12/21/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "UIColor+VineSpectator.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@implementation UIColor (VineSpectator)

+ (UIColor *)wineColor {
    return UIColorFromRGB(0x922455);
}

+ (UIColor *)roseColor {
 //F5E9E9
    return UIColorFromRGB(0xEFDADA);
}

+ (UIColor *)parchmentColor {
    return UIColorFromRGB(0xF8F6EC);
}

+ (UIColor *)offWhiteColor {
    return UIColorFromRGB(0xFFFDF5);
}

+ (UIColor *)oliveInkColor {
    return UIColorFromRGB(0x8D8156);
}
// 8D8170

+ (UIColor *)brownInkColor {
    return UIColorFromRGB(0x897771);
}

+ (UIColor *)redInkColor {
    return UIColorFromRGB(0xC11F5D);
}

+ (UIColor *)highlightedRedInkColor {
    return UIColorFromRGB(0xE7648C);
}

+ (UIColor *)pateColor {
    return UIColorFromRGB(0xDBD2AE);
}

+ (UIColor *)highlightedPateColor {
    return UIColorFromRGB(0xECE5CD);
}

+ (UIColor *)goldColor {
    return UIColorFromRGB(0xACA46F);
}

+ (UIColor *)borderGreyColor {
    return UIColorFromRGB(0x979797);
}

+ (UIColor *)warmTanColor {
    return [UIColor colorWithRed:238.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:0.5];
}

+ (UIColor *)lightSalmonColor {
    return UIColorFromRGB(0xFFF6F5);
}

@end
