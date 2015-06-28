//
//  MyScene.m
//  BreakingBricks
//
//  Created by Jim Veneskey on 6/25/15.
//  Copyright (c) 2015 Jim Veneskey. All rights reserved.
//

#import "MyScene.h"

@interface MyScene()

@property (nonatomic) SKSpriteNode *paddle;

@end


@implementation MyScene

- (void)addBall:(CGSize)size {
    // Creating a new sprite node from an image file
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    
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
    
    // Add the paddle to the scene
    [self addChild:self.paddle];
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor whiteColor];
        
        // Add a physics body to the entire scene - this will prevent the ball from falling off
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        // change the gravity settings of the physics world (1.6 m/sec/sec roughly lunar gravity)
        // -9.8 is earth gravity
        // self.physicsWorld.gravity = CGVectorMake(0, -1.6);
        
        // change the gravity settings of the physics world - removing all gravity...
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        [self addBall:size];
        
        [self addPlayer:size];
        
        [self addBricks: size];
        
        
    }
    return self;
}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
