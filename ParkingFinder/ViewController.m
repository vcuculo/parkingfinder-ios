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
static NSString *const PREFERENCE_AUDIO = @"my_audio";
static NSString *const PREFERENCE_RANGE = @"my_range";
static NSString *const PREFERENCE_REFRESH = @"my_refresh";
static NSString *const PREFERENCE_FILTER_UNDEFINED = @"undefined";
static NSString *const PREFERENCE_FILTER_TOLL = @"toll";
static NSString *const PREFERENCE_FILTER_FREE = @"free";
static NSString *const PREFERENCE_FILTER_RESERVED = @"reserved";
static NSString *const PREFERENCE_FILTER_DISABLED = @"disabled";
static NSString *const PREFERENCE_FILTER_TIMED = @"timed";
NSUserDefaults *defaults;

- (IBAction)searchButton:(id)sender
{
    
    BOOL parking = [defaults boolForKey:PARKED_KEY];
    
    if (parking){ //abbiamo un parcheggio memorizzato
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ACTION_DISALLOWED", nil)
                                                        message:NSLocalizedString(@"RELEASE_PARKING_FIRST" , nil)
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
    [releaseButton setTitle: NSLocalizedString(@"RELEASE_PARK",nil) forState:UIControlStateNormal];
    [searchButton setTitle: NSLocalizedString(@"SEARCH_PARK",nil) forState:UIControlStateNormal];

    
    NSDictionary* defaultValues = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithFloat:300], PREFERENCE_RANGE, [NSNumber numberWithFloat:3], PREFERENCE_REFRESH, [NSNumber numberWithBool:TRUE], PREFERENCE_AUDIO, [NSNumber numberWithBool:TRUE], PREFERENCE_FILTER_UNDEFINED, [NSNumber numberWithBool:TRUE], PREFERENCE_FILTER_FREE, [NSNumber numberWithBool:TRUE], PREFERENCE_FILTER_TOLL, [NSNumber numberWithBool:TRUE], PREFERENCE_FILTER_RESERVED, [NSNumber numberWithBool:TRUE], PREFERENCE_FILTER_DISABLED, [NSNumber numberWithBool:TRUE], PREFERENCE_FILTER_TIMED, nil]; 
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults registerDefaults:defaultValues];
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

- (void) viewDidAppear:(BOOL)animated
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    
    if (UIInterfaceOrientationIsPortrait(orientation))
        [[UIImage imageNamed:@"main_portrait.jpg"] drawInRect:self.view.bounds];
    else if (UIInterfaceOrientationIsLandscape(orientation))
        [[UIImage imageNamed:@"main_landscape.jpg"] drawInRect:self.view.bounds];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void) viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    if (![Utility isOnline])
        [Utility showConnectionDialog];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 1)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
	else
        exit(0);
}

- (void) viewWillDisappear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    UIGraphicsBeginImageContext(self.view.frame.size);
    
    if (UIInterfaceOrientationIsPortrait(fromInterfaceOrientation))
        [[UIImage imageNamed:@"main_landscape.jpg"] drawInRect:self.view.bounds];
    else if (UIInterfaceOrientationIsLandscape(fromInterfaceOrientation))
        [[UIImage imageNamed:@"main_portrait.jpg"] drawInRect:self.view.bounds];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}
@end