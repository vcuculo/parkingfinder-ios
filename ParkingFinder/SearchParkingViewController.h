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
#import "ParkingAnnotation.h"
#import "ParkingView.h"

@interface SearchParkingViewController : UIViewController <MKMapViewDelegate>{
    IBOutlet MKMapView *myMap;
    IBOutlet UIButton *releaseButton;
    IBOutlet UIActivityIndicatorView * activityView;
    
}

- (IBAction)occupyParkingHere:(id)sender;
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;
- (void) showConfirmationDialogWithTag:(int) tag;
- (void) sendOccupyWithParking:(ParkingAnnotation*) p;
@property(nonatomic,retain)  UIActivityIndicatorView * activityView;

@end
