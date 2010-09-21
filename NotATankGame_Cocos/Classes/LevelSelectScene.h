//
//  LevelSelectScene.h
//  NotATankGame_Cocos
//
//  Created by Amrit on 20/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "NotATankGame_CocosAppDelegate.h"
#import "DefineAllConstants.h"
#import "MainMenuScene.h"
#import "IntroScene.h"

#import "Level1Scene.h"
#import "Level2Scene.h"


@interface LevelSelectScene : CCLayer {
	
	CCColorLayer * pauseLayer;
	CCMenu * alertMenu;
	
	int menuState;
}

+(id) scene;
-(void)addMenuItems;
-(void)levelToChangeTo:(id)scene;
-(void)showNotUnlockedAlert;
-(void)backToSelection:(id)sender;

@end
