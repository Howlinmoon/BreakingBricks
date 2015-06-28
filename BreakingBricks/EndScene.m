//
//  EndScene.m
//  BreakingBricks
//
//  Created by Jim Veneskey on 6/28/15.
//  Copyright (c) 2015 Jim Veneskey. All rights reserved.
//

#import "EndScene.h"

@implementation EndScene

-(instancetype)initWithSize: (CGSize) size {
    if (self = [ super initWithSize:size]) {

        // This new end game instance will simply have the white label on black background
        self.backgroundColor = [SKColor blackColor];
        // create a message to tell the player
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        label.text = @"GAME OVER";
        label.fontColor = [SKColor whiteColor];
        label.fontSize = 44;
        // center the label in the middle of our scene
        label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:label];
    }
    
    return self;
}

@end
