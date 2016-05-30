//
//  UIImage+Additions.m
//  VineSpectator
//
//  Created by PJ Loury on 5/30/16.
//  Copyright © 2016 PJ Loury. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)

+ (UIImage *)darkenedImageWithImage:(UIImage *)sourceImage
{
    UIImage * darkenedImage = nil;
    
    if (sourceImage)
    {
        // drawing prep
        CGImageRef source = sourceImage.CGImage;
        CGRect drawRect = CGRectMake(0.f,
                                     0.f,
                                     sourceImage.size.width,
                                     sourceImage.size.height);
        CGContextRef context = CGBitmapContextCreate(NULL,
                                                     drawRect.size.width,
                                                     drawRect.size.height,
                                                     CGImageGetBitsPerComponent(source),
                                                     CGImageGetBytesPerRow(source),
                                                     CGImageGetColorSpace(source),
                                                     CGImageGetBitmapInfo(source)
                                                     );
        
        // draw given image and then darken fill it
        CGContextDrawImage(context, drawRect, source);
        CGContextSetBlendMode(context, kCGBlendModeOverlay);
        CGContextSetRGBFillColor(context, 0.f, 0.f, 0.f, 0.5f);
        CGContextFillRect(context, drawRect);
        
        // get context result
        CGImageRef darkened = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        
        // convert to UIImage and preserve original orientation
        darkenedImage = [UIImage imageWithCGImage:darkened
                                            scale:1.f
                                      orientation:sourceImage.imageOrientation];
        CGImageRelease(darkened);
    }
    
    return darkenedImage;
}

@end
