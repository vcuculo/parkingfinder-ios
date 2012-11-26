//
//  SearchParkingViewController.h
//  ParkingFinder
//
//  Created by Vittorio Cuculo on 02/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Utility.h"

@interface SearchParkingViewController : UIViewController <MKMapViewDelegate>{
    IBOutlet MKMapView *myMap;
    IBOutlet UIButton *releaseButton;
    IBOutlet UIActivityIndicatorView * activityView;
    
}

-(IBAction)occupyParking:(id)sender;
-(IBAction)occupyParkingHere:(id)sender;
- (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated;
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;
@property(nonatomic,retain)  UIActivityIndicatorView * activityView;

@end
