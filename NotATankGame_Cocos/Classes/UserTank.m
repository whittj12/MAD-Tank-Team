//
//  UserTank.m
//  tankPrototype_3
//
//  Created by Amrit on 26/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UserTank.h"


@implementation UserTank

@synthesize health, tankLocation, image1, tankImgSize;

-(id)init
{
	[super init];
	//self.image = [UIImage imageNamed:@"playerTank.png"];
	image1 = [NSString stringWithFormat:@"playerTank.png"];
	self.health = 400;
	self.tankLocation = CGPointMake(40, 70);
	self.tankImgSize = CGPointMake(49/kPlayerTankImageReductionScaleFactor, 59/kPlayerTankImageReductionScaleFactor);
	
	return self;
}


-(void)dealloc{
	[super dealloc];
	
	[image1 release];
}

@end

