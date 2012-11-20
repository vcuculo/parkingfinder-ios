//
//  CommunicationController.m
//  ParkingFinder
//
//  Created by Antonio Luca on 11/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommunicationController.h"

@implementation CommunicationController

NSString *protocol = @"http";
int port = 80;
NSString *service = @"geoparking";
NSString *server = @"parking.findu.pl";

-(CommunicationController*) initWithAction: (NSString*) action{
    NSString *url=[[[[[[protocol stringByAppendingString:@"://"] stringByAppendingString:server] stringByAppendingString:@"/"] stringByAppendingString:service]stringByAppendingString:@"/"] stringByAppendingString:action ];
    NSURL *serverURL = [NSURL URLWithString:url];
    urlRequest = [NSMutableURLRequest requestWithURL:serverURL];
    [urlRequest setHTTPMethod: @"POST"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setTimeoutInterval:10.0];
    return self;
}

- (NSString*)sendRequest: (NSString*) data{
    NSHTTPURLResponse *responseFromServer;
    [urlRequest setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&responseFromServer error:&error];
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    return response;
}
@end
