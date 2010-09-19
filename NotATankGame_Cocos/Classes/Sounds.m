//
//  Sounds.m
//  tankPrototype_3
//
//  Created by Amrit on 14/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Sounds.h"


@implementation Sounds

-(id)init
{
	[super init];
//	self.soundUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/laserNoise.wav", [[NSBundle mainBundle] resourcePath]]];
//	AudioServicesCreateSystemSoundID((CFURLRef)self.soundUrl, &soundID);
	
	[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.4f];

	return self;
}

-(void)playLaserBeamSound
{
	[[SimpleAudioEngine sharedEngine] playEffect:@"drip.wav"];//play a sound
}


-(void)playMachineGunSound
{
	[[SimpleAudioEngine sharedEngine] playEffect:@"gunshot4.wav"];//play a sound
}
-(void)playLevel1BGMusic
{
	/*
	 
	 
	 THIS SOUND IS TOO LARGE, NEED TO RECORD SHORT SOUND AND LOOP IT
	 SO IT USES LESS SPACE + TAKES LESS TIME TO LOAD AND USE LESS RAM ETC. ETC.!!!
	 
	 */
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"BGMusic.mp3" loop:TRUE];//play background music
	[CDAudioManager sharedManager].backgroundMusic.volume = 0.9f;
}


//-(void)playSound
//{
//	//soundID
//	//if(soundID)
//	//{
//		AudioServicesPlaySystemSound(soundID);
//	//}
//}
//
//-(void)stopSound
//{
//	
//}

-(void)dealloc
{
	
	
	[super dealloc];
}
@end
