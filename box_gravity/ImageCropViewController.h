//
//  ImageCropLayer.h
//  box_gravity
//
//  Created by Nick Martin on 11/19/13.
//  Copyright (c) 2013 Nick Martin. All rights reserved.
//

#import "SSPhotoCropperViewController.h"

@interface ImageCropViewController : UIViewController<SSPhotoCropperDelegate>
    
@property(nonatomic, strong)IBOutlet UIImageView *photoPreviewImageView;
-(id)initWithImage:(UIImage *)image;
@end
