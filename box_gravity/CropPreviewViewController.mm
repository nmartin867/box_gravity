//
//  ImageCropLayer.m
//  box_gravity
//
//  Created by Nick Martin on 11/19/13.
//  Copyright (c) 2013 Nick Martin. All rights reserved.
//

#import "CropPreviewViewController.h"

@interface CropPreviewViewController(){
    UIImage *croppedImage;
    id<CropPreviewDelegate>previewDelegate;
}
@end

@implementation CropPreviewViewController

-(id)initWithImage:(UIImage *)image delegate:(id<CropPreviewDelegate>)delegate{
     NSAssert(image != nil, @"ImageCropLayer was initialized without UIImage!");
    if (!(self = [super initWithNibName:@"CropPreview" bundle:nil])) {
        return self;
    }
    croppedImage = image;
    previewDelegate = delegate;
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        [self initWithImage:nil delegate:nil];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.imageView.image = croppedImage;
}
- (IBAction)accept:(id)sender {
    if(previewDelegate !=nil){
        if([previewDelegate respondsToSelector:@selector(photoPreviewer:didAcceptPhoto:)]){
            [previewDelegate photoPreviewer:self didAcceptPhoto:croppedImage];
        }
    }
        
}

- (IBAction)retake:(id)sender {
    if(previewDelegate !=nil){
        if([previewDelegate respondsToSelector:@selector(photoPreviewerDidRetake:)]){
            [previewDelegate photoPreviewerDidRetake:self];
        }
    }
}

- (void)dealloc {
    [_imageView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setImageView:nil];
    [super viewDidUnload];
}
@end
