//
//  GamePlayScene.m
//  NotATankGame_Cocos
//
//  Created by Amrit on 15/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Level2Scene.h"
#import "CCTouchDispatcher.h"

@implementation Level2Scene


+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Level2Scene *layer = [Level2Scene node];
	
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
		
		[self setUpScene];
		
		theGameEngine = [[GameEngine alloc] init]; 
		
		//draw players tank 
		[self drawUserTankToScreen];
		
		[self schedule:@selector(gameLoop:) interval:0];
		
		self.isTouchEnabled = YES;
		
		playerTankParticleEffect = [[CCParticleGalaxy alloc] initWithTotalParticles:50];
		playerTankParticleEffect.texture = [[CCTextureCache sharedTextureCache] addImage:@"playerTank.png"];
		playerTankParticleEffect.position = [theGameEngine getUserTankLocation];
		playerTankParticleEffect.life=1;
		[self addChild:playerTankParticleEffect z:10];
		playerTankParticleEffect.autoRemoveOnFinish = YES;
		//NSLog(@"playertankparticleeffect retain count %i", [playerTankParticleEffect retainCount]);
		
		//play the background music for this scene
//		gameSounds = [[Sounds alloc] init];
//		[gameSounds playLevel2BGMusic];
		[[Sounds sharedSounds] playLevel2BGMusic];
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
	
	//testing particle emitter stuff - 19/09
	//emitter.position = (convertedLocation);
	
	playerTankParticleEffect.position = newPoint;
}

-(void)updateScene
{
	if(theGameEngine.gameState == kGameStateRunning)
	{
		//[theGameEngine incrementGameScore];
		[self updateBulletsOnScene];
		[self updateEnemiesOnScene];
		
		[self removeUnrequiredBulletsFromScene];
		[self removeUnrequiredEnemiesFromScene];
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
			
			
			//play appropriate sound for that bullet
			switch (theGameEngine.currentlySelectedWeaponID) {
				case kLasergun:
					[[Sounds sharedSounds] playLaserBeamSound];
					break;
					
				case kMachinegun:
					[[Sounds sharedSounds] playMachineGunSound];
					break;
					
				default:
					break;
			}
		}
	}
}

-(void)setUpScene
{
	//NOTE : this is probably the wrong way to do a background sprite, but its jsut here for a "quick fix'
	CCSprite * backgroundSprite = [CCSprite spriteWithFile:@"space1.jpg"];
	backgroundSprite.position=ccp(240, 160);
	[self addChild:backgroundSprite];
	
//	// create and initialize a Label
//	CCLabel* label = [CCLabel labelWithString:@"GamePlay Scene" fontName:@"Marker Felt" fontSize:32];
//	
//	// ask director the the window size
//	CGSize size = [[CCDirector sharedDirector] winSize];
//	
//	// position the label on the center of the screen
//	label.position =  ccp( size.width /2 , 300 );
//	
//	// add the label as a child to this Layer
//	[self addChild: label];
	
	int gap = 6;
	int btnWidth=55;
	float btnY=0;
	float btnX = ((480/2)-10)-(btnWidth/2);
	
	//draw x button
	CCMenuItemImage * xButton = [CCMenuItemImage itemFromNormalImage:@"cancelBtn.png" 
													   selectedImage:@"playBtn.png"
															  target:self
															selector:@selector(replaceToLevelSelectScene)];
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


-(void)updateEnemiesOnScene
{
	CCSprite * tempSprite;
	for(EnemyTank * enemy in [theGameEngine enemyPool])
	{
		if(enemy.hasSubView)
		{
			[[self getChildByTag:enemy.enemyID] setPosition:enemy.enemyLocation];
		}
		else
		{
			tempSprite = [CCSprite spriteWithFile:enemy.image1];
			[tempSprite setPosition:enemy.enemyLocation];
			tempSprite.tag = enemy.enemyID;
			
			[self addChild:tempSprite];
			
			[enemy setHasSubView:YES];
		}
	}
}

-(void) drawCollisionExplosionParticles:(CGPoint)collisionLocation
							 imagesName:(NSString *) imageName
{
	tankExplosions = [[CCQuadParticleSystem alloc] initWithTotalParticles:15];
	tankExplosions.duration=0.5f;
	tankExplosions.gravity=CGPointZero;
	
	tankExplosions.angle = 90;
	tankExplosions.angleVar=360;
	tankExplosions.speed=160;
	tankExplosions.speedVar=20;
	tankExplosions.radialAccel=-120;
	tankExplosions.radialAccelVar=0;
	tankExplosions.tangentialAccel=30;
	tankExplosions.tangentialAccelVar=0;
	
	tankExplosions.life=1;
	tankExplosions.lifeVar=1;
	
	tankExplosions.startSpin=0;
	tankExplosions.startSpinVar=0;
	tankExplosions.endSpin=0;
	tankExplosions.endSpinVar=0;
	ccColor4F startColor = {0.5f, 0.5f, 0.5f, 1.0f};
	tankExplosions.startColor = startColor;
	ccColor4F startColorVar = {0.5f, 0.5f, 0.5f, 1.0f};
	tankExplosions.startColorVar = startColorVar;
	ccColor4F endColor = {0.1f, 0.1f, 0.1f, 0.2f};
	tankExplosions.endColor = endColor;
	ccColor4F endColorVar = {0.1f, 0.1f, 0.1f, 0.2f};
	tankExplosions.endColorVar=endColorVar;
	
	tankExplosions.startSize = 30.0f;
	tankExplosions.startSizeVar=10.0f;
	tankExplosions.endSize = kParticleStartSizeEqualToEndSize;
	
	tankExplosions.emissionRate = tankExplosions.totalParticles/tankExplosions.life;
	
	tankExplosions.blendAdditive=YES;
	
	//emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"enemyTank1.png"];
	tankExplosions.texture = [[CCTextureCache sharedTextureCache] addImage:imageName];
	tankExplosions.position = collisionLocation;
	[self addChild:tankExplosions z:10];
	tankExplosions.autoRemoveOnFinish=YES;
	
	//NSLog(@"tankexplosions retaincount %i", [tankExplosions retainCount]);
}

-(void)removeUnrequiredEnemiesFromScene
{
	if([theGameEngine thereIsSomeEnemyToRemove])
	{
		for(EnemyTank * enemy in [theGameEngine enemiesToRemoveFromView])
		{
			[self removeChild:[self getChildByTag:[enemy enemyID]] cleanup:YES];
			[self drawCollisionExplosionParticles:[enemy enemyLocation] imagesName:[enemy image1]];
		}
		[theGameEngine clearEnemiesToRemoveFromViewArray];
	}
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
-(void)replaceToLevelSelectScene
{
	[theGameEngine pauseGame];
	[[CCDirector sharedDirector] replaceScene:[CCShrinkGrowTransition transitionWithDuration:0.5f scene:[LevelSelectScene scene]]];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	
	
	CCLOG(@"dealloc: %@", self);
	
	//NSLog(@"the game engine retain count %i", [theGameEngine retainCount]);
	[theGameEngine release];
	//NSLog(@"playertankparticleeffect retain count %i", [playerTankParticleEffect retainCount]);
	[playerTankParticleEffect release];
	[super dealloc];
}

@end
