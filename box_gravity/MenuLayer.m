//
//  MenuLayer.m
//  box_gravity
//
//  Created by Nick Martin on 11/17/13.
//  Copyright (c) 2013 Nick Martin. All rights reserved.
//

#import "MenuLayer.h"
#import "PhotoSizer.h"


@interface MenuLayer(){
    UIImage *newImage;
    CCSprite *newSprite;
    UIImage *croppedImage;
}
@end

@implementation MenuLayer
- (id)init
{
    self = [super init];
    if (self) {
        [self createMenu];
    }
    return self;
}
+(CCScene *) scene{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void)createMenu{
    // Create some menu items
    CCMenuItemImage * menuItem1 = [CCMenuItemImage itemWithNormalImage:@"choose.png"
                                                         selectedImage:nil
                                                                target:self
                                                              selector:@selector(pickPhoto)];
    
    CCMenuItemImage * menuItem2 = [CCMenuItemImage itemWithNormalImage:@"take.png"
                                                         selectedImage:nil
                                                                target:self
                                                              selector:@selector(takePhoto)];
    CCMenu * myMenu = [CCMenu menuWithItems:menuItem1, menuItem2, nil];
    // Arrange the menu items vertically
    [myMenu alignItemsVertically];
    
    // add the menu to your scene
    [self addChild:myMenu];
}

-(void)pickPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.wantsFullScreenLayout = YES;
    [[[CCDirector sharedDirector] view] addSubview:picker.view];
}

-(void)takePhoto{
    UIImagePickerController *picker= [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.wantsFullScreenLayout = YES;
    [[[CCDirector sharedDirector] view] addSubview:picker.view];
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *imageToCrop = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [picker dismissModalViewControllerAnimated:YES];
    [picker.view removeFromSuperview];
    [picker release];
    SSPhotoCropperViewController *photoCropper =
    [[SSPhotoCropperViewController alloc] initWithPhoto:imageToCrop
                                               delegate:self
                                                 uiMode:SSPCUIModePresentedAsModalViewController
                                        showsInfoButton:YES];
    [photoCropper setMinZoomScale:0.75f];
    [photoCropper setMaxZoomScale:1.50f];
    [[[CCDirector sharedDirector] view] addSubview:photoCropper.view];
    
    //newImage = [PhotoSizer resizeImage:originalImage size:CGSizeMake(64.0,64.0)];
    // Let's create a sprite now that we have an image
   
}

#pragma -
#pragma SSPhotoCropperDelegate Methods

- (void) photoCropper:(SSPhotoCropperViewController *)photoCropper
         didCropPhoto:(UIImage *)photo
{
    croppedImage = photo;
}

- (void) photoCropperDidCancel:(SSPhotoCropperViewController *)photoCropper
{
    [photoCropper dismissModalViewControllerAnimated:YES];
}



    

@end
