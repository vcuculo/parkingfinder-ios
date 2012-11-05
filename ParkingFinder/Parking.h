//
//  Parking.h
//  ParkingFinder
//
//  Created by Antonio Luca on 11/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parking : NSObject{
    int idParking;
    double latitude;
    double longitude;
    int type;
    NSMutableArray* comments;
    NSString* comment;
    long time;
    float accuracy;
}

-(Parking*) initWithId: (int) idParking andLat:(double) latitude andLon:(double) longitude andAcc:(float)accuracy;
-(Parking*) initWithId: (int) idParking andLat:(double) latitude andLon:(double) longitude andType:(int) type andCom:(NSMutableArray*) comments andTime:(long) time andAcc:(float)accuracy;
-(Parking*) initWithLat: (double) latitude andLon:(double) longitude andType:(int) type andCom:(NSMutableArray*) comments andTime:(long) time andAcc:(float)accuracy;
-(Parking*) initWithLat: (double) latitude andLon:(double) longitude andType:(int) type andCom:(NSString*) comment andAcc:(float)accuracy;
-(Parking*) initWithId: (int) idParking andLat:(double) latitude andLon:(double) longitude andType:(int) type andCom:(NSString*) comment andAcc:(float)accuracy;

@property int idParking;
@property double latitude;
@property double longitude;
@property int type;
@property (nonatomic,retain) NSMutableArray* comments;
@property (nonatomic,retain) NSString* comment;
@property long time;
@property float accuracy;

@end
