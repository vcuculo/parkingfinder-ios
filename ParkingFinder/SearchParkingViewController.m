//
//  SearchParkingViewController.m
//  ParkingFinder
//
//  Created by Vittorio Cuculo on 02/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchParkingViewController.h"
#import "DataController.h"
#import "CommunicationController.h"

#define ALERTVIEW_OCCUPYPOSITION_TAG 101
#define ALERTVIEW_CONFIRM_TAG 102

@implementation SearchParkingViewController

@synthesize activityView; 
static BOOL isFirst = true;
ParkingAnnotation *pA;
Parking *ptemp;
NSTimer *timer;
NSUserDefaults * defaults;
static NSString *const ID_KEY = @"parkingId";
static NSString *const TYPE_KEY = @"parkingType";
static NSString *const LAT_KEY = @"latitude";
static NSString *const LON_KEY = @"longitude";
static NSString *const ACC_KEY = @"accuracy";
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad]; 
    //http://www.theappcodeblog.com/2011/03/09/activity-indicator-tutorial/
    activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    [self.view addSubview:activityView];
    [self setTitle:NSLocalizedString(@"SEARCH_PARKING", nil)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showMenu)];
    
    [activityView setFrame: self.view.frame];
    [activityView setCenter: self.view.center];
    [activityView.layer setBackgroundColor:[[UIColor colorWithWhite: 0.0 alpha:0.30] CGColor]];
    
    defaults = [NSUserDefaults standardUserDefaults];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void) showMenu
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"CENTER", nil), NSLocalizedString(@"OPTIONS", nil), NSLocalizedString(@"HELP", nil), NSLocalizedString(@"EXIT", nil), nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionSheet showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{

    switch (buttonIndex) {
        case 0:
            [Utility centerMap:myMap];
            break;
        case 1:
            ;
            SettingsViewController *vc = [[SettingsViewController alloc] init];
            [[self navigationController] pushViewController:vc animated:YES];
            break;
        case 2:
            [self showHelp];
            break;
        case 3:
            exit(0);
        default:
            break;
    }
}

- (void) viewDidAppear:(BOOL)animated {
    if (![Utility isOnline])
        [Utility showConnectionDialog];
    [self showHelp];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    float refresh = [defaults floatForKey:PREFERENCE_REFRESH] * 60;
    
    // usato per avviare il timer al momento giusto
    if (myMap.userLocationVisible){
        [Utility centerMap: myMap];
        timer = [NSTimer scheduledTimerWithTimeInterval:refresh target:self selector:@selector(requestParking) userInfo:nil repeats:YES];
        [timer fire];
        isFirst = false;
    } else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [activityView startAnimating];
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if(isFirst){
        float refresh = [defaults floatForKey:PREFERENCE_REFRESH] * 60;
        timer = [NSTimer scheduledTimerWithTimeInterval:refresh target:self selector:@selector(requestParking) userInfo:nil repeats:YES];
        [timer fire];
        isFirst = false;     
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [activityView stopAnimating];
    [Utility centerMap: myMap];
}  

- (void) requestParking{
    BOOL sound = [defaults boolForKey: PREFERENCE_AUDIO];
    float range = [defaults floatForKey:PREFERENCE_RANGE];

    double lat = myMap.userLocation.coordinate.latitude;
    double lon = myMap.userLocation.coordinate.longitude;

    NSString *request = [DataController marshallParkingRequest:lat andLon:lon andRange:range];
    CommunicationController *cc = [[CommunicationController alloc]initWithAction:@"searchParking"];
    NSString *response = [cc sendRequest:request];
    NSMutableArray *listParking = [DataController unMarshallParking:response];
    int sizeParking = [myMap.annotations count];
    
    [myMap removeAnnotations:myMap.annotations];
    
    for(int i = 0 ;i < [listParking count];i++){
        Parking *p = [listParking objectAtIndex:i];       
        ParkingAnnotation *annotation = [[ParkingAnnotation alloc] initWithParking:(Parking *)p andMyCar:FALSE];
        
        switch ([p type]) {
            case 1:
                if ([defaults boolForKey: PREFERENCE_FILTER_FREE])
                    [myMap addAnnotation:annotation];
                break;
            case 2:
                if ([defaults boolForKey: PREFERENCE_FILTER_TOLL])
                    [myMap addAnnotation:annotation];
                break;
            case 3:
                if ([defaults boolForKey: PREFERENCE_FILTER_RESERVED])
                    [myMap addAnnotation:annotation];
                break;
            case 4:
                if ([defaults boolForKey: PREFERENCE_FILTER_DISABLED])
                    [myMap addAnnotation:annotation];
                break;
            case 5:
                if ([defaults boolForKey: PREFERENCE_FILTER_TIMED])
                    [myMap addAnnotation:annotation];
                break;
            default:
                if ([defaults boolForKey: PREFERENCE_FILTER_UNDEFINED])
                    [myMap addAnnotation:annotation];
                break;
            }
    }
    if([listParking count] > sizeParking && sound){
        SystemSoundID soundID;
        NSString *soundFile = [[NSBundle mainBundle]pathForResource:@"button-14" ofType:@"wav"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundFile], &soundID);
        AudioServicesPlayAlertSound(soundID);
    }
        
}

//occupa la posizione senza contattare il server
-(IBAction)occupyParkingHere:(id)sender{
    ptemp = [[Parking alloc] initWithId:-1 andLat:myMap.userLocation.location.coordinate.latitude andLon:myMap.userLocation.location.coordinate.longitude andAcc:myMap.userLocation.location.horizontalAccuracy];
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"OCCUPY_PARKING",nil)
                                                     message:NSLocalizedString(@"CONFIRM_OCCUPY_PARKING",nil) 
                                                    delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL",nil) otherButtonTitles:@"OK", nil] autorelease];
    [alert show];
}

-(void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        [defaults setInteger:[ptemp idParking] forKey:ID_KEY];
        [defaults setDouble:[ptemp latitude] forKey:LAT_KEY];
        [defaults setDouble:[ptemp longitude] forKey:LON_KEY];
        [defaults setInteger:[ptemp accuracy] forKey:ACC_KEY];
        [defaults setBool:TRUE forKey:PARKED_KEY];
        
        UIAlertView *myAlertView=[[UIAlertView alloc] initWithTitle:@"Parking finder" message:@"Parking occupied" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [myAlertView setTag:ALERTVIEW_CONFIRM_TAG];
        [myAlertView show]; 
    }
    if([alertView tag] == ALERTVIEW_CONFIRM_TAG && buttonIndex == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//occupa la posizione contattando il server
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if ([view isMemberOfClass:[ParkingView class]]){
        
        pA = (ParkingAnnotation*) [view annotation];
        ptemp = [pA parking];
        
        ParkingDetailsViewController *pDetails = [[ParkingDetailsViewController alloc] init];
        [pDetails setParking: ptemp];
        [[self navigationController] pushViewController: pDetails animated:YES];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation class] == MKUserLocation.class)
        return nil;
    
    ParkingView *parkingView = (ParkingView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"parkingview"];
    
    if(parkingView == nil)
        parkingView = [[[ParkingView alloc] initWithAnnotation:annotation reuseIdentifier:@"parkingview"] autorelease];
    
    parkingView.annotation = annotation;
    
    return parkingView;
}

- (void)dealloc
{
    [myMap setDelegate:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        [timer invalidate];
    }
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([self.navigationItem.rightBarButtonItem isEnabled])
        return YES;
    else
        return NO;
}

- (void) showHelp{
    HelpViewController *helpView = [[HelpViewController alloc] init];
    [helpView setNavigationItem:self.navigationItem];
    helpView.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview: helpView.view];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [activityView setFrame: self.view.frame];
    [activityView setCenter: self.view.center];
    [activityView.layer setBackgroundColor:[[UIColor colorWithWhite: 0.0 alpha:0.30] CGColor]];
}

@end