//
//  GamePlayScene.m
//  NotATankGame_Cocos
//
//  Created by Amrit on 15/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GamePlayScene.h"
#import "CCTouchDispatcher.h"

@implementation GamePlayScene


+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GamePlayScene *layer = [GamePlayScene node];
	
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
		CCLabel* label = [CCLabel labelWithString:@"GamePlay Scene" fontName:@"Marker Felt" fontSize:32];
		
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , 300 );
		
		// add the label as a child to this Layer
		[self addChild: label];
		
		[self setUpScene];
		
		theGameEngine = [[GameEngine alloc] init]; 
		
		//draw players tank 
		[self drawUserTankToScreen];
		
		[self schedule:@selector(gameLoop:) interval:0];
		
		self.isTouchEnabled = YES;
	}
	return self;
}

-(void)drawUserTankToScreen
{
	playerTankSprite = [CCSprite spriteWithFile:[theGameEngine getPlayer1TankImageDetail]];
	playerTankSprite.position = [theGameEngine getUserTankLocation];
	[self addChild:playerTankSprite];
}

-(void)gameLoop:(ccTime)dt
{
	
	[theGameEngine runGameIfNotPaused];
	
	[self updateScene];
	
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(theGameEngine.gameState == kGameStatePaused)
	{
		[self togglePause];
	}
	else if(theGameEngine.gameState == kGameStateRunning)
	{
		[self ccTouchesMoved:touches withEvent:event];
	}
}



-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch * touch = [[event allTouches] anyObject];
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
	CGPoint newPoint = ccp([theGameEngine getUserTankLocation].x, convertedLocation.y);
	
	[playerTankSprite stopAllActions];
	//[playerTankSprite runAction: [CCMoveTo actionWithDuration:0.15 position:newPoint]];
	[playerTankSprite setPosition:newPoint];
	//update location of playertank in gamengine
	[theGameEngine setUserTankLocation:newPoint];
}

-(void)updateScene
{
	if(theGameEngine.gameState == kGameStateRunning)
	{
		//[theGameEngine incrementGameScore];
		[self updateBulletsOnScene];
		[self removeUnrequiredBulletsFromScene];
	}
}

-(void)removeUnrequiredBulletsFromScene
{
	if([theGameEngine thereIsSomeBulletToRemove])
	{
		for(NSNumber * bulletID in [theGameEngine bulletsToRemoveFromView])
		{
			[self removeChild:[self getChildByTag:[bulletID intValue]] cleanup:YES];
		}
		[theGameEngine clearBulletsToRemoveFromViewArray];
	}
}

-(void)updateBulletsOnScene
{
	//CCSprite * redTankEnemySprite = [CCSprite spriteWithFile:@"enemyTank1.png"];
	CCSprite * tempSprite;// = [CCSprite spriteWithFile:@"bullet1.png"];
	
	for (Weapon * bullet in [theGameEngine bulletsPool])
	{
		//NSLog(@"bullets pool count : %i", [[theGameEngine bulletsPool] count]);
		//check if bullet already has been drawn
		if(bullet.hasSubView)
		{
			[[self getChildByTag:bullet.weaponID] setPosition:bullet.weaponLocation];
		}
		else
		{
			//tempSprite = [CCSprite spriteWithFile:bullet.image1];
			tempSprite = [CCSprite spriteWithFile:bullet.image1];
			//tempSprite.position = ccp(arc4random() %480, arc4random() %320);
			
			[tempSprite setPosition:bullet.weaponLocation];
			//NSLog(@"new sprites location = %f , %f", tempSprite.position.x, tempSprite.position.y);
			tempSprite.tag = bullet.weaponID;
			
			[self addChild:tempSprite]; 
			
			//NSLog(@"children in gameplayscene: %i", [[self children] count]);
			
			[bullet setHasSubView:YES];
		}
	}
}

-(void)setUpScene
{
	int gap = 6;
	int btnWidth=55;
	float btnY=0;
	float btnX = ((480/2)-10)-(btnWidth/2);
	
	//draw x button
	CCMenuItemImage * xButton = [CCMenuItemImage itemFromNormalImage:@"cancelBtn.png" 
													   selectedImage:@"playBtn.png"
															  target:self
															selector:@selector(replaceToMainMenuScene)];
	xButton.position = ccp(187, 143);
	
	//pause/unpause button
	CCMenuItemImage * playButton = [CCMenuItemImage itemFromNormalImage:@"playBtn.png" 
													   selectedImage:@"cancelBtn.png"
															  target:self
															selector:@selector(togglePause)];
	playButton.position = ccp(223, 143);
	
	//laser button
	CCMenuItemImage * laserButton = [CCMenuItemImage itemFromNormalImage:@"laser_icon.png" 
														  selectedImage:@"shell_icon.png"
																 target:self
															   selector:@selector(changeWeapon:)];
	btnY = 150 - gap - btnWidth;
	laserButton.tag=-30;
	laserButton.position = ccp(btnX, btnY);
	
	
	
	//pencil/shell/whateveritis button
	CCMenuItemImage * shellButton = [CCMenuItemImage itemFromNormalImage:@"shell_icon.png" 
														   selectedImage:@"laser_icon.png"
																  target:self
																selector:@selector(changeWeapon:)];
	shellButton.tag = -31;
	btnY = btnY - gap - btnWidth;
	shellButton.position = ccp(btnX, btnY);
	
	//rocket button
	CCMenuItemImage * rocketButton = [CCMenuItemImage itemFromNormalImage:@"rocket_icon.png" 
														   selectedImage:@"nuke_icon.png"
																  target:self
																selector:@selector(changeWeapon:)];
	btnY = btnY - gap - btnWidth;
	rocketButton.tag = -32;
	rocketButton.position = ccp(btnX, btnY);
	
	//nuke button
	CCMenuItemImage * nukeButton = [CCMenuItemImage itemFromNormalImage:@"nuke_icon.png" 
														   selectedImage:@"rocket_icon.png"
																  target:self
																selector:@selector(changeWeapon:)];
	btnY = btnY - gap - btnWidth;
	nukeButton.tag=-33;
	nukeButton.position = ccp(btnX, btnY);
	
	
	//tap to begin label
	CCLabel * tapToPlayLabel = [CCLabel labelWithString:@"Tap To Play" fontName:@"Marker Felt" fontSize:32];
	tapToPlayLabelMenuItem = [CCMenuItemLabel itemWithLabel:tapToPlayLabel 
																target:self 
															  selector:@selector(togglePause)];
	tapToPlayLabelMenuItem.position = ccp(0,0);
	tapToPlayLabelMenuItem.visible = YES;
	
	
	CCMenu * gamePlayScenesMenu = [CCMenu menuWithItems:xButton, playButton,tapToPlayLabelMenuItem, 
								   laserButton, shellButton, nukeButton, rocketButton, nil];
	
	[self addChild:gamePlayScenesMenu];
	
	
	/*
	 NOTE : read on the wiki not to use CCLabel if it needs to be updated frequently
	 because its really slow, it is recommended to use CCLabelAtlas or CCBitmapFontAtlas
	 so probably use that for score/health display
	 */ 
}
				
-(void)changeWeapon:(id)weaponToChangeTo
{
	switch ([weaponToChangeTo tag]) {
		case -30:
			[theGameEngine changeCurrentlySelectedWeapon:kLasergun];
			break;

		case -31:
			[theGameEngine changeCurrentlySelectedWeapon:kMachinegun];
			break;
			
		case -32:
			[theGameEngine changeCurrentlySelectedWeapon:kRocketlauncher];
			break;
			
		case -33:
			[theGameEngine changeCurrentlySelectedWeapon:kNuke];
			break;
			
		default:
			break;
	}
}

-(void)togglePause
{
	
	
	//also try change image of buttons here too (play to pause etc.)
	
	
	if ([theGameEngine gameState] == kGameStateRunning) 
	{
		[theGameEngine pauseGame];
		tapToPlayLabelMenuItem.visible = YES;
		
	}
	else 
	{
		[theGameEngine unPauseGame];
		tapToPlayLabelMenuItem.visible = NO;
	}

}
-(void)replaceToMainMenuScene
{
	//[NotATankGame_CocosAppDelegate replaceToScene:kMainMenuScene];
	[theGameEngine pauseGame];
	//[[CCDirector sharedDirector] replaceScene:[MainMenuScene scene]];
	[[CCDirector sharedDirector] replaceScene:[CCShrinkGrowTransition transitionWithDuration:0.5f scene:[MainMenuScene scene]]];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	
	
	CCLOG(@"dealloc: %@", self);
	
	NSLog(@"the game engine retain count %i", [theGameEngine retainCount]);
	[theGameEngine release];
	
	[super dealloc];
}

@end
