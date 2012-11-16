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
static int countTimer=0;
static BOOL isFirst=true;
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
   if(!isFirst){
       MKUserLocation *loc;
       CLLocationCoordinate2D *cor={myMap.userLocation.coordinate.latitude,myMap.userLocation.coordinate.longitude};
       [loc setCoordinate:cor];
       [self mapView:myMap didUpdateUserLocation:loc];
       }
    isFirst=false;
    
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    if(!isFirst) {
    if(countTimer==0){
        NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(requestParking) userInfo:nil repeats:YES];
        [timer fire];
        countTimer++;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [activityView stopAnimating];
    //[Utility centerMap:myMap];
    [self zoomMapViewToFitAnnotations:myMap animated:YES];
}
  isFirst=false;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if(countTimer==0){
        NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(requestParking) userInfo:nil repeats:YES];
        [timer fire];
        countTimer++;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [activityView stopAnimating];
    //[Utility centerMap:myMap];
    [self zoomMapViewToFitAnnotations:myMap animated:YES];
        
}  
- (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated
{ 
    NSArray *annotations = mapView.annotations;
    int count = [mapView.annotations count];
    if ( count == 0) { return; } //bail if no annotations
    
    //convert NSArray of id <MKAnnotation> into an MKCoordinateRegion that can be used to set the map size
    //can't use NSArray with MKMapPoint because MKMapPoint is not an id
    MKMapPoint points[count]; //C array of MKMapPoint struct
    for( int i=0; i<count; i++ ) //load points C array by converting coordinates to points
    {
        CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = MKMapPointForCoordinate(coordinate);
    }
    //create MKMapRect from array of MKMapPoint
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
    //convert MKCoordinateRegion from MKMapRect
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    //add padding so pins aren't scrunched on the edges
    region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    //but padding can't be bigger than the world
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
    
    //and don't zoom in stupid-close on small samples
    if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if( count == 1 )
    { 
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [mapView setRegion:region animated:animated];
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
    //NSLog(response);
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
    [myMap setDelegate:nil];
}

@end