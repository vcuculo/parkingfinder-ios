//
//  ReleaseParkingViewController.m
//  ParkingFinder
//
//  Created by Vittorio Cuculo on 03/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReleaseParkingViewController.h"
#define ALERTVIEW_CONFIRM_TAG 100
#define ALERTVIEW_INFO_TAG 101

@interface ReleaseParkingViewController ()

@end

@implementation ReleaseParkingViewController

static NSString *const ID_KEY = @"parkingId";
static NSString *const TYPE_KEY = @"parkingType";
static NSString *const LAT_KEY = @"latitude";
static NSString *const LON_KEY = @"longitude";
static NSString *const ACC_KEY = @"accuracy";
static NSString *const PARKED_KEY = @"parked";
BOOL parked = false;
NSUserDefaults * defaults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    defaults = [NSUserDefaults standardUserDefaults];
    
    //FOR DEBUG ONLY
    
    [defaults setBool:YES forKey:PARKED_KEY];
    [defaults setDouble:45.45 forKey:LAT_KEY];
    [defaults setDouble:9.18 forKey:LON_KEY];
    //FOR DEBUG ONLY
    
    parked = [defaults boolForKey:PARKED_KEY];    
    if (parked) {
        double lat = [defaults doubleForKey:LAT_KEY];
        double lon = [defaults doubleForKey:LON_KEY];
        int parkId = [defaults integerForKey:ID_KEY];
        int accuracy = [defaults integerForKey:ACC_KEY];
        int type = [defaults integerForKey:TYPE_KEY];

        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(lat, lon);
        ParkingAnnotation *annotation = [[ParkingAnnotation alloc] initWithLocation:loc];
        
        MKAnnotationView* aView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:@"MyCustomAnnotation"] autorelease];
        [aView setImage:[UIImage imageNamed:@"  car_icon.png"]];        
        [myMap addAnnotation:aView];
        
        
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) viewDidAppear:(BOOL)animated {
    if (![Utility isOnline])
        [Utility showConnectionDialog]; 
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 1) {
        if ([alertView tag] == ALERTVIEW_CONFIRM_TAG){
            [self removeParkingInfo];
            [self showReleaseDialog];
        } else if ([alertView tag] == ALERTVIEW_INFO_TAG) {
            [self showInfoDialog];
        }
	}
    else if ([alertView tag] == ALERTVIEW_INFO_TAG) {
        
    }
}

- (IBAction)releaseParking:(id)sender{
    [self showConfirmationDialog];
}


- (void) showInfoDialog {
    ParkingInfoViewController *vc = [[ParkingInfoViewController alloc] init];
    if (parked){
        [vc setLatitude:[defaults doubleForKey:LAT_KEY] andLongitude:[defaults doubleForKey:LON_KEY] andType:[defaults integerForKey:TYPE_KEY] andAccuracy:[defaults integerForKey:ACC_KEY]];
        
    }
    else
    {
        double lat = myMap.userLocation.location.coordinate.latitude;
        double lon = myMap.userLocation.location.coordinate.longitude;
        int acc = myMap.userLocation.location.horizontalAccuracy;
        
        [vc setLatitude:lat andLongitude:lon andType:0 andAccuracy:acc];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void) showConfirmationDialog {
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Liberando un parcheggio" 
                                                    message:@"Sei sicuro di voler liberare questo parcheggio?" 
                                                   delegate:self cancelButtonTitle:@"Annulla" otherButtonTitles:@"OK", nil] autorelease];
    [alert setTag:ALERTVIEW_CONFIRM_TAG];
    [alert show];
}

- (void) showReleaseDialog {
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Liberando un parcheggio" 
                                                    message:@"Vuoi inserire informazioni riguardo il parcheggio che hai appena liberato?" 
                                                   delegate:self cancelButtonTitle:@"Annulla" otherButtonTitles:@"OK", nil] autorelease];
    [alert setTag:ALERTVIEW_INFO_TAG];
    [alert show];
}

- (void) removeParkingInfo {
    [defaults removeObjectForKey:PARKED_KEY];
    [defaults removeObjectForKey:ID_KEY];
    [defaults removeObjectForKey:TYPE_KEY];
    [defaults removeObjectForKey:LAT_KEY];
    [defaults removeObjectForKey:LON_KEY];
    [defaults removeObjectForKey:ACC_KEY];
    [defaults synchronize];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
