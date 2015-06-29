//
//  EndScene.m
//  BreakingBricks
//
//  Created by Jim Veneskey on 6/28/15.
//  Copyright (c) 2015 Jim Veneskey. All rights reserved.
//

#import "EndScene.h"
// import the original starting scene for restarting the game
#import "MyScene.h"

@implementation EndScene

-(instancetype)initWithSize: (CGSize) size {
    if (self = [ super initWithSize:size]) {

        // This new end game instance will simply have the white label on black background
        self.backgroundColor = [SKColor blackColor];
        
        // run the end game sound
        SKAction *gameOverSound = [SKAction playSoundFileNamed:@"gameover.caf" waitForCompletion:NO];
        [self runAction:gameOverSound];
        
        // create a message to tell the player
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        label.text = @"GAME OVER";
        label.fontColor = [SKColor whiteColor];
        label.fontSize = 44;
        // center the label in the middle of our scene
        label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:label];
        
        // Add another label - for trying again
        SKLabelNode *tryAgain = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        tryAgain.text = @"Tap to Play Again";
        tryAgain.fontColor = [SKColor blueColor];
        tryAgain.fontSize = 24;
        // transistion the label up after the game over one is displayed
        // initial starting position (off the screen)
        tryAgain.position = CGPointMake(size.width/2, -50);
        
        // our transistion action
        SKAction *moveLabel = [SKAction moveToY:size.height/2 - 40 duration:2.0];
        // run the action
        [tryAgain runAction:moveLabel];
        
        // add the label and action to the scene
        [self addChild:tryAgain];
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // don't care where the player touched...
    MyScene *firstScene = [MyScene sceneWithSize:self.size];
    [self.view presentScene:firstScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.5]];
}


@end
