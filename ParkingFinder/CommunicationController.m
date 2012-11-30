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
NSString *service = @"geoparking";
NSString *server = @"parking.findu.pl";
int port = 80;

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
    NSError *error = nil;
    
    [urlRequest setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&responseFromServer error:&error];
    
    if (error)
        return [@"error: " stringByAppendingString:[NSString stringWithFormat:@"%d", [error code]]];
                
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    return response;
}
@end
