//
//  MainMenuViewController.m
//  tankPrototype_3
//
//  Created by Amrit on 26/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainMenuViewController.h"
#import "tankPrototype_3AppDelegate.h"

@implementation MainMenuViewController

/*
 Change to New Game View
 */
-(IBAction)btnNewGame
{	
	[appDelegate changeView:2];
}

/*
 Change to Settings View
 */
-(IBAction)btnSettings
{
	[appDelegate changeView:3];
}

/*
 Change to Instructions View
 */
-(IBAction)btnHowToPlay
{
	[appDelegate changeView:4];
}

/*
 Change to Hi-Scores View
 */
-(IBAction)btnHiScores
{
	[appDelegate changeView:5];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	appDelegate = (tankPrototype_3AppDelegate *)[[UIApplication sharedApplication] delegate];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
