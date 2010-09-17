//
//  tankPrototype_3AppDelegate.h
//  tankPrototype_3
//
//  Created by Amrit on 26/08/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface tankPrototype_3AppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;

	UINavigationController * navController;
	
	UIViewController *vc1;
	UIViewController *vc2;
	UIViewController *vc3;
	UIViewController *vc4;
	UIViewController *vc5;
    
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
	
	NSArray * viewControllers;
}

-(void)changeView:(int)viewToGoTo;


@property (nonatomic, retain) IBOutlet UIWindow *window;


@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;

@end

