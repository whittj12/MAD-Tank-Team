//
//  Explosions.m
//  tankPrototype_3
//
//  Created by Amrit on 13/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Explosions.h"


@implementation Explosions
@synthesize explosionID, explosionLocation, explosionAnimationSpeed, explosionImagesSize,
toRemove, hasSubView, iterationsSurvived, iterationsForExplosionToSurvive, imageArray;//image1, image2, image3, image4;

-(id)init
{
	[super init];
	
	self.explosionID=0;
	self.explosionLocation = CGPointMake(100, 100);
	self.explosionAnimationSpeed=0.3;
	self.explosionImagesSize = CGPointMake(88/kExplosionsImageReductionScaleFactor, 76/kExplosionsImageReductionScaleFactor);
	self.imageArray  = [[NSArray alloc] initWithObjects:
						[UIImage imageNamed:@"explosion1-1.png"],
							 [UIImage imageNamed:@"explosion1-2.png"],
							 [UIImage imageNamed:@"explosion1-3.png"],
							 [UIImage imageNamed:@"explosion1-4.png"],
							 nil];
//	self.image1 = [UIImage imageNamed:@"explosion1-1.png"];
//	self.image2 = [UIImage imageNamed:@"explosion1-2.png"];
//	self.image3 = [UIImage imageNamed:@"explosion1-3.png"];
//	self.image4 = [UIImage imageNamed:@"explosion1-4.png"];
	self.toRemove = NO;
	self.hasSubView = NO;
	self.iterationsSurvived=0;
	self.iterationsForExplosionToSurvive = 10;
	return self;
}


-(void)dealloc
{

//	[image1 release];
//	[image2 release];
//	[image3 release];
//	[image4 release];
	[imageArray release];
	[super dealloc];
}

@end
