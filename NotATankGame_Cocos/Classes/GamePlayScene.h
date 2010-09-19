//
//  GamePlayScene.h
//  NotATankGame_Cocos
//
//  Created by Amrit on 15/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "NotATankGame_CocosAppDelegate.h"


#import "MainMenuScene.h"
#import "UserTank.h"
#import "Weapon.h"
#import "GameEngine.h"
#import "DefineAllConstants.h"
#import "EnemyTank.h"
#import "Explosions.h"

@interface GamePlayScene : CCLayer {

	GameEngine * theGameEngine;
	
	CCSprite * playerTankSprite;
	
	CCMenuItemLabel * tapToPlayLabelMenuItem;
	
	CCParticleMeteor * tankExplosions;
	
	CCParticleGalaxy * playerTankParticleEffect;
}

+(id) scene;
-(void)setUpScene;
-(void)replaceToMainMenuScene;

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
