//
//  DataController.m
//  ParkingFinder
//
//  Created by Antonio Luca on 11/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataController.h"

@implementation DataController

+ (NSString*) marshallParking: (Parking*) p{
    NSString *lat=[NSString stringWithFormat:@"%f", [p latitude]];
    NSString *lon=[NSString stringWithFormat:@"%f", [p longitude]];
    NSString *acc=[NSString stringWithFormat:@"%f", [p accuracy]];
    NSString *type=[NSString stringWithFormat:@"%d", [p type]];
    
    int idP=[p idParking];
    NSString *c=[p comment];
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    if(idP>-1){
        
           }
   
    NSDictionary *dictionary=[NSDictionary dictionaryWithObjectsAndKeys:idP,@"id",lat,@"lat",lon,@"lon",acc,@"accuracy",type,@"type",c,@"text", nil];
    
    
}

@end
