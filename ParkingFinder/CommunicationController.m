//
//  CommunicationController.m
//  ParkingFinder
//
//  Created by Antonio Luca on 11/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommunicationController.h"

@implementation CommunicationController


static NSString *protocol=@"http";
static int port=80;
static NSString *service=@"geoparking";
static NSString *server = @"parking.findu.pl";
static NSMutableURLRequest* urlRequest;
static NSString* response;

+ (NSMutableURLRequest*) prepareURLforAction: (NSString*) action{
    NSString *url=[[[[[[protocol stringByAppendingString:@"://"] stringByAppendingString:server] stringByAppendingString:@"/"] stringByAppendingString:service]stringByAppendingString:@"/"] stringByAppendingString:action ];
    NSURL *serverURL = [NSURL URLWithString:url];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:serverURL];
    [urlRequest setHTTPMethod: @"POST"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setTimeoutInterval:10.0];
    return urlRequest;
}

+ (NSString*)sendRequest: (NSString*) data{
    NSHTTPURLResponse *responseFromServer;
    [urlRequest setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&responseFromServer error:&error];
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    return response;
}
@end
