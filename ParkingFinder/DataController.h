//
//  DataController.h
//  ParkingFinder
//
//  Created by Antonio Luca on 11/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataController : NSObject

+ (NSString*) marshallParking: (Parking*) action;
+ (NSString*) marshallParkingRequest: (double) lat andLon:(double)lon andRange:(float)range;
+ (NSMutableArray*) unMarshallParking:(String*) response;
+(NSString*)marshallOccuoyParking:(int) id;


@end
