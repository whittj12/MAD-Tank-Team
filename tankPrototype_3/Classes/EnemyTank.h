//
//  EnemyTank.h
//  tankPrototype_3
//
//  Created by Amrit on 27/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefineAllConstants.h"


@interface EnemyTank : NSObject {
	int enemyID;
	CGPoint enemyLocation;
	CGPoint imageSize;
	CGPoint enemyVelocity;
	int damage;
	int damageRadius; //not used yet
	int health;
	bool isNew;
	bool toRemove;
	bool hasSubView;
	
	UIImage * image1;
}

@property(nonatomic, retain) UIImage * image1;

@property(nonatomic) int enemyID;
@property(nonatomic) CGPoint enemyLocation;
@property(nonatomic) CGPoint imageSize;
@property(nonatomic) CGPoint enemyVelocity;
@property(nonatomic) int damage;
@property(nonatomic) int damageRadius;
@property(nonatomic) int health;
@property(nonatomic) bool isNew;
@property(nonatomic) bool toRemove;
@property(nonatomic) bool hasSubView;

-(void)moveTankByVelocity;
-(bool)checkIfTankIsOutOfBounds;

@end
