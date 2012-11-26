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
#import "ParkingAnnotation.h"
#import "ParkingView.h"

@implementation SearchParkingViewController

@synthesize activityView;
static BOOL isFirst=true;
static double lat=0.000000,lon=0.000000;
NSTimer *timer;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad]; 
    //http://www.theappcodeblog.com/2011/03/09/activity-indicator-tutorial/
    activityView=[[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    [activityView setFrame:self.view.frame];
    [activityView.layer setBackgroundColor:[[UIColor colorWithWhite: 0.0 alpha:0.30] CGColor]];
    activityView.center=self.view.center;
    [self.view addSubview:activityView];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [activityView startAnimating];    
    NSLog([NSString stringWithFormat:@"%f" ,myMap.userLocation.coordinate.latitude]);
    NSLog([NSString stringWithFormat:@"%f" ,myMap.userLocation.coordinate.longitude]);
    //questo serve per far fare il posizionamento e la richiesta dei parcheggi dopo il back button quando la posizione è rimasta la stessa e non viene richiamato l'apposito metodo
    if(!isFirst){
       timer=[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(requestParking) userInfo:nil repeats:YES];
       [timer fire];
       [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
       [activityView stopAnimating];
       [Utility zoomMapViewToFitAnnotations:myMap animated:YES];
    }
    
}



- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if(isFirst){
        timer=[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(requestParking) userInfo:nil repeats:YES];
        [timer fire];
        isFirst=false;     
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [activityView stopAnimating];
    [Utility zoomMapViewToFitAnnotations:myMap animated:YES];

}  






-(void) requestParking{
    
    double lat=myMap.userLocation.coordinate.latitude;
    double lon=myMap.userLocation.coordinate.longitude;
    float range=1000;
    NSString *request=[DataController marshallParkingRequest:lat andLon:lon andRange:range];
    CommunicationController *cc=[[CommunicationController alloc]initWithAction:@"searchParking"];
    NSString *response=[cc sendRequest:request];
    NSMutableArray *listParking=[DataController unMarshallParking:response];
    for(int i=0;i<[listParking count];i++){
        ParkingAnnotation *annotation=[[ParkingAnnotation alloc] initWithParking:(Parking *)[listParking objectAtIndex:i] andMyCar:FALSE];
        [myMap addAnnotation:annotation];
    }
}

//occupa la posizione senza contattare il server
-(IBAction)occupyParkingHere:(id)sender{
    UIAlertView *myAlertView=[[UIAlertView alloc] initWithTitle:@"Parking finder" message:@"Are you occuping this park" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [myAlertView show];
}

-(void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        //Scivere codice di occupazione del parcheggio
        double latitude=myMap.userLocation.coordinate.latitude;
        double longitude=myMap.userLocation.coordinate.longitude;
        
        UIAlertView *myAlertView=[[UIAlertView alloc] initWithTitle:@"Parking finder" message:@"Parking occupied" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [myAlertView show]; 
    }
    if(buttonIndex==0){
        
        NSLog(@"Ciao");
    }
}



//occupa la posizione contattando il server
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if ([view isMemberOfClass:[ParkingView class]]){
    [self sendOccupyWithParking: (ParkingAnnotation *)[view annotation]];
    UIAlertView *myAlertView=[[UIAlertView alloc] initWithTitle:@"Parking finder" message:@"Parking occupied" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [myAlertView show];
}
}

//comuncazione col server per occupare un parcheggio
-(void) sendOccupyWithParking:(ParkingAnnotation*) p{
    int identifier= [[p parking] idParking];
    
    NSString *request=[DataController marshallOccupyParking:identifier];
    CommunicationController *cc=[[CommunicationController alloc]initWithAction:@"park"];
    NSString *response=[cc sendRequest:request];
    NSLog(response);

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

- (void)dealloc
{
    lat=myMap.userLocation.coordinate.latitude;
    lon=myMap.userLocation.coordinate.longitude;
    [myMap setDelegate:nil];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        [timer invalidate];
    }
    [super viewWillDisappear:animated];
}
@end