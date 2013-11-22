//
//  ImageCropLayer.h
//  box_gravity
//
//  Created by Nick Martin on 11/19/13.
//  Copyright (c) 2013 Nick Martin. All rights reserved.
//


@protocol CropPreviewDelegate;

@interface CropPreviewViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
-(id)initWithImage:(UIImage *)image delegate:(id<CropPreviewDelegate>)delegate;
@end

@protocol CropPreviewDelegate<NSObject>
@required
- (void) photoPreviewer:(CropPreviewViewController *)photoPreviewer
         didAcceptPhoto:(UIImage *)photo;
- (void) photoPreviewerDidRetake:(CropPreviewViewController *)photoPreviewer;
@end