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

@interface Utility : NSObject
+(BOOL)isOnline;
+(void)showConnectionDialog;
+(void) centerMap:(MKMapView *) map;
@end
