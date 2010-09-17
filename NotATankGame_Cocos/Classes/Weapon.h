//
//  Weapon.h
//  tankPrototype_3
//
//  Created by Amrit on 26/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Weapon : NSObject {
	int weaponID;
	CGPoint weaponLocation;
	CGPoint imageSize;
	CGPoint bulletVelocity;
	int damage;
	int damageRadius;
//	UIImage * image1;
//	UIImage * image2;
	bool fired;
	bool toRemove;
	bool hasSubView;
	
	NSString * image1;
	NSString * image2;
}

@property(nonatomic) bool fired;
//@property(nonatomic, retain) UIImage * image1;
//@property(nonatomic, retain) UIImage * image2;
@property(nonatomic, retain) NSString * image1;
@property(nonatomic, retain) NSString * image2;

@property(nonatomic) int weaponID;
@property(nonatomic) CGPoint weaponLocation;
@property(nonatomic) CGPoint bulletVelocity;
@property(nonatomic) CGPoint imageSize;
@property(nonatomic) int damage;
@property(nonatomic) int damageRadius;
@property(nonatomic) bool toRemove;
@property(nonatomic) bool hasSubView;

-(void)moveBulletByVelocity;
-(bool)checkIfBulletIsOutOfBounds;

@end
