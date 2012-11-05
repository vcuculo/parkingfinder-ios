//
//  ParkingOverlayView.h
//  ParkingFinder
//
//  Created by Vittorio Cuculo on 04/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "ParkingAnnotation.h"

@interface ParkingView : MKAnnotationView {
    ParkingAnnotation* parking;
}

@end
