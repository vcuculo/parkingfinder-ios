//
//  Parking.m
//  ParkingFinder
//
//  Created by Antonio Luca on 11/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Parking.h"

@implementation Parking

@synthesize idParking, latitude,longitude,type,comments, comment, time, accuracy;

-(Parking*) initWithId: (int) idParking andLat:(double) latitude andLon:(double) longitude andAcc:(float)accuracy{
    self.idParking=idParking;
    self.latitude=latitude;
    self.longitude=longitude;
    self.accuracy=accuracy;
}

-(Parking*) initWithId: (int) idParking andLat:(double) latitude andLon:(double) longitude andType:(int) type andCom:(NSMutableArray*) comments andTime:(long) time andAcc:(float)accuracy {
    self.idParking=idParking;
    self.latitude=latitude;
    self.longitude=longitude;
    self.type=type;
    self.comments=comments;
    self.accuracy=accuracy;
}

-(Parking*) initWithLat: (double) latitude andLon:(double) longitude andType:(int) type andCom:(NSMutableArray*) comments andTime:(long) time andAcc:(float)accuracy{
    self.latitude=latitude;
    self.longitude=longitude;
    self.type=type;
    self.comments=comments;
    self.accuracy=accuracy;
}
-(Parking*) initWithLat: (double) latitude andLon:(double) longitude andType:(int) type andCom:(NSString*) comment andAcc:(float)accuracy{
    self.idParking=idParking;
    self.latitude=latitude;
    self.longitude=longitude;
    self.type=type;
    self.comment=comment;
    self.accuracy=accuracy;
}
-(Parking*) initWithId: (int) idParking andLat:(double) latitude andLon:(double) longitude andType:(int) type andCom:(NSString*) comment andAcc:(float)accuracy{
    self.latitude=latitude;
    self.longitude=longitude;
    self.type=type;
    self.comment=comment;
    self.accuracy=accuracy;
}

@end
