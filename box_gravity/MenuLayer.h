//
//  MenuLayer.h
//  box_gravity
//
//  Created by Nick Martin on 11/17/13.
//  Copyright (c) 2013 Nick Martin. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "SSPhotoCropperViewController.h"

@interface MenuLayer : CCLayer<UIImagePickerControllerDelegate, UINavigationControllerDelegate, SSPhotoCropperDelegate>
+(CCScene *) scene;
@end
