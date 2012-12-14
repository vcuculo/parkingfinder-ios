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
#import "ParkingDetailsViewController.h"
#import "SettingsViewController.h"
#import "HelpViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SearchParkingViewController : UIViewController <MKMapViewDelegate, UIActionSheetDelegate>{
    IBOutlet MKMapView *myMap;
    IBOutlet UIButton *releaseButton;
    IBOutlet UIActivityIndicatorView * activityView;
    
}
- (void) showHelp;
- (IBAction)occupyParkingHere:(id)sender;
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;
@property(nonatomic,retain)  UIActivityIndicatorView * activityView;

@end