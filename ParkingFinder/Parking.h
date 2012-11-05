//
//  Parking.h
//  ParkingFinder
//
//  Created by Antonio Luca on 11/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parking : NSObject{
    int id;
    double latitude;
    double longitude;
    int type;
    NSMutableArray* comments;
    NSString* comment;
    long time;
    float accuracy;
}

-(Parking*) initParking: (int) id anlat:(double) latitude andlon:(double) longitude andacc:(float)accuracy;
-(Parking*) initParking: (int) id anlat:(double) latitude andlon:(double) longitude andtype:(int) type andcom:(NSMutableArray*) comments andtime:(long) time andacc:(float)accuracy;
-(Parking*) initParking: (double) latitude andlon:(double) longitude andtype:(int) type andcom:(NSMutableArray*) comments andtime:(long) time andacc:(float)accuracy;
-(Parking*) initParking: (double) latitude andlon:(double) longitude andtype:(int) type andcom:(NSString*) comment andacc:(float)accuracy;
-(Parking*) initParking: (int) id anlat:(double) latitude andlon:(double) longitude andtype:(int) type andcom:(NSString*) comment andacc:(float)accuracy;

@property int id;
@property double latitude;
@property double longitude;
@property int type;
@property (nonatomic,retain) NSMutableArray* comments;
@property (nonatomic,retain) NSString* comment;
@property long time;
@property float accuracy;

@end
