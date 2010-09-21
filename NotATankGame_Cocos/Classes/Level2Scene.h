//
//  GamePlayScene.h
//  NotATankGame_Cocos
//
//  Created by Amrit on 15/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "NotATankGame_CocosAppDelegate.h"


#import "LevelSelectScene.h"
#import "UserTank.h"
#import "Weapon.h"
#import "GameEngine.h"
#import "DefineAllConstants.h"
#import "EnemyTank.h"
#import "Explosions.h"
#import "Sounds.h"

@interface Level2Scene : CCLayer {

	GameEngine * theGameEngine;
	
	CCSprite * playerTankSprite;
	
	CCMenuItemLabel * tapToPlayLabelMenuItem;
	
	CCQuadParticleSystem * tankExplosions;
	
	CCParticleGalaxy * playerTankParticleEffect;
	
	//Sounds * gameSounds;
}

+(id) scene;
-(void)setUpScene;
-(void)replaceToLevelSelectScene;

-(void)gameLoop:(ccTime)dt;
-(void)drawUserTankToScreen;
-(void)updateScene;
-(void)togglePause;

-(void)changeWeapon:(id)weaponToChangeTo;
-(void)removeUnrequiredBulletsFromScene;
-(void)updateBulletsOnScene;

-(void)updateEnemiesOnScene;
-(void)removeUnrequiredEnemiesFromScene;

-(void) drawCollisionExplosionParticles:(CGPoint)collisionLocation
							 imagesName:(NSString *) imageName;

@end
