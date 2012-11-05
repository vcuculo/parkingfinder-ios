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

-(Parking *)initParking:(int)idParking anlat:(double)latitude andlon:(double)longitude andacc:(float)accuracy{
    self.idParking=idParking;
    self.latitude=latitude;
    self.longitude=longitude;
    self.accuracy=accuracy;
}

-(Parking*) initParking: (int) idParking anlat:(double) latitude andlon:(double) longitude andtype:(int) type andcom:(NSMutableArray*) comments andtime:(long) time andacc:(float)accuracy{
    self.idParking=idParking;
    self.latitude=latitude;
    self.longitude=longitude;
    self.type=type;
    self.comments=comments;
    self.accuracy=accuracy;
}

-(Parking *)initParking:(double)latitude andlon:(double)longitude andtype:(int)type andcom:(NSMutableArray *)comments andtime:(long)time andacc:(float)accuracy{
    self.latitude=latitude;
    self.longitude=longitude;
    self.type=type;
    self.comments=comments;
    self.accuracy=accuracy;
}
-(Parking *)initParking:(int)idParking anlat:(double)latitude andlon:(double)longitude andtype:(int)type andcom:(NSString *)comment andacc:(float)accuracy{
    self.idParking=idParking;
    self.latitude=latitude;
    self.longitude=longitude;
    self.type=type;
    self.comment=comment;
    self.accuracy=accuracy;
}
-(Parking *)initParking:(double)latitude andlon:(double)longitude andtype:(int)type andcom:(NSString *)comment andacc:(float)accuracy{
    self.latitude=latitude;
    self.longitude=longitude;
    self.type=type;
    self.comment=comment;
    self.accuracy=accuracy;
}

@end
