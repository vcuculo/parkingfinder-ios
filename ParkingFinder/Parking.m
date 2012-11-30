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

-(Parking*) initWithId: (int) idP andLat:(double) lat andLon:(double) lon andAcc:(int)acc{
    self = [super init];
    idParking=idP;
    latitude=lat;
    longitude=lon;
    accuracy=acc;
    return self;
}

-(Parking*) initWithId: (int) idP andLat:(double) lat andLon:(double) lon andType:(int) t andCom:(NSMutableArray*) comms andTime:(long) ti andAcc:(int)acc {
    self = [super init];
    idParking=idP;
    latitude=lat;
    longitude=lon;
    type=t;
    comments=comms;
    accuracy=acc;
    return self;
}

-(Parking*) initWithLat: (double) lat andLon:(double) lon andType:(int) t andCom:(NSMutableArray*) comms andTime:(long) ti andAcc:(int)acc{
    self = [super init];
    latitude=lat;
    longitude=lon;
    type=t;
    comments=comms;
    accuracy=acc;
    return self;
}
-(Parking*) initWithLat: (double) lat andLon:(double) lon andType:(int) t andCom:(NSString*) comm andAcc:(int)acc{
    self = [super init];    
    latitude=lat;
    longitude=lon;
    type=t;
    comment=comm;
    accuracy=acc;
    return self;
}
-(Parking*) initWithId: (int) idP andLat:(double) lat andLon:(double) lon andType:(int) t andCom:(NSString*) comm andAcc:(int)acc{
    self = [super init];    
    latitude=lat;
    longitude=lon;
    type=t;
    comment=comm;
    accuracy=acc;
    return self;
}

-(NSString*) getComments{
    NSString *s = @"";
    for(Comment *c in comments){
        s = [[s stringByAppendingString:[c toString]]stringByAppendingString:@"\n"];  
    }
    NSLog(@"%@", s);
    return s;
}

@end