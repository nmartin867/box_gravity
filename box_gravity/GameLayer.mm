//
//  GameLayer.mm
//  box_gravity
//
//  Created by Nick Martin on 11/11/13.
//  Copyright Nick Martin 2013. All rights reserved.
//

// Import the interfaces
#import "GameLayer.h"

// Not included in "cocos2d.h"
#import "CCPhysicsSprite.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

enum {
	kTagParentNode = 1,
};


#pragma mark - HelloWorldLayer

@interface GameLayer(){
    CCTexture2D *spriteTexture_;	// weak ref
	b2World* world;					// strong ref
    CCSprite *background;           //weak ref
    MyContactListener *_contactListener;
    UIImage *userImage;
}

-(void) initPhysics;
-(void) addNewSpriteAtPosition:(CGPoint)p;
@end

@implementation GameLayer

-(CCScene *)scene;
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id)initWithImage:(UIImage *)image
{
    NSAssert(userImage != nil, @"GameLayer cannot be initialized with nil image!");
	if( (self=[super init])) {
		userImage = image;
        [[SimpleAudioEngine sharedEngine]preloadEffect:@"bump.wav"];
		// enable events
		self.touchEnabled = YES;
		self.accelerometerEnabled = YES;

		// init physics
		[self initPhysics];
        
        //set up background
        CGSize winSize = [CCDirector sharedDirector].winSize;
		[self addNewSpriteAtPosition:ccp(winSize.width/2, winSize.height/2)];
		[self scheduleUpdate];
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

-(void) dealloc
{
	delete world;
	world = NULL;
	[super dealloc];
}


-(void) initPhysics
{
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	world = new b2World(gravity);
	
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	
	world->SetContinuousPhysics(true);
	
    //contact listener
    _contactListener = new MyContactListener();
    world->SetContactListener(_contactListener);
    [self createBorder];
	
    
}

-(void)createBorder{
    
    // for the screenBorder body we'll need these values
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    float widthInMeters = screenSize.width / PTM_RATIO;
    float heightInMeters = screenSize.height / PTM_RATIO;
    b2Vec2 lowerLeftCorner = b2Vec2(0, 0);
    b2Vec2 lowerRightCorner = b2Vec2(widthInMeters, 0);
    b2Vec2 upperLeftCorner = b2Vec2(0, heightInMeters);
    b2Vec2 upperRightCorner = b2Vec2(widthInMeters, heightInMeters);
    
    // Define the static container body, which will provide the collisions at screen borders.
    b2BodyDef screenBorderDef;
    screenBorderDef.position.Set(0, 0);
    b2Body* screenBorderBody = world->CreateBody(&screenBorderDef);
    b2EdgeShape screenBorderShape;
    
    
    // Create fixtures for the four borders (the border shape is re-used)
    screenBorderShape.Set(lowerLeftCorner, lowerRightCorner);
    screenBorderBody->CreateFixture(&screenBorderShape, 0);
    screenBorderShape.Set(lowerRightCorner, upperRightCorner);
    screenBorderBody->CreateFixture(&screenBorderShape, 0);
    screenBorderShape.Set(upperRightCorner, upperLeftCorner);
    screenBorderBody->CreateFixture(&screenBorderShape, 0);
    screenBorderShape.Set(upperLeftCorner, lowerLeftCorner);
    screenBorderBody->CreateFixture(&screenBorderShape, 0);
}


-(void) addNewSpriteAtPosition:(CGPoint)p
{
    CCNode *parent = [self getChildByTag:kTagParentNode];
    CCPhysicsSprite *physicsSprite = [CCPhysicsSprite spriteWithCGImage:userImage.CGImage
                                                                    key:@"sprite"];
    physicsSprite.tag = 1;
    
	//Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
    bodyDef.userData = physicsSprite;
	b2Body *body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box
    
    // Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
    fixtureDef.isSensor = false;
	body->CreateFixture(&fixtureDef);
	
	
	[parent addChild:physicsSprite];
	[physicsSprite setPTMRatio:PTM_RATIO];
	[physicsSprite setB2Body:body];
	[physicsSprite setPosition: ccp( p.x, p.y)];
    
}

-(void) update: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
	
    std::vector<b2Body *>toDestroy;
    std::vector<MyContact>::iterator pos;
    for(pos = _contactListener->_contacts.begin();
        pos != _contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        
        b2Body *bodyA = contact.fixtureA->GetBody();
        b2Body *bodyB = contact.fixtureB->GetBody();
        if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
            CCSprite *spriteA = (CCSprite *) bodyA->GetUserData();
            CCSprite *spriteB = (CCSprite *) bodyB->GetUserData();
            b2Vec2 aLinearVel = bodyA->GetLinearVelocity();
            b2Vec2 bLinearVel = bodyB->GetLinearVelocity();
            if((aLinearVel.y > 0.1) || (bLinearVel.y > 0.1)){
                if (spriteA.tag == 1 && spriteB.tag == 1) {
                    [self playBump];
                }
            }
        }
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		location = [[CCDirector sharedDirector] convertToGL: location];
		[self addNewSpriteAtPosition: location];
	}
}

-(void)playBump{
    [[SimpleAudioEngine sharedEngine] playEffect:@"bump.wav"];
}


@end
