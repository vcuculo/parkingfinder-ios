//
//  ViewController.m
//  ParkingFinder
//
//  Created by Vittorio Cuculo on 02/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

static NSString *const PARKED_KEY = @"parked";

- (IBAction)searchButton:(id)sender
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL parking = [defaults boolForKey:PARKED_KEY];
    
    if (parking){ //abbiamo un parcheggio memorizzato
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ACTION_DISALLOWED" 
                                                        message:@"RELEASE_PARKING_FIRST" 
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        
    } else {
        SearchParkingViewController *mapView = [[[SearchParkingViewController alloc] init] autorelease];
        [[self navigationController] pushViewController: mapView animated:YES];
    }
}

- (IBAction)releaseButton:(id)sender
{
    
    ReleaseParkingViewController *mapView = [[[ReleaseParkingViewController alloc] init] autorelease];
    [[self navigationController] pushViewController:mapView animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    if (![Utility isOnline])
        [Utility showConnectionDialog];    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
	} else {
        exit(0);
	}
}

- (void) viewWillDisappear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

@end
