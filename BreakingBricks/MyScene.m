//
//  MyScene.m
//  BreakingBricks
//
//  Created by Jim Veneskey on 6/25/15.
//  Copyright (c) 2015 Jim Veneskey. All rights reserved.
//

#import "MyScene.h"
// import our end scene
#import "EndScene.h"


@interface MyScene()

@property (nonatomic) SKSpriteNode *paddle;

@end


// Defining our categories for use in detecting collisions and contacts

static const uint32_t ballCategory   = 1;
static const uint32_t brickCategory  = 2;
static const uint32_t paddleCategory = 4;
static const uint32_t edgeCategory   = 8;
static const uint32_t bottomEdgeCategory = 16;



@implementation MyScene

-(void)didBeginContact:(SKPhysicsContact *)contact {


    // Create a placeholder reference for the "non ball" object
    SKPhysicsBody *notTheBall;
    
    // We know that in a contact event ONE of the nodes MUST be the ball
    // since the paddle can not contact a brick...
    // and since the ball bitmask is lower than the paddle or brick
    // the lowest in the contact - must be the ball!
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        notTheBall = contact.bodyB;
    } else {
        notTheBall = contact.bodyA;
    }
    
    // now notTheBall contains the node the ball ran into
    if (notTheBall.categoryBitMask == brickCategory) {
        NSLog(@"The ball hit a brick!");
        // Play the actual sound effect
        SKAction *playSFX = [SKAction playSoundFileNamed:@"brickhit.caf" waitForCompletion:NO];
        [self runAction:playSFX];
        // so - remove the brick
        [notTheBall.node removeFromParent];
    }
    
    if (notTheBall.categoryBitMask == paddleCategory) {
        // hit the player paddle
        NSLog(@"Player Boing");
        // Play the actual sound effect
        SKAction *playSFX = [SKAction playSoundFileNamed:@"blip.caf" waitForCompletion:NO];
        [self runAction:playSFX];
    }
    
    // did the ball hit the invisible node - bottom edge?
    if (notTheBall.categoryBitMask == bottomEdgeCategory) {
        // ball got past the paddle - the game is over
        // switch to the end game scene (using a built in end scene type)
        EndScene *end = [EndScene sceneWithSize:self.size];
        // do the actual scene swap via presentScene
        [self.view presentScene:end transition:[SKTransition doorsCloseHorizontalWithDuration:1.0]];
    }
    
}

// Create an invisible node - a line that we can determine if the ball contacts
// on the way to the bottom of the scene

- (void)addBottomEdge:(CGSize) size {
    // bottomEdge is our invisible node
    SKNode *bottomEdge = [SKNode node];
    // give it a physics body - 1 pixel up from the scene bottom - and the entire way across
    bottomEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 1) toPoint:CGPointMake(size.width, 1)];
    // assign it to the special category
    bottomEdge.physicsBody.categoryBitMask = bottomEdgeCategory;
    
    // Add it to the scene
    [self addChild:bottomEdge];
}

- (void)addBall:(CGSize)size {
    // Creating a new sprite node from an image file
    // SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"orb0000"];
    
    // Create a CG Point to anchor our new sprite - otherwise, it will be at 0,0
    CGPoint myPoint = CGPointMake(size.width/2, size.height/2);
    
    // Configure the new sprite to use our new CGPoint
    ball.position = myPoint;
    
    // Attach a physics body to the ball, making it the same size as the ball graphic
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width / 2];
    
    // Experimenting with Friction
    ball.physicsBody.friction = 0;
    
    // Experimenting with linear damping - or how much energy is lost
    // when moving across a surface.  (bouncing still drains energy)
    ball.physicsBody.linearDamping = 0;
    
    // Experimenting with restitution - or "bounciness"
    // value of 1.0 is no energy loss at all, 0.5 is half the energy is lost per bounce
    ball.physicsBody.restitution = 1.0f;
    
    // assign the category for this object type
    ball.physicsBody.categoryBitMask = ballCategory;
    // create our contact mask to enable contact with bricks and paddles
    // "|" is a logical OR combining both bitmaps - or ORing them...
    // update - we also want to know if we contact the bottom edge node
    ball.physicsBody.contactTestBitMask = brickCategory | paddleCategory | bottomEdgeCategory;
    
    // experimenting with the collision bitmask
    // ball.physicsBody.collisionBitMask = edgeCategory | brickCategory;
    
    
    // get a reference to the folder containing the orb images
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"orb"];
    
    // Retrieve all of the filenames
    NSArray *orbImageNames = [atlas textureNames];
    
    // Now, sort the filenames
    NSArray *sortedNames = [orbImageNames sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    // Create an array to hold the textures
    NSMutableArray *orbTextures = [NSMutableArray array];
    
    // Add them to the array
    for (NSString *filename in sortedNames) {
        NSLog(@"Adding filename: %@", filename);
        SKTexture *texture = [atlas textureNamed:filename];
        [orbTextures addObject:texture];
        
    }
    
    // create an action to animate the array of textures
    SKAction *glow = [SKAction animateWithTextures:orbTextures timePerFrame:0.1];
    
    // create another action to keep the first one going (glowing)
    SKAction *keepGlowing = [SKAction repeatActionForever:glow];
    
    // Run the repeater
    [ball runAction:keepGlowing];
    
    
    // Add the new sprite node to the scene
    [self addChild:ball];
    
    // Create an initial vector for the ball
    CGVector myVector = CGVectorMake(10, 10);
    
    // Apply it to the ball's physics body
    [ball.physicsBody applyImpulse:myVector];
}


-(void) addBricks:(CGSize) size {
    // creating a total of 4 bricks
    for (int i = 0; i < 4; i++) {
        SKSpriteNode *brick = [SKSpriteNode spriteNodeWithImageNamed:@"brick"];
        
        // Add a static physics body
        brick.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:brick.frame.size];
        brick.physicsBody.dynamic = NO;
        brick.physicsBody.categoryBitMask = brickCategory;
        
        // Place the brick evenly across
        int xPos = size.width / 5 * (i + 1);
        int yPos = size.height - 50;
        brick.position = CGPointMake(xPos, yPos);
        
        [self addChild:brick];
    }
}


// Player input
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // iterate through the touches provided by iOS
    for (UITouch *touch in touches) {
        // Create a point based on the touch location
        CGPoint location = [touch locationInNode:self];
        // 'location' is now a co-ordinate pair of the actual touch position
        // Create a NEW point where we will move the paddle to:
        // this new location uses the actual X from the touch, but we force the Y
        // position to be a fixed value.
        CGPoint newPosition = CGPointMake(location.x, 100);
        
        // Restrict the paddle from shifting too far left or too far right
        // by dynamically creating limits based on the paddle and screen sizes
        CGFloat halfSizeOfPaddle = self.paddle.size.width / 2.0;
        CGFloat xLimit = self.size.width - halfSizeOfPaddle;
        
        // Stop the paddle from going too far to the left
        if (newPosition.x < halfSizeOfPaddle) {
            newPosition.x = halfSizeOfPaddle;
        }
        
        // Stop the paddle from going too far to the right
        if (newPosition.x > xLimit) {
            newPosition.x = xLimit;
        }
        
        // Adjust the paddle to the new X location
        self.paddle.position = newPosition;

    }
}

-(void) addPlayer:(CGSize) size {
    
    // Create the player (paddle) sprite
    self.paddle = [SKSpriteNode spriteNodeWithImageNamed:@"paddle"];

    // give it an initial starting position
    self.paddle.position = CGPointMake(size.width/2, 100);
    
    // it of course, now needs the physics body attached to it
    self.paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.paddle.frame.size];
    
    // Make the paddle static - to keep it from being pushed around by impacts with the ball
    self.paddle.physicsBody.dynamic = NO;
    self.paddle.physicsBody.categoryBitMask = paddleCategory;
    
    // Add the paddle to the scene
    [self addChild:self.paddle];
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor whiteColor];
        
        // Add a physics body to the entire scene - this will prevent the ball from falling off
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.categoryBitMask = edgeCategory;
        
        // change the gravity settings of the physics world (1.6 m/sec/sec roughly lunar gravity)
        // -9.8 is earth gravity
        // self.physicsWorld.gravity = CGVectorMake(0, -1.6);
        
        // change the gravity settings of the physics world - removing all gravity...
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        
        [self addBall:size];
        
        // add a second ball, just for fun!
        //[self addBall:size];
        
        [self addPlayer:size];
        
        [self addBricks: size];
        
        [self addBottomEdge:size];
        
    }
    return self;
}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
