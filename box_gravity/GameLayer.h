//
//  HelloWorldLayer.h
//  box_gravity
//
//  Created by Nick Martin on 11/11/13.
//  Copyright Nick Martin 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "MyContactListener.h"
#import "SimpleAudioEngine.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32


@interface GameLayer : CCLayer
// returns a CCScene that contains the GameLayer as the only child
@property (nonatomic, strong)CCScene *scene;
-(id)initWithImage:(UIImage *)image;
@end
