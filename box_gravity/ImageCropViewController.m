//
//  ImageCropLayer.m
//  box_gravity
//
//  Created by Nick Martin on 11/19/13.
//  Copyright (c) 2013 Nick Martin. All rights reserved.
//

#import "ImageCropViewController.h"
#import "SSPhotoCropperViewController.h"

@interface ImageCropViewController(){
    UIImage *imageToCrop;
    UIImage *croppedImage;
}

@end
@implementation ImageCropViewController

-(id)initWithImage:(UIImage *)image{
    self = [super init];
    if (self) {
        NSAssert(image != nil, @"ImageCropLayer was initialized without UIImage!");
        imageToCrop = image;
       
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        [self initWithImage:nil];
    }
    return self;
}

-(void)viewDidLoad{
    SSPhotoCropperViewController *photoCropper =
    [[SSPhotoCropperViewController alloc] initWithPhoto:imageToCrop
                                               delegate:self
                                                 uiMode:SSPCUIModePresentedAsModalViewController
                                        showsInfoButton:YES];
    [photoCropper setMinZoomScale:0.75f];
    [photoCropper setMaxZoomScale:1.50f];
    [self presentModalViewController:photoCropper animated:YES];
    [photoCropper release];
}

#pragma -
#pragma SSPhotoCropperDelegate Methods

- (void) photoCropper:(SSPhotoCropperViewController *)photoCropper
         didCropPhoto:(UIImage *)photo
{
    croppedImage = photo;
    self.photoPreviewImageView.image = photo;
    [photoCropper dismissModalViewControllerAnimated:YES];
}

- (void) photoCropperDidCancel:(SSPhotoCropperViewController *)photoCropper
{
    [photoCropper dismissModalViewControllerAnimated:YES];
}

@end
