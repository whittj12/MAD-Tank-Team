//
//  Weapon.m
//  tankPrototype_3
//
//  Created by Amrit on 26/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Weapon.h"
#import "DefineAllConstants.h"

@implementation Weapon
@synthesize weaponID,weaponLocation, damage, damageRadius, image1, image2, 
hasSubView,fired, toRemove, bulletVelocity, imageSize;

/*
 By default, weapon is initialised as a machinegun
 */
-(id)init
{
	[super init];
	
	self.weaponID = 0;
	
	self.damage = 10;
	self.damageRadius = 10;
	
	self.weaponLocation = CGPointMake(40, 70);
	
	self.imageSize = CGPointMake(15, 4);

	self.image1 = [NSString stringWithFormat:@"bullet1.png"];
	self.image2 = nil;
	
	self.fired = NO;
	self.toRemove = NO;
	self.hasSubView = NO;
	
	self.bulletVelocity = CGPointMake(20, 0); // (X speed, Y speed)
	
	return self;
}


-(void)setupWeaponToNuke
{
	self.damage = 100;
	self.damageRadius = 50;
	self.imageSize = CGPointMake(100, 60);
	self.image1 = [NSString stringWithFormat:@"nukerPlane.png"];
	self.bulletVelocity = CGPointMake(-5, -3.5); 
	/*
	 find out a good formula to use for y speed to make it travel 
	 perfect diagonal using kScreenHeight and kScreenWidth
	 probably can use pythagoras theory for diagonal like vector here
	 */
	self.weaponLocation = CGPointMake(kScreenWidthPixels-80, kScreenHeightPixels);
}

-(void)setupWeaponToRocket
{
	self.damage = 50;
	self.damageRadius = 50;
	self.imageSize = CGPointMake(55, 19);
	self.image1 = [NSString stringWithFormat:@"rocket.png"];
	self.bulletVelocity = CGPointMake(10, 0);
}

-(void)setupWeaponToLaserGun
{
	self.damage = 30;
	self.damageRadius = 50;
	self.imageSize = CGPointMake(53, 5);
	self.image1 = [NSString stringWithFormat:@"laserBeam2.png"];
	self.bulletVelocity = CGPointMake(35, 0);
}


/*
 Move the bullets location forward by amount defined in CGPoint bulletVelocity
 */
-(void)moveBulletByVelocity
{
	self.weaponLocation = CGPointMake(self.weaponLocation.x + self.bulletVelocity.x, self.weaponLocation.y + self.bulletVelocity.y);
}

/*
 Check if bullet has strayed off the screen
 */
-(bool)checkIfBulletIsOutOfBounds
{
	/*
	 Note : if weapons will have a Y velocity > 0 then change this to
	check if weaponLocation is lower than y = 0 or greater than kScreenHeightPixels
	 */
	if (self.weaponLocation.x > kScreenWidthPixels-80)//-80 is offset for the rightsidepanel 
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
	[image1 release];
	[image2 release];
	
	[super dealloc];
}
@end

