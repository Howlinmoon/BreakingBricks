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
        
        
    }
    return self;
}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
