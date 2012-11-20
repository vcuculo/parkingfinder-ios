//
//  DataController.h
//  ParkingFinder
//
//  Created by Antonio Luca on 11/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parking.h"
#import "SBJson.h"
@interface DataController : NSObject

+ (NSString*) marshallParking: (Parking*) p;
+ (NSString*) marshallParkingRequest: (double) lat andLon:(double)lon andRange:(float)range;
+ (NSMutableArray*) unMarshallParking:(NSString*) response;
+ (NSString*)marshallOccupyParking:(int) idParking;


@end
