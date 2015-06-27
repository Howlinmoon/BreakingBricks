//
//  MyScene.m
//  BreakingBricks
//
//  Created by Jim Veneskey on 6/25/15.
//  Copyright (c) 2015 Jim Veneskey. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

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
        
        // Creating a new sprite node from an image file
        SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
        
        // Create a CG Point to anchor our new sprite - otherwise, it will be at 0,0
        CGPoint myPoint = CGPointMake(size.width/2, size.height/2);
        
        // Configure the new sprite to use our new CGPoint
        ball.position = myPoint;
        
        // Attach a physics body to the ball, making it the same size as the ball graphic
        ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width / 2];
        
        // Add the new sprite node to the scene
        [self addChild:ball];
        
        // Create an initial vector for the ball
        CGVector myVector = CGVectorMake(20, 20);
        
        // Apply it to the ball's physics body
        [ball.physicsBody applyImpulse:myVector];
        
        
    }
    return self;
}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
