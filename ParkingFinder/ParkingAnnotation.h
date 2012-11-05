//
//  ParkingOverlayItem.h
//  ParkingFinder
//
//  Created by Vittorio Cuculo on 04/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Parking.h"

@interface ParkingAnnotation : NSObject <MKAnnotation> {
    Parking* parking;
    BOOL mycar;
}
@property (nonatomic, retain) Parking* parking;
@property (nonatomic) BOOL mycar;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithParking:(Parking*) p andMyCar:(BOOL) m;

@end