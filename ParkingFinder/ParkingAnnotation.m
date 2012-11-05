//
//  ParkingOverlayItem.m
//  ParkingFinder
//
//  Created by Vittorio Cuculo on 04/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParkingAnnotation.h"

@implementation ParkingAnnotation

@synthesize parking;

- (id)initWithParking:(Parking*)p{
    self = [super init];
    
    if (self) {
        parking = p;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coord = {[parking latitude], [parking longitude]};
    return coord;
}
@end