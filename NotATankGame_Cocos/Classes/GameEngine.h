//
//  GameEngine.h
//  tankPrototype_3
//
//  Created by Amrit on 27/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserTank.h"
#import "Weapon.h"
#import "GameEngine.h"
#import "EnemyTank.h"
#import "Sounds.h"


@interface GameEngine : NSObject {
	
	UserTank * player1;
	
	//Explosions * explosion1;
	//int explosionUniqueIdentifier;
//	NSMutableArray * explosionsPool;
//	NSMutableArray * tempExplosionsPool;
//	NSMutableArray * explosionsToRemoveFromView;
	
	EnemyTank * enemyTankType1;
	NSMutableArray * enemyPool;
	NSMutableArray * tempEnemyPool;
	NSMutableArray * enemiesToRemoveFromView;
	int enemyUniqueIdentifier;
	
	//for special weapons
//	NSMutableArray * specialBulletsPool;
//	NSMutableArray * special

	//for autofire machinegun bullets
	NSMutableArray * bulletsPool;
	NSMutableArray * tempBulletPool;
	NSMutableArray * bulletsToRemoveFromView;
	NSNumber * tempBulletsID;
	
	Weapon * basicMachineGun;
	Weapon * nuke;
	Weapon * rocket;
	Weapon * laser;
	
	int currentlySelectedWeaponID;
	int bulletUniqueIdentifier;
	
	int randomNumberForEnemyPosition;
	double randomNumberForEnemyVelocityChange;
	
	NSInteger gameState;
	double gameScore;
	
	bool thereIsSomeBulletToRemove;
	bool thereIsSomeEnemyToRemove;
	bool thereIsSomeExplosionToRemove;
	
	int howOftenToAddBullets;
	int howOftenToAddEnemies;
	
	CGRect bulletsFrame;
	CGRect enemyFrame;
}

-(void)changeCurrentlySelectedWeapon:(int)newWeapon;

-(void)setUserTankHealth:(int)newHealth;
-(void)setUserTankLocation:(CGPoint)newLocation;
-(int)getUserTankHealth;
-(CGPoint)getUserTankLocation;
-(CGPoint)getUserTankImgSize;
-(NSString *)getPlayer1TankImageDetail;

-(void)incrementGameScore;

-(void)runGameIfNotPaused;
-(void)gameLoop;

-(void)unPauseGame;
-(void)pauseGame;

-(void)gameLoop;
-(void)checkForCollisions;

-(void)fireNewBullet;
-(void)moveAllBullets;
-(void)removeUnwantedBullets;
-(void)clearBulletsToRemoveFromViewArray;

-(void)addNewEnemies;
-(void)moveEnemies;
-(void)removeUnwantedEnemies;
-(void)clearEnemiesToRemoveFromViewArray;

-(void)createNewNuke;
-(void)createNewRocket;
-(void)createNewLaser;

//-(void)explosionToRemoveToYes;
//-(void)removeUnwantedExplosions;
//-(void)clearExplosionsToRemoveFromViewArray;

@property(nonatomic) NSInteger gameState;
@property(nonatomic) double gameScore;
@property(nonatomic) bool thereIsSomeBulletToRemove;
@property(nonatomic) bool thereIsSomeEnemyToRemove;

@property(nonatomic, retain) NSMutableArray * bulletsPool;
@property(nonatomic, retain) NSMutableArray * bulletsToRemoveFromView;

@property(nonatomic, retain) NSMutableArray * enemyPool;
@property(nonatomic, retain) NSMutableArray * tempEnemyPool;
@property(nonatomic, retain) NSMutableArray * enemiesToRemoveFromView;

//@property(nonatomic, retain) NSMutableArray * explosionsPool;
//@property(nonatomic, retain) NSMutableArray * tempExplosionsPool;
//@property(nonatomic, retain) NSMutableArray * explosionsToRemoveFromView;

@end
