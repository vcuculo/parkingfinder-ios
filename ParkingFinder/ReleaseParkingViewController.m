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
#define ALERTVIEW_THANKS 102

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
double lat, lon;
int parkId, accuracy, type;
NSUserDefaults * defaults;
UINavigationController *navController;
UIActivityIndicatorView * activityView;
Parking *p;

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
    
    activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    [activityView setFrame:self.view.frame];
    [activityView.layer setBackgroundColor:[[UIColor colorWithWhite: 0.0 alpha:0.30] CGColor]];
    activityView.center = self.view.center;
    [self.view addSubview:activityView];
    
    navController = self.navigationController;
    [self setTitle:NSLocalizedString(@"RELEASE_PARK",nil)];
    defaults = [NSUserDefaults standardUserDefaults];
    
    parked = [defaults boolForKey:PARKED_KEY];    
    if (parked) {
        lat = [defaults doubleForKey:LAT_KEY];
        lon = [defaults doubleForKey:LON_KEY];
        parkId = [defaults integerForKey:ID_KEY];
        accuracy = [defaults integerForKey:ACC_KEY];
        type = [defaults integerForKey:TYPE_KEY];
        
        p = [[Parking alloc] initWithId:parkId andLat:lat andLon:lon andType:type andCom:nil andAcc:accuracy];
        
        ParkingAnnotation *annotation = [[ParkingAnnotation alloc] initWithParking:p andMyCar: TRUE];
        
        [myMap addAnnotation:annotation];
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

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (myMap.userLocationVisible)
        [Utility zoomMapViewToFitAnnotations:myMap animated:YES];
    else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [activityView startAnimating];
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [activityView stopAnimating];
    [Utility zoomMapViewToFitAnnotations:myMap animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation class] == MKUserLocation.class) {
        return nil;
    }
    
    ParkingView *parkingView = (ParkingView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"parkingview"];
    
    if(parkingView == nil) {
        parkingView = [[[ParkingView alloc] initWithAnnotation:annotation reuseIdentifier:@"parkingview"] autorelease];
    }
    
    parkingView.annotation = annotation;
    
    return parkingView;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        if ([alertView tag] == ALERTVIEW_INFO_TAG){
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [activityView startAnimating];
            
            NSString *request = [DataController marshallParking:p];
            CommunicationController *cc = [[CommunicationController alloc]initWithAction:@"freePark"];
            NSString *response = [cc sendRequest:request];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [activityView stopAnimating];
            
            if ([response hasPrefix:@"error: "]){
                 UIAlertView *error = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"SERVER_ERROR", nil) message: response delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
                [error show];
            }
            else {
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"PARKING_RELEASED",nil)
                                                             message:NSLocalizedString(@"THANKS",nil) 
                                                            delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease];
                [alert setTag:ALERTVIEW_THANKS];
                [alert show];
            }
        }
        else if ([alertView tag] == ALERTVIEW_THANKS)
            [navController popViewControllerAnimated:YES];
    }
	else if (buttonIndex == 1) {
        if ([alertView tag] == ALERTVIEW_CONFIRM_TAG){
            // se confermi di liberare il posto dove sei, prendo le coordinate
            if (!parked){
                double mLat = myMap.userLocation.location.coordinate.latitude;
                double mLon = myMap.userLocation.location.coordinate.longitude;
                int mAcc = myMap.userLocation.location.horizontalAccuracy;
                p = [[Parking alloc] initWithId:-1 andLat:mLat andLon:mLon andAcc:mAcc];
            }
            
            [self removeParkingInfo];
            [self showReleaseDialog];
        } else if ([alertView tag] == ALERTVIEW_INFO_TAG)
            [self showInfoDialog];
	}
}

- (IBAction)releaseParking:(id)sender{
    [self showConfirmationDialog];
}


- (void) showInfoDialog {
    ParkingInfoViewController *vc = [[ParkingInfoViewController alloc] init];

    [vc setParking:p];
    
    [navController popViewControllerAnimated:NO];
    [navController pushViewController:vc animated:YES];
}

- (void) showConfirmationDialog {
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"FREEING_PARKING",nil)
                                                    message:NSLocalizedString(@"CONFIRM_RELEASE_PARKING",nil) 
                                                   delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL",nil) otherButtonTitles:@"OK", nil] autorelease];
    [alert setTag:ALERTVIEW_CONFIRM_TAG];
    [alert show];
}

- (void) showReleaseDialog {
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"FREEING_PARKING",nil)
                                                    message:NSLocalizedString(@"ADD_PARK_INFORMATION",nil)
                                                   delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL",nil) otherButtonTitles:@"OK", nil] autorelease];
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

- (void) dealloc {
    [myMap setDelegate:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
