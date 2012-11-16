//
//  ReleaseParkingViewController.h
//  ParkingFinder
//
//  Created by Vittorio Cuculo on 03/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Utility.h"
#import "ParkingInfoViewController.h"
#import "ParkingAnnotation.h"
#import "ParkingView.h"
#import "Parking.h"

@interface ReleaseParkingViewController : UIViewController <MKMapViewDelegate>{
    IBOutlet MKMapView *myMap;
    IBOutlet UIButton *releaseButton;
}
-(IBAction)releaseParking:(id)sender;
-(void) showConfirmationDialog;
-(void) removeParkingInfo;
-(void) showReleaseDialog;
-(void) showInfoDialog;
-(MKAnnotationView *)mapView:(MKMapView *)lmapView viewForAnnotation:(id <MKAnnotation>)annotation;
@end
