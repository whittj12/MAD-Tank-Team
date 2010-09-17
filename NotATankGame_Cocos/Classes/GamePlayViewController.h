//
//  GamePlayViewController.h
//  tankPrototype_3
//
//  Created by Amrit on 26/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "tankPrototype_3AppDelegate.h"
#import "UserTank.h"
#import "Weapon.h"
#import "GameEngine.h"
#import "DefineAllConstants.h"
#import "EnemyTank.h"
#import "Explosions.h"

@interface GamePlayViewController : UIViewController {
	//tankPrototype_3AppDelegate * appDelegate;
	
	GameEngine * theGameEngine;
	
	UIImageView * playerTankImgView;
	
	UIImageView * tempImgView;
	
	NSArray * bulletImgArray;
	
	IBOutlet UILabel * tapToPlay;
	IBOutlet UILabel * playerScore;
	IBOutlet UILabel * enemiesKilled;
	IBOutlet UILabel * playerHealth;
	
	IBOutlet UIButton * pausePlayButton;
}

@property(nonatomic, retain) UIImageView * playerTankImgView;
@property(nonatomic, retain) UIImageView * tempImgView;

@property(nonatomic, retain) IBOutlet UILabel * tapToPlay;
@property(nonatomic, retain) IBOutlet UILabel * playerScore;
@property(nonatomic, retain) IBOutlet UILabel * enemiesKilled;
@property(nonatomic, retain) IBOutlet UILabel * playerHealth;

@property(nonatomic, retain) IBOutlet UIButton * pausePlayButton;

@property(nonatomic, retain) NSArray * bulletImgArray;


-(IBAction)changeWeaponToMachineGun;
-(IBAction)changeWeaponToNuke;
-(IBAction)changeWeaponToLaser;
-(IBAction)changeWeaponToRocket;


-(IBAction)btnBackToMenu;
-(IBAction)btnPauseGame;

-(void)drawUserTankToScreen;

-(void)gameLoop;
-(void)updateBulletsOnView;
-(void)updateView;
-(void)updateTankLocationOnView;
-(void)removeUnrequiredBulletsFromView;

-(void)updateExplosionsOnView;
-(void)removeUnrequiredExplosionsFromView;

-(void)updateEnemiesOnView;
-(void)removeUnrequiredEnemyTankFromView;

@end
