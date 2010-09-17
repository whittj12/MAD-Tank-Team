//
//  GamePlayViewController.m
//  tankPrototype_3
//
//  Created by Amrit on 26/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GamePlayViewController.h"
#import "tankPrototype_3AppDelegate.h"

@implementation GamePlayViewController

@synthesize playerTankImgView, tempImgView, 
tapToPlay, playerScore, enemiesKilled, playerHealth,
pausePlayButton, bulletImgArray;

/*
 Once the view has loaded from nib file, this we get to here and
 we can initialise all important objects we need here as well as set up gameplay timer
 */
- (void)viewDidLoad {
    [super viewDidLoad];
	
	appDelegate = (tankPrototype_3AppDelegate *)[[UIApplication sharedApplication] delegate];
	theGameEngine = [[GameEngine alloc] init]; //our single instance of the GameEngine class

	[self drawUserTankToScreen]; //draw tank to screen
	
	//timer to control gameloop in engine and update view here, adjust speed via DefineAllConstants class
	[NSTimer scheduledTimerWithTimeInterval:kGameSpeed target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
}

/*
 Draw the players tank to the screen according to data provided from the game engine class
 */
-(void)drawUserTankToScreen
{
	playerTankImgView = [[UIImageView alloc] initWithFrame:CGRectMake([theGameEngine getUserTankLocation].x, [theGameEngine getUserTankLocation].y, 
																	  [theGameEngine getUserTankImgSize].x, [theGameEngine getUserTankImgSize].y)];
	playerTankImgView.image = theGameEngine.player1TankImage;
	playerTankImgView.center = [theGameEngine getUserTankLocation];
	[self.view addSubview:playerTankImgView];
	[playerTankImgView release];
}

/*
 The basic loop which the view controller goes through,
 it invokes the gameLoop method in the game engines instance and when that is done
 it updates the view based on data which is in the game engine (what bullet/enemy is where)
 */
-(void) gameLoop
{
	[theGameEngine runGameIfNotPaused];
	
	[self updateView];
}

/*
 This method is called by gameLoop here once the gameEngine has finished
 its game data management tasks for this iteration of the timer
 This method will now simply make sure all that data is shown correctly on screen
 */
-(void)updateView
{
	if (theGameEngine.gameState == kGameStateRunning)
	{
		[theGameEngine incrementGameScore]; //see DefineAllConstants kGameScoreIncrementValue to adjust scoring system
		//update score and player tank health info to screen
		playerScore.text = [NSString stringWithFormat:@"%.02f", theGameEngine.gameScore];
		playerHealth.text = [NSString stringWithFormat:@"%i", [theGameEngine getUserTankHealth]];
		
		[self updateTankLocationOnView];
		[self removeUnrequiredBulletsFromView];
		[self updateBulletsOnView];
		
		[self updateEnemiesOnView];
		[self removeUnrequiredEnemyTankFromView];
		
		[self updateExplosionsOnView];
		[self removeUnrequiredExplosionsFromView];
	}
}

/*
 Remove any subviews which we no longer required (bullet no longer exists etc.)
 */
-(void)removeUnrequiredBulletsFromView
{
	for(NSNumber * bulletID in [theGameEngine bulletsToRemoveFromView])
	{
		[[self.view viewWithTag:[bulletID intValue]] removeFromSuperview];
		//NSLog(@"subview with tag of %i has been removed", [bulletID intValue]);
		//NSLog(@"number of views = %i", [[self.view subviews] count]);
	}
	[theGameEngine clearBulletsToRemoveFromViewArray];
}

/*
 If an enemy has died or gone off screen, we should also remove
 the subview he is using
 */
-(void)removeUnrequiredEnemyTankFromView
{
	for(NSNumber * enemyID in [theGameEngine enemiesToRemoveFromView])
	{
		[[self.view viewWithTag:[enemyID intValue]] removeFromSuperview];
	}
	[theGameEngine clearEnemiesToRemoveFromViewArray];
}


/*
 Update the location of Enemy objects on the screen
 */
-(void)updateEnemiesOnView
{
	for (EnemyTank * enemy in [theGameEngine enemyPool]) 
	{
		if(enemy.hasSubView) //if enemy has already got a view associated with it
		{
			for(UIView * subView in [self.view subviews])
			{
				if(subView.tag == enemy.enemyID)
				{
					subView.center = enemy.enemyLocation;
				}
			}
		}
		else //create new imageview for this enemy
		{
			tempImgView = [[UIImageView alloc] initWithFrame:CGRectMake(enemy.enemyLocation.x , enemy.enemyLocation.y, 
																		enemy.imageSize.x, enemy.imageSize.y)];
			tempImgView.tag = enemy.enemyID;
			tempImgView.center = enemy.enemyLocation;
			tempImgView.image = enemy.image1;
			[self.view addSubview:tempImgView];
			
			enemy.hasSubView = YES;
			[tempImgView release];
		}
	}
}


/*
 Make sure all the bullets which are in gameEngine are drawn to the correct place,
 if a bullet is already associated with an imageview, it will just move that view,
 if it is a new bullet, it will create a new subview for that bullet
 */
-(void)updateBulletsOnView
{	
	for(Weapon * bullet in [theGameEngine bulletsPool])
	{
		if(bullet.hasSubView) //if bullet has already got a view associated with it
		{
			for(UIView * subView in [self.view subviews]) //find subview which corresponds to this bullet
			{
				if (subView.tag == bullet.weaponID)
				{
					subView.center = bullet.weaponLocation;
				}
			}
		}
		else //create new imageview for this bullet
		{
			tempImgView = [[UIImageView alloc]initWithFrame:CGRectMake(bullet.weaponLocation.x, bullet.weaponLocation.y, 
																					 bullet.imageSize.x,bullet.imageSize.y)];
			/*
			 testing animating the bullet, if it is too laggy on real iphone then 
			 simply use : tempImgView.image = bullet.image1; for single image, though looks way better animated
			 */
			//bulletImgArray = [[NSArray alloc] initWithObjects:
//										bullet.image1,
//										bullet.image2,
//										nil];
//			tempImgView.animationImages = bulletImgArray;
//			tempImgView.animationDuration=kBulletImageAnimateSpeed;
//			[tempImgView startAnimating];
			tempImgView.image = bullet.image1;
			tempImgView.tag = bullet.weaponID;
			tempImgView.center = bullet.weaponLocation;
			[self.view addSubview:tempImgView];
			
			bullet.hasSubView = YES;
			
			//[bulletImgArray release];
			[tempImgView release];	
			
			//make sure playertank is on top of this bullet so it looks like bullet is coming out of the tank barrel
			[self.view bringSubviewToFront:playerTankImgView];
		}
	}	
}

/*
 make sure all explosions which are meant to be displayed are displayed at the correct place
 */
-(void)updateExplosionsOnView
{
	for(Explosions * explosion in [theGameEngine explosionsPool])
	{
		if(!explosion.hasSubView) //if explosion isn't already a view on the screen
		{
			//create new subview for it
			tempImgView = [[UIImageView alloc] initWithFrame:CGRectMake(explosion.explosionLocation.x, explosion.explosionLocation.y,
																		explosion.explosionImagesSize.x, explosion.explosionImagesSize.y)];
			
			
			tempImgView.animationImages = explosion.imageArray;
//			NSArray * tempExplosionArray = [[NSArray alloc] initWithObjects:
//										   explosion.image1,
//										   explosion.image2,
//										   explosion.image3,
//										   explosion.image4,
//										   nil];
			[[explosion imageArray] release];
//			tempImgView.animationImages = tempExplosionArray;
//			[tempExplosionArray release];
//			
			tempImgView.animationDuration = explosion.explosionAnimationSpeed;
			[tempImgView startAnimating];
			//tempImgView.image = explosion.image1;
			tempImgView.tag = explosion.explosionID;
			tempImgView.center = explosion.explosionLocation;
			//13/09/10 - had to disable transperancy on it because it was causing lag :(
			//14/09/10 - ITS BACK!! works without lag and looks great!
			tempImgView.alpha = 0.5;
			[self.view addSubview:tempImgView];
			[tempImgView release];
			
			[explosion setHasSubView:YES];
		}
	}
}

/*
 remove any unrequired explosions from the view
 */
-(void)removeUnrequiredExplosionsFromView
{
	for(NSNumber * explosionID in [theGameEngine explosionsToRemoveFromView])
	{
		[[self.view viewWithTag:[explosionID intValue]] removeFromSuperview];
	}
	[theGameEngine clearExplosionsToRemoveFromViewArray];
}

/*
 Toggle pause
 */
-(IBAction)btnPauseGame
{
	if (theGameEngine.gameState == kGameStateRunning) {
		[theGameEngine pauseGame];
		tapToPlay.hidden = NO;
		[pausePlayButton setImage:[UIImage imageNamed:@"playBtn.png"] forState:normal];
	}
	else if (theGameEngine.gameState == kGameStatePaused)
	{
		[theGameEngine unPauseGame];
		tapToPlay.hidden = YES;
		[pausePlayButton setImage:[UIImage imageNamed:@"pauseBtn.png"] forState:normal];
	}
}

/*
 Pause game and go back to Main Menu,
 in future might also wish to implement a call to save game at this point
 */
-(IBAction)btnBackToMenu
{	
	[appDelegate changeView:1];
	if (theGameEngine.gameState == kGameStateRunning) 
	{
		[theGameEngine pauseGame];
		tapToPlay.hidden = NO;
	}
}

/*
 if game state currently paused, once you receive a touch here, that means 
 that the player has officially "tapped to play" so we can hide/remove 
 that label and change state to running
 also if it was already running then send details of that touch to touchesmoved method
 so that we can deal with moving the tank to the y co-ordinate of users touch
 */
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//NSLog(@"i got to this part %i", theGameEngine.gameState);
	if (theGameEngine.gameState == kGameStatePaused) {
		//NSLog(@"i made it here too");
		tapToPlay.hidden = YES;
		[theGameEngine unPauseGame];
		//change label text to make it more relevant for next time game is paused
		tapToPlay.text = [NSString stringWithFormat:@"Tap To Continue"];
		
		[pausePlayButton setImage:[UIImage imageNamed:@"pauseBtn.png"] forState:normal];
	}
	else if (theGameEngine.gameState == kGameStateRunning)
	{
		[self touchesMoved:touches withEvent:event];
	}
}



/*
 Receives details of a users touch from touchesBegan and
 manipulates them as required, in this case, to tell the engine
 where the user wants to move the tank to
 */
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch * touch = [[event allTouches]anyObject];
	CGPoint location = [touch locationInView:touch.view];
	CGPoint yLocation = CGPointMake([theGameEngine getUserTankLocation].x, location.y);

	[theGameEngine setUserTankLocation:yLocation];
}

/*
 Read the tanks location in game engine and display accordingly on the gameplay view
 */
-(void)updateTankLocationOnView
{
	playerTankImgView.center = [theGameEngine getUserTankLocation];
}

/*
 Enabling support for Landscape orientation... with Home button on the right
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

/*
 Handle what happens here when system fires a memory warning
 */
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

/*
 Still trying to figure out in what instance this method will be called because so far I
 have not been able to view that little NSLog I have entered in method
 */
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	//try to release all those UIimages/imageviews etc. in here  maybe??
	NSLog(@"this view (gameplayviewcontroller) unloaded, try to figure out what to release here");
	
}

/*
 Tell the game engine that the user wants to fire machinegun bullets
 */
-(IBAction)changeWeaponToMachineGun
{
	[theGameEngine changeCurrentlySelectedWeapon:kMachinegun];
}

/*
 Tell the game engine that the user wants to fire nukes
 */
-(IBAction)changeWeaponToNuke
{
	[theGameEngine changeCurrentlySelectedWeapon:kNuke];
}


/*
 Tell the game engine that the user wants to fire a lasergun
 */
-(IBAction)changeWeaponToLaser
{
	[theGameEngine changeCurrentlySelectedWeapon:kLasergun];
}

/*
 Tell the game engine that the user wants to fire rockets
 */
-(IBAction)changeWeaponToRocket
{
	[theGameEngine changeCurrentlySelectedWeapon:kRocketlauncher];	
}

- (void)dealloc {
    [super dealloc];
	
	[playerTankImgView release];
	
	[tapToPlay release];
	[playerScore release];
	[enemiesKilled release];
	[playerHealth release];
	
	[pausePlayButton release];
}


@end
