//
//  CommunicationController.h
//  ParkingFinder
//
//  Created by Antonio Luca on 11/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunicationController : NSObject

+ (NSMutableURLRequest*) prepareURLforAction: (NSString*) action;
+ (NSString*)sendRequest: (NSString*) data;
@end
