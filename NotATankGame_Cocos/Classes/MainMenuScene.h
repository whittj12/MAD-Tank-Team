//
//  MainMenuScene.h
//  NotATankGame_Cocos
//
//  Created by Amrit on 15/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "NotATankGame_CocosAppDelegate.h"
#import "DefineAllConstants.h"
#import "SettingsScene.h"
#import "LevelSelectScene.h"


@interface MainMenuScene : CCLayer {
		

}

-(void)addMenuItems;
+(id) scene;
-(void)replaceToLevelSelectScene;
-(void)replaceToSettingsScene;

@end
