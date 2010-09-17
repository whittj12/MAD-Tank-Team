//
//  Explosions.h
//  tankPrototype_3
//
//  Created by Amrit on 13/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefineAllConstants.h"

@interface Explosions : NSObject {

	int explosionID;
	CGPoint explosionLocation;
	float explosionAnimationSpeed;
	NSArray * imageArray;
//	UIImage * image1;
//	UIImage * image2;
//	UIImage * image3;
//	UIImage * image4;
	CGPoint explosionImagesSize;
	bool toRemove;
	bool hasSubView;
	int iterationsSurvived;
	int iterationsForExplosionToSurvive;
}

@property(nonatomic, retain) NSArray * imageArray;
@property(nonatomic) int explosionID;
@property(nonatomic) CGPoint explosionLocation;
@property(nonatomic) float explosionAnimationSpeed;
@property(nonatomic) CGPoint explosionImagesSize;
@property(nonatomic) bool toRemove;
@property(nonatomic) bool hasSubView;
@property(nonatomic) int iterationsSurvived;
@property(nonatomic) int iterationsForExplosionToSurvive;
//@property(nonatomic,retain) UIImage * image1;
//@property(nonatomic,retain) UIImage * image2;
//@property(nonatomic,retain) UIImage * image3;
//@property(nonatomic,retain) UIImage * image4;

@end
