//
//  tankPrototype_3AppDelegate.m
//  tankPrototype_3
//
//  Created by Amrit on 26/08/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "tankPrototype_3AppDelegate.h"
#import "MainMenuViewController.h"
#import "GamePlayViewController.h"
#import "SettingsViewController.h"
#import "HowToPlayViewController.h"
#import "HiScoresViewController.h"


@implementation tankPrototype_3AppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

/*
 App has launched and loaded, set up view controllers and so on
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{    	
	//create the view controllers
	vc1 = [[MainMenuViewController alloc] init];
	vc2 = [[GamePlayViewController alloc] init];
	vc3 = [[SettingsViewController alloc] init];
	vc4 = [[HowToPlayViewController alloc] init];
	vc5 = [[HiScoresViewController alloc] init];
	
	viewControllers = [NSArray arrayWithObjects:vc1, vc2, vc3, vc4, vc5,nil];
	
	//attach them to the tab bar controller
	[navController setViewControllers:viewControllers];
	
	navController = [[UINavigationController alloc]initWithRootViewController:vc1];
	[window addSubview:[navController view]];
	
	//colour the nav bar as that default light blueish look doesnt suit this app
	navController.navigationBar.tintColor = [UIColor blackColor]; 
	
	[window makeKeyAndVisible];
	
	return YES;
}

/*
 Caters for navigation through the navigation controller
 */
-(void)changeView:(int)viewToGoTo
{
	if (navController.navigationBar.hidden && viewToGoTo !=2) {
		[navController setNavigationBarHidden:NO];
	}
	if (viewToGoTo==1) {
		//[navController pushViewController:vc1 animated:YES
		[navController popToRootViewControllerAnimated:YES];
	}
	else if (viewToGoTo==2) {
		[navController pushViewController:vc2 animated:YES];
		[navController setNavigationBarHidden:YES];
	}
	else if (viewToGoTo==3) {
		[navController pushViewController:vc3 animated:YES];
	}
	else if (viewToGoTo==4) {
		[navController pushViewController:vc4 animated:YES];
	}
	else if (viewToGoTo==5) {
		[navController pushViewController:vc5 animated:YES];
	}
}


/*
 Haven't been able to trigger this event yet in simulator
 but it might be useful in future
 */
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	NSLog(@"resigning active");
}

/*
 When user presses home button, this is triggered, 
 so do what needs to be done in that case
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	NSLog(@"gonna go to background");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    
    NSError *error = nil;
    if (managedObjectContext_ != nil) {
        if ([managedObjectContext_ hasChanges] && ![managedObjectContext_ save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"tankPrototype_3" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"tankPrototype_3.sqlite"]];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator_;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

/*
 Do some memory management research and try to find some cool stuff to do here
 */
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    
    [managedObjectContext_ release];
    [managedObjectModel_ release];
    [persistentStoreCoordinator_ release];
    
	[navController release];
	
    [window release];
    [super dealloc];
	
	[vc1 release];
	[vc2 release];
	[vc3 release];
	[vc4 release];
	[vc5 release];
	
	[viewControllers release];
}


@end

