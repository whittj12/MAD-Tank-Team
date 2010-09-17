//
//  GameEngine.m
//  tankPrototype_3
//
//  Created by Amrit on 27/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameEngine.h"
#import "GamePlayViewController.h"
#import "DefineAllConstants.h"


@implementation GameEngine

@synthesize gameState, gameScore, player1TankImage, bulletsPool, tempBulletPool, 
thereIsSomeBulletToRemove, bulletsToRemoveFromView,tempBulletsID,
enemyPool, tempEnemyID, enemiesToRemoveFromView, thereIsSomeEnemyToRemove,
tempEnemyPool, explosionsPool, tempExplosionsPool, explosionsToRemoveFromView;

/*
 Whichever class uses this GameEngine will create an instance of it
 and when it init's it, this method will be called to set up everything
 we want to set up before the game engine can run sucessfully
 */
-(id)init
{
	[super init];
	
	player1 = [[UserTank alloc] init];
	player1TankImage = player1.image;
	
	explosionsPool = [[NSMutableArray alloc] initWithCapacity:kMaxEnemiesAllowedOnScreen];
	tempExplosionsPool = [[NSMutableArray alloc] initWithCapacity:kMaxEnemiesAllowedOnScreen];
	explosionsToRemoveFromView = [[NSMutableArray alloc] initWithCapacity:kMaxEnemiesAllowedOnScreen];
	explosionUniqueIdentifier = 100;
	
	enemyPool = [[NSMutableArray alloc] initWithCapacity:kMaxEnemiesAllowedOnScreen];
	tempEnemyPool = [[NSMutableArray alloc] initWithCapacity:kMaxEnemiesAllowedOnScreen];
	enemiesToRemoveFromView = [[NSMutableArray alloc] initWithCapacity:kMaxEnemiesAllowedOnScreen];
	enemyUniqueIdentifier = 30000;
	
	self.gameScore = 0;
	self.gameState = kGameStatePaused;
	
	currentlySelectedWeaponID = kDefaultStarterWeapon;
	
	//for special weapons
	
	
	
	
	//for autofire machinegun bullets
	tempBulletPool = [[NSMutableArray alloc] initWithCapacity:kMaxBulletsAllowed];
	bulletsToRemoveFromView = [[NSMutableArray alloc] initWithCapacity:kMaxBulletsAllowed];
	bulletsPool = [[NSMutableArray alloc] initWithCapacity:kMaxBulletsAllowed];
	
	bulletUniqueIdentifier = 300000;
	
	howOftenToAddBullets = 0;
	howOftenToAddEnemies = 0;
	
	
	laserSound = [[Sounds alloc]init];
	
	
	return self;
}

/*
 Change what the currently selected weapon is
 Takes in an integer value
 */
-(void)changeCurrentlySelectedWeapon:(int)newWeapon
{
	currentlySelectedWeaponID = newWeapon;
}

/*
 Called by FireNewBullet method to create a new nuke before it can use it
 to add to bulelts pool
 */
-(void)createNewNuke
{
	nuke = [[Weapon alloc] init];
	nuke.damage = 100;
	nuke.damageRadius = 50;
	nuke.imageSize = CGPointMake(100, 60);
	nuke.image1 = [UIImage imageNamed:@"nukerPlane.png"];
	nuke.bulletVelocity = CGPointMake(-5, -3.5); //find out a good formula to use for y speed to make it travel 
											//perfect diagonal using kScreenHeight and kScreenWidth
											//probably can use pythagoras theory for diagonal like vector here
	nuke.weaponLocation = CGPointMake(kScreenWidthPixels-80, kScreenHeightPixels);
}

/*
 Called by FireNewBullet method to create a new rocket before it can use it
 to add to bulelts pool
 */
-(void)createNewRocket
{
	rocket = [[Weapon alloc] init];
	rocket.damage = 50;
	rocket.damageRadius = 50;
	rocket.imageSize = CGPointMake(55, 19);
	rocket.image1 = [UIImage imageNamed:@"rocket.png"];
	rocket.bulletVelocity = CGPointMake(10, 0);
}

/*
 Called by FireNewBullet method to create a new laser before it can use it
 to add to bulelts pool
 */
-(void)createNewLaser
{
	laser = [[Weapon alloc] init];
	laser.damage = 30;
	laser.damageRadius = 50;
	laser.imageSize = CGPointMake(53, 10);
	//laser.imageSize = CGPointMake(480, 10);
	laser.image1 = [UIImage imageNamed:@"laserBeam2.png"];
	laser.bulletVelocity = CGPointMake(35, 0);
}

/*
 Fire a new bullet, move all other bullets, 
 check if there are any collisions (or if any bullet goes out of bounds)
 and flag for removal if necessary, repeat same process for enemytanks
 then do some collision detection before actually removing the objects
 */
-(void)gameLoop
{
	thereIsSomeBulletToRemove = NO;
	thereIsSomeEnemyToRemove = NO;
	thereIsSomeExplosionToRemove = NO;

	/*
	 based on which weapon is selected, determine how many iterations are required of 
	 gameloop before it can be fired, its a way (not a reliable way, but a way) to give
	 each type of weapon a different reload time - though that time
	 will vary quite wildly between simulator, iphone 3g, 3gs and 4
	 */
	switch (currentlySelectedWeaponID) 
	{
		default:
		case kMachinegun:
			if(howOftenToAddBullets < kIterationsPerMachineGun)
				{
					howOftenToAddBullets++;
				}
				else 
				{
					[self fireNewBullet];
					
					howOftenToAddBullets = 0;
				}
			break;
			
		case kLasergun:
			if(howOftenToAddBullets < kIterationsPerLaser)
			{
				howOftenToAddBullets++;
			}
			else 
			{
				[self fireNewBullet];
				
				
				/*
				 Testing play laser noise
				 */
				
				[laserSound playSound];
				
				
				
				howOftenToAddBullets = 0;
			}
			break;
			
		case kRocketlauncher:
			if(howOftenToAddBullets < kIterationsPerRocket)
			{
				howOftenToAddBullets++;
			}
			else 
			{
				[self fireNewBullet];
				
				howOftenToAddBullets = 0;
			}
			break;
			
		case kNuke:
			if(howOftenToAddBullets < kIterationsPerNuke)
			{
				howOftenToAddBullets++;
			}
			else 
			{
				[self fireNewBullet];
				
				howOftenToAddBullets = 0;
			}
			break;
	}
	
	
	/*
	 NOTE Change this up later so that the speed of enemies spawning in is based on 
	 the current level (high level = less iterations per new enemy, low level = more etc.)
	 */
	if(howOftenToAddEnemies < kIterationsPerNewEnemy)
	{
		howOftenToAddEnemies++;
	}
	else 
	{
		[self addNewEnemies];
		
		howOftenToAddEnemies = 0;
	}
	
	[self moveAllBullets];
	[self moveEnemies];
	
	[self checkForCollisions];
	
	[self explosionToRemoveToYes];
	
	[self removeUnwantedEnemies];
	[self removeUnwantedBullets];
	[self removeUnwantedExplosions];
	//NSLog(@"count of bullets pool : %i", [bulletsPool count]);
	
	
	//NSLog(@"number of enemies %i", [enemyPool count]);
}

/*
 08/09/10 - Implemented collision detection with nested for-each loop
 -iterates through each bullet in the bulletspool (as long as its toRemove is not already YES) and
 then each enemy in enemiesPool (as long as toRemove not YES) and create CGRect for bullet and enemy object
 use CGRectIntersectsRect to see if either of the points of the frames intersects and if it does,
 flag the bullet for removal and remove health from tank according with damage from bullet
 
 
 It's a pretty amateur way to implement it, but it does actually run smoothly on the device
 to get the job done so for now will keep it until we actually come across 
 performance issues and need to improve something, or have finished everything else and
 moved on to performance improvement phases
 */
-(void)checkForCollisions
{
	for(Weapon *bullet in bulletsPool)
	{
		/*
		 check if that bullet/enemy is not already scheduled to be removed, if it is then that means
		 it has already collided with something or gone off screen so we dont need to waste time 
		 checking if it collides with anything else
		 also it avoids double ups in the bullets/enemies to remove from view arrays
		 */
		if(!bullet.toRemove)
		{
			for(EnemyTank *enemy in enemyPool)
			{
				if(!enemy.toRemove)
				{
					/*
					 
					 
					 
					 NOTE If this works, dont forget to apply bullet->tank damage here & remove tank only if 
					 health <= 0 , but bullet regardless (unless maybe current weapon = laser?)
					 
					 
					 
					 
					 */
					
					/*
					 
					 NOTE TRY TO IMPROVE this frame, its using ...location.x, .location.y (which are CENTER points)
					 as starting points for creating the rectangle
					 */
					
					
					/*
					 giving nuke a HUGE frame size here for bigger collision area
					 NOTE Looks UNREALISTIC AND CRAP
					 so try to improve on that later
					*/
					if(currentlySelectedWeaponID==kNuke)
					{
						bulletsFrame = CGRectMake(bullet.weaponLocation.x, bullet.weaponLocation.y,kScreenWidthPixels, kScreenHeightPixels); 
					}
					else 
					{
						bulletsFrame = CGRectMake(bullet.weaponLocation.x, bullet.weaponLocation.y, bullet.imageSize.x, bullet.imageSize.y);
					}

					enemyFrame = CGRectMake(enemy.enemyLocation.x, enemy.enemyLocation.y, enemy.imageSize.x, enemy.imageSize.y);
					
					
					if(CGRectIntersectsRect(bulletsFrame, enemyFrame))
					{
						/*
						 if the 'nuke' hits them, do not remove the nuke
						 nuke will be removed anyway once it passes the screen area,
						 while it is on screen we just want it to be sort of this super tough, 
						 invincible thing which kills everything in its way
						 */
						if(currentlySelectedWeaponID != kNuke)
						{
							bullet.toRemove = YES;
							thereIsSomeBulletToRemove = YES;
							
							tempBulletsID = [[NSNumber alloc] initWithInt:[bullet weaponID]];
							[bulletsToRemoveFromView addObject:tempBulletsID];
							[tempBulletsID release];
						}
						enemy.toRemove = YES;
						
						thereIsSomeEnemyToRemove = YES;
						
						tempBulletsID = [[NSNumber alloc] initWithInt:[enemy enemyID]];
						[enemiesToRemoveFromView addObject:tempBulletsID];
						[tempBulletsID release];
						
						
						//create an explosion at the point of this collision
						explosion1 = [[Explosions alloc] init];
						explosion1.explosionID = explosionUniqueIdentifier;
						[explosion1 setExplosionLocation:enemy.enemyLocation];
						[explosionsPool addObject:explosion1];
						
						/*
						 13/09/10 - amrit - tried using nstimer to sort out when animation is finished
						 therefore remove its relevant record from explosionspool but
						 the timer idea failed badly, after a few calls it was stressing out the
						 CPU (on device, simulator was fine), even after all those timers were closed, thats kind of dodgy!
						 i dunno whats going on but will be changing functionality of it now
						 -----------
						 create an NSTimer which will call method to set that explosionsToRemove value to
						 YES on a time period based on that explosions animation duration speed
						*/
						//[NSTimer scheduledTimerWithTimeInterval:explosion1.explosionAnimationSpeed
//														 target:self 
//													   selector:@selector(explosionToRemoveToYes:) 
//													   userInfo:[NSNumber numberWithInt:explosionUniqueIdentifier]
//														repeats:NO];
						[explosion1 release];
						explosionUniqueIdentifier++;
						
					}
				}
			}
		}
	}
}

/*
 Sets the explosions toRemove value to YES so it can be
 disposed of as necessary by the removeUnwantedExplosions method
 
 
 ---- 13/09/10 - amrit - changing the way this method works as part of an effort to fix
 issues that were causing excessive lag (on device) when using timer method
 my new way to do it is add a value in explosion instance which holds
 how many iterations it has "survived" for, after certain # iterations it will
 be flagged for removal. its still not particularly efficient because involves a big for loop through
 collection of all explosions on screen, though still better than timer i think (especially when NUKE is involved)
 */
-(void)explosionToRemoveToYes//:(NSTimer*)timer
{
	for (Explosions * explosion in explosionsPool)
	{
		if(!explosion.toRemove)
		{
			if(explosion.iterationsSurvived < explosion.iterationsForExplosionToSurvive)
			{
				explosion.iterationsSurvived++;
			}
			else 
			{
				[explosion setToRemove:YES];
				thereIsSomeExplosionToRemove = YES;
				
				tempBulletsID = [[NSNumber alloc] initWithInt:[explosion explosionID]];
				[explosionsToRemoveFromView addObject:tempBulletsID];
				//NSLog(@"count of explosions toremove from view = %i", [explosionsToRemoveFromView count]);
				[tempBulletsID release];
			}
		}

	}
	/* - old way
	for(Explosions * explosion in explosionsPool)
	{
		if(explosion.explosionID==[[timer userInfo] intValue])
		{
			[explosion setToRemove:YES];
			//NSLog(@"explosion with ID of %i is now set up properly for removal", explosion.explosionID);
		}
	}
	thereIsSomeExplosionToRemove = YES;
	[explosionsToRemoveFromView addObject:[timer userInfo]];
	//NSLog(@"last explosion to remove was : %i", [[explosionsToRemoveFromView lastObject] intValue] );
	 */
}

/*
 Remove any explosions which no longer need to be on screen
 */
-(void)removeUnwantedExplosions
{
	if(thereIsSomeExplosionToRemove)
	{
		[tempExplosionsPool removeAllObjects];
		for(Explosions * explosion in explosionsPool)
		{
			if(!explosion.toRemove)
			{
				[tempExplosionsPool addObject:explosion];
			}
		}
		[explosionsPool removeAllObjects];
		[explosionsPool addObjectsFromArray:tempExplosionsPool];
	}
}

/*
 When the games view class is done using this (to know which subviews to remove)
 it will call this method to clean up the array
 */
-(void)clearExplosionsToRemoveFromViewArray
{
	//if([explosionsToRemoveFromView count] > 0)
	//{
		[explosionsToRemoveFromView removeAllObjects];
	//}
}

/*
 If more enemies are allowed to be added (based on limit defined in constants file)
 allocate/initialise new enemy of current enemy type
 Set the new enemies Y ocation based on a random number, X location determined by constant
 but maybe this can eventually be changed too (eg if a enemy is landing on the battle zone by jumping in
 from a helicopter or something his X nor Y will likely be the same any two times in a row
 */
-(void)addNewEnemies
{
	/*
	 NOTE to self : instead of using a constant for max enemies, adjust it 
	 on a per level basis, decide on a nice formula for it and maybe set up a new class which
	 deals with levels
	 
	 BUT make sure that the value is never greater than kMaxEnemiesAllowedOnScreen
	 because this value is used to set the max value when initialising the mutablearrays
	 */
	if(! ([enemyPool count] == kMaxEnemiesAllowedOnScreen))
	{
		/*
		 
		 
		 
		 NOTE : Add switch statement here which will decide what kind of enemy to add to the pool based on
		 current enemy to spawn (might be random chance based on current level)
		 
		 
		 
		 
		 */
		
		
		enemyTankType1 = [[EnemyTank alloc]init];
		enemyTankType1.enemyID = enemyUniqueIdentifier;
		
		
		//generate random number to determine enemies "random" y position
		randomNumberForEnemyPosition = arc4random() % 10 ;
		//choose which y position to assign to this new enemyTank based on randomNumber
		double enemyTankHeight = enemyTankType1.imageSize.y;
		
		switch (randomNumberForEnemyPosition) 
		{
			case 0:
				enemyTankType1.enemyLocation = CGPointMake(kEnemySpawnPointX, enemyTankHeight);
				break;
				
			case 1:
				enemyTankType1.enemyLocation = CGPointMake(kEnemySpawnPointX, enemyTankHeight * 2);
				break;
				
			case 2:
				enemyTankType1.enemyLocation = CGPointMake(kEnemySpawnPointX, enemyTankHeight * 3);
				break;
				
			case 3:
				enemyTankType1.enemyLocation = CGPointMake(kEnemySpawnPointX, enemyTankHeight * 4);
				break;
				
			case 4:
				enemyTankType1.enemyLocation = CGPointMake(kEnemySpawnPointX, enemyTankHeight * 5);
				break;
				
			case 5:
				enemyTankType1.enemyLocation = CGPointMake(kEnemySpawnPointX, enemyTankHeight * 6);
				break;
				
			case 6:
				enemyTankType1.enemyLocation = CGPointMake(kEnemySpawnPointX, enemyTankHeight * 7);
				break;
				
			case 7:
				enemyTankType1.enemyLocation = CGPointMake(kEnemySpawnPointX, enemyTankHeight * 8);
				break;
				
			case 8:
				enemyTankType1.enemyLocation = CGPointMake(kEnemySpawnPointX, enemyTankHeight * 9);
				break;
				
			default:
				enemyTankType1.enemyLocation = CGPointMake(kEnemySpawnPointX, enemyTankHeight * 10);
				break;
		}
		
		[enemyPool addObject:enemyTankType1];
		
		[enemyTankType1 release];
		
		enemyUniqueIdentifier++;
	}
}

/*
 Move all the enemies based on their velocity vector (see each Enemy class CGPoint enemyVelocity)
 This method also helps to catch enemies which have gone out of bounds of the screen
 */
-(void)moveEnemies
{
	for(EnemyTank * enemy in enemyPool)
	{
		if([enemy isNew]) //if its a enemy which has just been added, don't move it's frame instantly
		{			
			enemy.isNew = NO;
		}
		else 
		{
			if(! [enemy toRemove]) //if its not been flagged for removal
			{
				[enemy  moveTankByVelocity];
				
				
				/*
				 NOTE : Change this bit so that once tank goes out of bounds (in X position)
				 the players towns health is decrease by the value of the enemyTanks damage
				 */
				if([enemy checkIfTankIsOutOfBounds])
				{
					thereIsSomeEnemyToRemove = YES;
					/*
					 if its to be removed, add it's enemyID to enemiesToRemoveFromView
					 so that the game view class can use this array to
					 know which enemy subviews to remove on next view update
					 ** ignore fact that the temp NSNumber object is called tempBulletsID,
					 just re-using that variable which is already declared as it's the same type
					 as what we need and it isn't being used by moveBullets() at same time as this
					 */
					tempBulletsID = [[NSNumber alloc] initWithInt:[enemy enemyID]];
					[enemiesToRemoveFromView addObject:tempBulletsID];
					[tempBulletsID release];
				}
			}
		}
	}
}

/*
 remove enemies which have been flagged for removal
 (toRemove = YES), happens when they have
 collided with a bullet or are out of the viewable screen area
 */
-(void)removeUnwantedEnemies
{
	/*
	 current solution -
	 create new temp array and add only valid objects (objects which are not flagged as to remove) 
	 to that, replace old enemiesPool with values from this new array
	 
	 Note to self : check out resource implications of this and if its not good then
	 investigate more efficient ways
	 */
	if(thereIsSomeEnemyToRemove)
	{
		[tempEnemyPool removeAllObjects];
		
		for (EnemyTank * enemy in enemyPool)
		{
			if(!enemy.toRemove)
			{
				[tempEnemyPool addObject:enemy];
			}
		}
		
		[enemyPool removeAllObjects];
		[enemyPool addObjectsFromArray:tempEnemyPool];
	}	
}


/*
 When the games view class is done using this (to know which subviews to remove)
 it will call this method to clean up the array
 */
-(void)clearEnemiesToRemoveFromViewArray
{
	//if([enemiesToRemoveFromView count] > 0)
	//{
		[enemiesToRemoveFromView removeAllObjects];
	//}
}


/*
	Add one new bullet of type of currently selected weapon to the pool of bullets currently
	in action
 */
-(void)fireNewBullet
{
	//check if there is space to add more bullets
	if(! ([bulletsPool count] == kMaxBulletsAllowed)) 
	{
		//add object based on currently selected weapon
		switch (currentlySelectedWeaponID) 
		{
			case kMachinegun:
				basicMachineGun = [[Weapon alloc]init];
				basicMachineGun.weaponID = bulletUniqueIdentifier;
				[bulletsPool addObject:basicMachineGun];
				
				[basicMachineGun release];
				
				bulletUniqueIdentifier++;
				break;
				
			case kLasergun:
				[self createNewLaser];
				laser.weaponID = bulletUniqueIdentifier;
				[bulletsPool addObject:laser];
				
				[laser release];
				
				bulletUniqueIdentifier++;
				break;
				
			case kRocketlauncher:
				[self createNewRocket];
				rocket.weaponID = bulletUniqueIdentifier;
				[bulletsPool addObject:rocket];
				
				[rocket release];
				
				bulletUniqueIdentifier++;
				break;

			case kNuke:
				[self createNewNuke];
				nuke.weaponID = bulletUniqueIdentifier;
				[bulletsPool addObject:nuke];
				
				[nuke release];
				
				bulletUniqueIdentifier++;
				break;

			default:
				NSLog(@"Panic! There is no currently selected weapon, is this possible??");
				break;
		}
	}
}

/*
 Move all the bullets based on their velocity vector (see each Weapons class CGPoint bulletVelocity)
 This method also helps to catch bullets which have gone out of bounds of the screen
 */
-(void)moveAllBullets
{	
	for(Weapon * bullets in bulletsPool)
	{
		if( ! [bullets fired]) //if its a bullet which has just been added, move it to tanks barrels location
		{			
			if(currentlySelectedWeaponID != kNuke)
			{
				bullets.weaponLocation = player1.tankLocation;
				//change bullets yLocation
			}
			bullets.fired = YES;
		}
		else 
		{
			if(! [bullets toRemove]) //if its not been flagged for removal
			{
				[bullets moveBulletByVelocity];
				
				if([bullets checkIfBulletIsOutOfBounds])
				{
					thereIsSomeBulletToRemove = YES;
					/*
					 if its to be removed, add it's weaponID to bulletsToRemoveFromView
					 so that the game view class can use this array to
					 know which bullet subviews to remove on next view update
					*/
					tempBulletsID = [[NSNumber alloc] initWithInt:[bullets weaponID]]; 
					[bulletsToRemoveFromView addObject:tempBulletsID];
					[tempBulletsID release];
				}
			}
		}
	}
}

/*
 remove bullets which have been flagged for removal
 (toRemove = YES), happens when they have
 collided with an enemy or are out of the viewable screen area
 */
-(void)removeUnwantedBullets
{	
	/*
	 current solution -
	 create new temp array and add only valid objects (objects which are not flagged as to remove) 
	 to that, replace old bulletsPool with values from this new array
	 
	 Note to self : check out resource implications of this and if its not good then
	 investigate more efficient ways
	 */
	if(thereIsSomeBulletToRemove)
	{
		[tempBulletPool removeAllObjects];
		
		for(Weapon * bullets in bulletsPool)
		{
			if(!bullets.toRemove)
			{
				[tempBulletPool addObject:bullets];
			}
		}
		
		[bulletsPool removeAllObjects];
		[bulletsPool addObjectsFromArray:tempBulletPool];
	}	
}

/*
 Increase game score, can change the value from DefineAllConstants class
 */
-(void)incrementGameScore
{
	self.gameScore = gameScore + kGameScoreIncrementValue;
}

/*
 In-between method to allow adjustment of tank health from other class
 */
-(void)setUserTankHealth:(int)newHealth
{
	player1.health = newHealth;
}

/*
 When the games view class is done using this (to know which subviews to remove)
 it will call this method to clean up the array
 */
-(void)clearBulletsToRemoveFromViewArray
{
	//if([bulletsToRemoveFromView count] > 0)
	//{
		[bulletsToRemoveFromView removeAllObjects];
	//}
}

/*
 to allow changing tanks location from game view lass
 since all user interaction will occur there
 */
-(void)setUserTankLocation:(CGPoint)newLocation
{
	player1.tankLocation = newLocation;
}

/*
 access tanks health
 */
-(int)getUserTankHealth
{
	return player1.health;
}

/*
 access tank image size so game view knows how big a frame to draw
 */
-(CGPoint)getUserTankImgSize
{
	return player1.tankImgSize;
}

/*
 access tank location so game view knows where to draw/move the tank view
 */
-(CGPoint)getUserTankLocation
{
	return player1.tankLocation;
}

/*
 This method is fired by the timer, it will in turn fire the gameLoop
 class as long as game is in running state
 */
-(void)runGameIfNotPaused
{
	if (self.gameState == kGameStateRunning)
	{
		[self gameLoop];
		
	}
}

/*
 Unpause the game
 */
-(void)unPauseGame
{
	self.gameState = kGameStateRunning;
}

/*
 Pause the game
 */
-(void)pauseGame
{
	self.gameState = kGameStatePaused;
}

-(void)dealloc
{
	[super dealloc];
	[player1TankImage release];
	
	[enemyPool release];
	[tempEnemyPool release];
	[enemiesToRemoveFromView release];
	[tempEnemyID release];
	
	[bulletsPool release];
	[tempBulletPool release];
	[bulletsToRemoveFromView release];
	[tempBulletsID release];
	
	[explosionsPool release];
	[tempExplosionsPool release];
	[explosionsToRemoveFromView release];
	
	[laserSound release];
}

@end
