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
        
        // Add the new sprite node to the scene
        [self addChild:ball];
        
        
    }
    return self;
}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
