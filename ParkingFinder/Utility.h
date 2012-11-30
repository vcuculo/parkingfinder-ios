//
//  Utility.h
//  ParkingFinder
//
//  Created by Vittorio Cuculo on 02/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MapKit/MapKit.h>
#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360
@interface Utility : NSObject

+(BOOL) isOnline;
+(void) showConnectionDialog;
+(void) zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated;
+(void) centerMap:(MKMapView*)map;
@end