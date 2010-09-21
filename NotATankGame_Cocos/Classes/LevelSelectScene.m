//
//  LevelSelectScene.m
//  NotATankGame_Cocos
//
//  Created by Amrit on 20/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LevelSelectScene.h"


@implementation LevelSelectScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LevelSelectScene *layer = [LevelSelectScene node];
	
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
		
		//NOTE : this is probably the wrong way to do a background sprite, but its jsut here for a "quick fix'
		CCSprite * backgroundSprite = [CCSprite spriteWithFile:@"space1.jpg"];
		backgroundSprite.position=ccp(240, 160);
		[self addChild:backgroundSprite];
		
		// create and initialize a Label
		CCLabel* label = [CCLabel labelWithString:@"Level Select Scene" fontName:@"Marker Felt" fontSize:32];
		
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , 300 );
		
		// add the label as a child to this Layer
		[self addChild: label];
		
		[self addMenuItems];
		
		menuState = kGameStateRunning;
	}
	return self;
}

-(void)addMenuItems
{
	int menuLabelFontSize = 24;
	
	CCLabel * introLabel = [CCLabel labelWithString:@"Intro" fontName:@"Marker Felt" fontSize:menuLabelFontSize];
	CCMenuItemLabel * introMenuItem = [CCMenuItemLabel itemWithLabel:introLabel 
																 target:self 
															   selector:@selector(levelToChangeTo:)];
	introMenuItem.tag = -30;
	
	CCLabel * level1Label = [CCLabel labelWithString:@"Level 1" fontName:@"Marker Felt" fontSize:menuLabelFontSize];
	CCMenuItemLabel * level1MenuItem = [CCMenuItemLabel itemWithLabel:level1Label 
															  target:self 
															selector:@selector(levelToChangeTo:)];
	level1MenuItem.tag = -31;
	
	CCLabel * level2Label = [CCLabel labelWithString:@"Level 2" fontName:@"Marker Felt" fontSize:menuLabelFontSize];
	CCMenuItemLabel * level2MenuItem = [CCMenuItemLabel itemWithLabel:level2Label 
															   target:self 
															 selector:@selector(levelToChangeTo:)];
	level2MenuItem.tag = -32;
	
	CCLabel * level3Label = [CCLabel labelWithString:@"Level 3" fontName:@"Marker Felt" fontSize:menuLabelFontSize];
	CCMenuItemLabel * level3MenuItem = [CCMenuItemLabel itemWithLabel:level3Label 
															   target:self 
															 selector:@selector(levelToChangeTo:)];
	level3MenuItem.tag = -33;
	
	CCLabel * level4Label = [CCLabel labelWithString:@"Level 4" fontName:@"Marker Felt" fontSize:menuLabelFontSize];
	CCMenuItemLabel * level4MenuItem = [CCMenuItemLabel itemWithLabel:level4Label 
															   target:self 
															 selector:@selector(levelToChangeTo:)];
	level4MenuItem.tag = -34;
	
	CCLabel * level5Label = [CCLabel labelWithString:@"Level 5" fontName:@"Marker Felt" fontSize:menuLabelFontSize];
	CCMenuItemLabel * level5MenuItem = [CCMenuItemLabel itemWithLabel:level5Label 
															   target:self 
															 selector:@selector(levelToChangeTo:)];
	level5MenuItem.tag = -35;
	
	CCLabel * level6Label = [CCLabel labelWithString:@"Level 6" fontName:@"Marker Felt" fontSize:menuLabelFontSize];
	CCMenuItemLabel * level6MenuItem = [CCMenuItemLabel itemWithLabel:level6Label 
															   target:self 
															 selector:@selector(levelToChangeTo:)];
	level6MenuItem.tag = -36;
	
	CCLabel * level7Label = [CCLabel labelWithString:@"Level 7" fontName:@"Marker Felt" fontSize:menuLabelFontSize];
	CCMenuItemLabel * level7MenuItem = [CCMenuItemLabel itemWithLabel:level7Label 
															   target:self 
															 selector:@selector(levelToChangeTo:)];
	level7MenuItem.tag = -37;
	
	CCLabel * level8Label = [CCLabel labelWithString:@"Level 8" fontName:@"Marker Felt" fontSize:menuLabelFontSize];
	CCMenuItemLabel * level8MenuItem = [CCMenuItemLabel itemWithLabel:level8Label 
															   target:self 
															 selector:@selector(levelToChangeTo:)];
	level8MenuItem.tag = -38;
	
	CCLabel * level9Label = [CCLabel labelWithString:@"Level 9" fontName:@"Marker Felt" fontSize:menuLabelFontSize];
	CCMenuItemLabel * level9MenuItem = [CCMenuItemLabel itemWithLabel:level9Label 
															   target:self 
															 selector:@selector(levelToChangeTo:)];
	level9MenuItem.tag = -39;
	
	CCLabel * level10Label = [CCLabel labelWithString:@"Level 10" fontName:@"Marker Felt" fontSize:menuLabelFontSize];
	CCMenuItemLabel * level10MenuItem = [CCMenuItemLabel itemWithLabel:level10Label 
															   target:self 
															 selector:@selector(levelToChangeTo:)];
	level10MenuItem.tag = -40;
	
	CCLabel * backLabel = [CCLabel labelWithString:@"Main Menu" fontName:@"Marker Felt" fontSize:menuLabelFontSize];
	CCMenuItemLabel * backMenuItem = [CCMenuItemLabel itemWithLabel:backLabel 
															 target:self 
														   selector:@selector(levelToChangeTo:)];
	backMenuItem.tag = -99;
	
	
	
	//create menu to add menu items to
	CCMenu * levelSelectMenu = [CCMenu menuWithItems:introMenuItem,
								level1MenuItem, level2MenuItem,level3MenuItem, level4MenuItem, level5MenuItem, 
								level6MenuItem,level7MenuItem, level8MenuItem, level9MenuItem, level10MenuItem, 
								backMenuItem,nil];
	[levelSelectMenu alignItemsInRows:
	 [NSNumber numberWithInt:1],
	 [NSNumber numberWithInt:5],
	 [NSNumber numberWithInt:5],
	 [NSNumber numberWithInt:1],
	 nil];
	
	[self addChild:levelSelectMenu];
}

-(void)levelToChangeTo:(id)scene
{
	if(menuState==kGameStateRunning)
	{
		switch ([scene tag]) {
			case -30:
				//[[CCDirector sharedDirector] replaceScene:[CCShrinkGrowTransition transitionWithDuration:0.5f scene:[IntroScene scene]]];
				[self showNotUnlockedAlert];
				break;
				
			case -31:
				[[CCDirector sharedDirector] replaceScene:[CCShrinkGrowTransition transitionWithDuration:0.5f scene:[Level1Scene scene]]];
				break;
				
			case -32:
				[[CCDirector sharedDirector] replaceScene:[CCShrinkGrowTransition transitionWithDuration:0.5f scene:[Level2Scene scene]]];
				break;
				
			case -33:
				//[[CCDirector sharedDirector] replaceScene:[CCShrinkGrowTransition transitionWithDuration:0.5f scene:[Level3Scene scene]]];
				[self showNotUnlockedAlert];
				break;
				
			case -34:
				//[[CCDirector sharedDirector] replaceScene:[CCShrinkGrowTransition transitionWithDuration:0.5f scene:[Level4Scene scene]]];
				[self showNotUnlockedAlert];
				break;
				
			case -35:
				//[[CCDirector sharedDirector] replaceScene:[CCShrinkGrowTransition transitionWithDuration:0.5f scene:[Level5Scene scene]]];
				[self showNotUnlockedAlert];
				break;
				
			case -36:
				//[[CCDirector sharedDirector] replaceScene:[CCShrinkGrowTransition transitionWithDuration:0.5f scene:[Level6Scene scene]]];
				[self showNotUnlockedAlert];
				break;
				
			case -37:
				//[[CCDirector sharedDirector] replaceScene:[CCShrinkGrowTransition transitionWithDuration:0.5f scene:[Level7Scene scene]]];
				[self showNotUnlockedAlert];
				break;
				
			case -38:
				//[[CCDirector sharedDirector] replaceScene:[CCShrinkGrowTransition transitionWithDuration:0.5f scene:[Level8Scene scene]]];
				[self showNotUnlockedAlert];
				break;
				
			case -39:
				//[[CCDirector sharedDirector] replaceScene:[CCShrinkGrowTransition transitionWithDuration:0.5f scene:[Level9Scene scene]]];
				[self showNotUnlockedAlert];
				break;
				
			case -40:
				//[[CCDirector sharedDirector] replaceScene:[CCShrinkGrowTransition transitionWithDuration:0.5f scene:[Level10Scene scene]]];
				[self showNotUnlockedAlert];
				break;
				
			case -99:
				[[CCDirector sharedDirector] replaceScene:[CCShrinkGrowTransition transitionWithDuration:0.5f scene:[MainMenuScene scene]]];
				break;
				
			default:
				break;
		}
	}
}

-(void)showNotUnlockedAlert
{
	menuState = kGameStatePaused;
	
	//[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
	[[CCDirector sharedDirector] pause];
	pauseLayer = [CCColorLayer layerWithColor:ccc4(0, 0, 255, 180) width: 300 height: 160];
	pauseLayer.position = ccp(90, 80);
	//pauseLayer.relativeAnchorPoint = YES;
	[self addChild:pauseLayer z:8];
	
	CCLabel* lockedLabel = [CCLabel labelWithString:@"This stage is locked!" fontName:@"Marker Felt" fontSize:24];
	CCMenuItemLabel * lockedLabelMenuItem = [CCMenuItemLabel itemWithLabel:lockedLabel
																	target:self
																  selector:nil];
	
	CCLabel * resumeLabel = [CCLabel labelWithString:@"OK" fontName:@"Marker Felt" fontSize:30];
	CCMenuItemLabel * resumeMenuItem = [CCMenuItemLabel itemWithLabel:resumeLabel
															   target:self
															 selector:@selector(backToSelection:)];
	//resumeMenuItem.position = ccp(240, 160+24);
	
	alertMenu = [CCMenu menuWithItems:lockedLabelMenuItem, resumeMenuItem, nil];
	[alertMenu alignItemsVertically];
	[self addChild:alertMenu z:10];
}

-(void)backToSelection:(id)sender
{
	[self removeChild:alertMenu cleanup:YES];
	[self removeChild:pauseLayer cleanup:YES];
	//[[Sounds sharedSounds] playMenuBGMusic];
	[[CCDirector sharedDirector] resume];
	menuState = kGameStateRunning;
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
