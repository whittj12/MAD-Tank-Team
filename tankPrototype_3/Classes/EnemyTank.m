//
//  EnemyTank.m
//  tankPrototype_3
//
//  Created by Amrit on 27/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EnemyTank.h"


@implementation EnemyTank
@synthesize image1, enemyID, enemyLocation, imageSize, enemyVelocity,
damage, damageRadius, health, isNew, toRemove, hasSubView;

-(id)init
{
	[super init];
	
	self.enemyID = 0;
	self.enemyLocation = CGPointMake(kEnemySpawnPointX, 70);
	self.imageSize = CGPointMake(49/kEnemyTankImageReductionScaleFactor, 59/kEnemyTankImageReductionScaleFactor);

	//randomly determine each enemytanks x velocity
	double randomN = arc4random() % kEnemyTankXVelocityRandomMax;
	self.enemyVelocity = CGPointMake(-(kEnemyTank1Velocity + randomN), 0);
	self.damage = 10;
	self.damageRadius = 10;
	self.health = 40;
	self.isNew = YES;
	self.toRemove = NO;
	self.hasSubView = NO;
	
	self.image1 = [UIImage imageNamed:@"enemyTank1.png"];
	
	return self;
}

/*
 Move the tanks location by amount defined in CGPoint enemyVelocity
 */
-(void)moveTankByVelocity
{
	self.enemyLocation = CGPointMake(self.enemyLocation.x + self.enemyVelocity.x, self.enemyLocation.y + self.enemyVelocity.y);
}

/*
 Check if tank has gone off the screen
 */
-(bool)checkIfTankIsOutOfBounds
{
	if (self.enemyLocation.x < 0 || enemyLocation.y < 0 || enemyLocation.y > kScreenHeightPixels) 
	{
		self.toRemove = YES;
		
		return YES;
	}
	else 
	{
		return NO;
	}
}


-(void)dealloc
{
	[super dealloc];
	
	[image1 release];
}

@end
