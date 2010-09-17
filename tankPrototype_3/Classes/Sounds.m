//
//  Sounds.m
//  tankPrototype_3
//
//  Created by Amrit on 14/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Sounds.h"


@implementation Sounds

@synthesize soundUrl, soundID;

-(id)init
{
	[super init];
	self.soundUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/laserNoise.wav", [[NSBundle mainBundle] resourcePath]]];
	
	
	
	AudioServicesCreateSystemSoundID((CFURLRef)self.soundUrl, &soundID);

	return self;
}

-(void)playSound
{
	//soundID
	//if(soundID)
	//{
		AudioServicesPlaySystemSound(soundID);
	//}
}

-(void)stopSound
{
	
}

-(void)dealloc
{
	[super dealloc];
	
	[soundUrl release];
}
@end
