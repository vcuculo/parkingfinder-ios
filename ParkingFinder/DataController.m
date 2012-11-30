//
//  DataController.m
//  ParkingFinder
//
//  Created by Antonio Luca on 11/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataController.h"
#import "Comment.h"
@implementation DataController

+ (NSString*) marshallParking: (Parking*) p{
    NSString *lat = [NSString stringWithFormat:@"%f", [p latitude]];
    NSString *lon = [NSString stringWithFormat:@"%f", [p longitude]];
    NSString *acc = [NSString stringWithFormat:@"%f", [p accuracy]];
    NSString *type = [NSString stringWithFormat:@"%d", [p type]];
    
    int idP = [p idParking];
    NSString *c = [p comment];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:lat forKey:@"lat"];
    [dic setObject:lon forKey:@"lon"];
    [dic setObject:acc forKey:@"accuracy"];
    [dic setObject:type forKey:@"type"];
    
    if(idP > -1){
        NSString *idpString=[NSString stringWithFormat:@"%d", idP];
        [dic setObject:idpString forKey:@"id"];
    }
    if(c != nil){
        [dic setObject:c forKey:@"text"];
    }
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *jsonRequest = [writer stringWithObject:dic];
    return jsonRequest;
}

+ (NSString*) marshallParkingRequest: (double) lat andLon:(double)lon andRange:(float)range{
    
    NSString *latitude=[NSString stringWithFormat:@"%f", lat];
    NSString *longitude=[NSString stringWithFormat:@"%f", lon];
    NSString *rangeP=[NSString stringWithFormat:@"%f", range];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    [dic setObject:latitude forKey:@"lat"];
    [dic setObject:longitude forKey:@"lon"];
    [dic setObject:rangeP forKey:@"range"];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *jsonRequest = [writer stringWithObject:dic];
    return jsonRequest;
    
}

+ (NSMutableArray*) unMarshallParking:(NSString*) response{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *parkings = [parser objectWithString:response error:nil];
    NSMutableArray *jsonParking = [parkings objectForKey:@"parking"];
    NSMutableArray *parkingList = [[NSMutableArray alloc] initWithCapacity:jsonParking.count];
    Parking *parkingObject;
    for (NSDictionary *park in jsonParking){
        int idParking = [[park valueForKey:@"id"] intValue];
        double lat = [[park valueForKey:@"lat"] doubleValue];
        double lon = [[park valueForKey:@"lon"] doubleValue];
        int type = [[park valueForKey:@"type"] intValue];
        int accuracy = [[park valueForKey:@"accuracy"] intValue];
        long time = [[park valueForKey:@"date"] longValue];
        NSMutableArray *jsonComment = [park objectForKey:@"comments"];
        NSMutableArray *comments = [[NSMutableArray alloc] initWithCapacity:jsonComment.count];
        
        if([park objectForKey:@"comments"]){
            for (NSDictionary *com in jsonComment) {
                int idc = [[com valueForKey:@"comment_id"] intValue];
                NSString *text = [com valueForKey:@"text"];
                Comment *c = [[Comment alloc] initWithId:idc andText:text];
                [comments addObject:c];
            }
        }
        parkingObject = [[Parking alloc] initWithId:idParking andLat:lat andLon:lon andType:type andCom:comments andTime:time andAcc:accuracy];
        [parkingList addObject:parkingObject];

    }
    return parkingList;
}
+ (NSString*)marshallOccupyParking:(int) idParking{
    NSString *idPark = [NSString stringWithFormat:@"%d",idParking];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    [dic setObject:idPark forKey:@"id"];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *jsonRequest = [writer stringWithObject:dic];
    return jsonRequest;
}


@end
