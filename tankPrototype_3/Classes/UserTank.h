//
//  UserTank.h
//  tankPrototype_3
//
//  Created by Amrit on 26/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefineAllConstants.h"

@interface UserTank : NSObject 
{	
	CGPoint tankLocation;
	CGPoint tankImgSize;
	int health;
	UIImage * image;
}

@property(nonatomic) CGPoint tankLocation;
@property(nonatomic) CGPoint tankImgSize;
@property(nonatomic) int health;
@property(nonatomic, retain) UIImage * image;

@end