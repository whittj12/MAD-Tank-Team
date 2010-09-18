//
//  MainMenuScene.m
//  NotATankGame_Cocos
//
//  Created by Amrit on 15/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"

@implementation MainMenuScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenuScene *layer = [MainMenuScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		// create and initialize a Label
		CCLabel* label = [CCLabel labelWithString:@"Main Menu" fontName:@"Marker Felt" fontSize:32];
		
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , 300 );
		
		// add the label as a child to this Layer
		[self addChild: label];
		
		[self addMenuItems];
		
		
		
	}
	return self;
}


-(void)addMenuItems
{
	CCLabel * newGamelabel = [CCLabel labelWithString:@"New Game" fontName:@"Marker Felt" fontSize:24];
	CCMenuItemLabel * newGameMenuItem = [CCMenuItemLabel itemWithLabel:newGamelabel 
																target:self 
															  selector:@selector(replaceToGameScene)];
	
	CCLabel * loadGameLabel = [CCLabel labelWithString:@"Load Game" fontName:@"Marker Felt" fontSize:24];
	CCMenuItemLabel * loadGameMenuItem = [CCMenuItemLabel itemWithLabel:loadGameLabel 
																target:self 
															  selector:@selector(replaceToGameScene)];
	
	//create menu to add menu items to
	CCMenu * mainMenu = [CCMenu menuWithItems:newGameMenuItem, loadGameMenuItem, nil];
	[mainMenu alignItemsVertically];
	
	[self addChild:mainMenu];
	
}

-(void)replaceToGameScene
{
	//[NotATankGame_CocosAppDelegate replaceToScene:kGamePlayScene];
	//[[CCDirector sharedDirector] replaceScene:[GamePlayScene scene]];
//	[[CCDirector sharedDirector] replaceScene:[CCFadeTransition transitionWithDuration:0.5f scene:[GamePlayScene scene]]];
	[[CCDirector sharedDirector] replaceScene:[CCShrinkGrowTransition transitionWithDuration:0.5f scene:[GamePlayScene scene]]];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	CCLOG(@"dealloc: %@", self);
	[super dealloc];
}



@end
