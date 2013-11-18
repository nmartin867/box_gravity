//
//  PhotoSizer.m
//  box_gravity
//
//  Created by Nick Martin on 11/17/13.
//  Copyright (c) 2013 Nick Martin. All rights reserved.
//

#import "PhotoSizer.h"
#import <UIKit/UIKit.h>

@implementation PhotoSizer
+(UIImage *)resizeImage:(UIImage *)originalImage size:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [originalImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
