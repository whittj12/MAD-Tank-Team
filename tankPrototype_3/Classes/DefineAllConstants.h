//
//  DefineAllConstants.h
//  tankPrototype_3
//
//  Created by Amrit on 1/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//Game state management
#define kGameStateRunning 1
#define kGameStatePaused 2
#define kGameStateGameOver 3

/*
 Used to decide how much the score goes up by per each "click" of the gameplay timer (see kGameSpeed)
 Probably not the best way to calculate score but sure is the easiest, could possibly
 modify this value by multiplying with another value in future and performing other calculations
 to help keep it interesting.
 
 */
#define kGameScoreIncrementValue 0.05


//Used for weapon switching
#define kMachinegun 0
#define kLasergun 1
#define kRocketlauncher 2
#define kNuke 3

//which weapon is equipped by default on new games
#define kDefaultStarterWeapon kMachinegun

//For bounds management
#define kScreenWidthPixels 480
#define kScreenHeightPixels 320

/*
 Used in all collections which deal with bullets within the GameEngine class, adjusting this will let 
 you control exactly how many bullets are allowed on the screen at any point in time
 */
#define kMaxBulletsAllowed 40

/*
 Thus far (29/08/2010), whole game including game data management as well as view updating is
 controlled via a single thread (a timer inside GamePlayViewController), that timer
 uses this value for its own polling speed so changing this value not only changes view FPS but
 the entire game running speed
 */
#define kGameSpeed 1.00/30

/*
 Used in updateBulletsOnView method located in class GamePlayViewController
 This value determines how fast the alteration between the two images (animation speed)
 occurs for a bullet
 */
#define kBulletImageAnimateSpeed 0.1


/*
 An upper-limit of how many enemies will ever be allowed on screen at any one time
 */
#define kMaxEnemiesAllowedOnScreen 20

//Decide X location at which the enemy spawns (Y location is decided by a random value)
#define kEnemySpawnPointX 400


/*
 These are probably not necessary to have here, just constants used to determine how much 
 smaller compared to its original size the image will be (image.size.x / k___ImageReductionScaleFactor)
*/
#define kPlayerTankImageReductionScaleFactor 1.3
#define kEnemyTankImageReductionScaleFactor 2
#define kExplosionsImageReductionScaleFactor 2

/*
 Tanks velocity as well as the upper limit to random
 addition to each Tanks Velocity (as a way to differentiate movement of
 each tank slightly)
 */
#define kEnemyTank1Velocity 1
#define kEnemyTankXVelocityRandomMax 4


/*
 These are used sort of like "reloadtimes"
 It's not a great way to work it but it's alright
 Basically determines how many iterations through the game loop per
 each new bullet which gets fired
 */
#define kIterationsPerNuke 100
#define kIterationsPerMachineGun 2
#define kIterationsPerRocket 10
#define kIterationsPerLaser 1

//as above, for enemies
#define kIterationsPerNewEnemy 1

@interface DefineAllConstants : NSObject {

}

@end
