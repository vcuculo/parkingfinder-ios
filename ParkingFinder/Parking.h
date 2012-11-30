//
//  Parking.h
//  ParkingFinder
//
//  Created by Antonio Luca on 11/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Comment.h"

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

-(Parking*) initWithId: (int) idP andLat:(double) lat andLon:(double) lon andAcc:(float)acc;
-(Parking*) initWithId: (int) idP andLat:(double) lat andLon:(double) lon andType:(int) t andCom:(NSMutableArray*) comms andTime:(long) ti andAcc:(float)acc;
-(Parking*) initWithLat: (double) lat andLon:(double) lon andType:(int) t andCom:(NSMutableArray*) comms andTime:(long) ti andAcc:(float)acc;
-(Parking*) initWithLat: (double) lat andLon:(double) lon andType:(int) t andCom:(NSString*) comm andAcc:(float)acc;
-(Parking*) initWithId: (int) idP andLat:(double) lat andLon:(double) lon andType:(int) t andCom:(NSString*) comm andAcc:(float)acc;
-(NSString*) getComments;

@property int idParking;
@property double latitude;
@property double longitude;
@property int type;
@property (nonatomic,retain) NSMutableArray* comments;
@property (nonatomic,retain) NSString* comment;
@property long time;
@property float accuracy;

@end