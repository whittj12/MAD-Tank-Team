//
//  Sounds.h
//  tankPrototype_3
//
//  Created by Amrit on 14/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//#import <Foundation/Foundation.h>
//#import <AudioToolbox/AudioToolbox.h>
//#import "cocos2d.h"
//#import "CDAudioManager.h"
#import "SimpleAudioEngine.h"
#import "SynthesizeSingleton.h"

@interface Sounds : NSObject {
	
//	NSURL * soundUrl;
//	SystemSoundID soundID;
}

+(Sounds *)sharedSounds;

-(void)playMenuBGMusic;
-(void)playLevel1BGMusic;
-(void)playLevel2BGMusic;
-(void)playLaserBeamSound;
-(void)playMachineGunSound;

//@property(nonatomic, retain) NSURL * soundUrl;
//@property(nonatomic) SystemSoundID soundID;
//
//-(void)playSound;
//-(void)stopSound;

@end
