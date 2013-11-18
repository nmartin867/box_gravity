//
//  PhotoSizer.h
//  box_gravity
//
//  Created by Nick Martin on 11/17/13.
//  Copyright (c) 2013 Nick Martin. All rights reserved.
//

#import "CCLayer.h"

@interface PhotoSizer : CCLayer
+(UIImage *)resizeImage:(UIImage *)originalImage size:(CGSize)newSize;
@end
