//
//  Level1Scene.h
//  NotATankGame_Cocos
//
//  Created by Amrit on 20/09/10.
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


@interface Level1Scene : CCLayer {
	
//	CCSprite * _plane;
//	CCAction * _moveAction;
//	CCAction * _flyAroundAction;
	
	GameEngine * theGameEngine;
	
	CCSprite * playerSprite;
	
	CCMenuItemLabel * tapToPlayLabelMenuItem;
	
	CCQuadParticleSystem * tankExplosions;
	
	CCParticleGalaxy * playerTankParticleEffect;
	
	//Sounds * gameSounds;
}

//@property(nonatomic, retain) CCSprite * plane;
//@property(nonatomic, retain) CCAction * moveAction;
//@property(nonatomic, retain) CCAction * flyAroundAction;

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
