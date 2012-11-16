//
//  Utility.m
//  ParkingFinder
//
//  Created by Vittorio Cuculo on 02/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (BOOL) isOnline {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];  
    NetworkStatus networkStatus = [reachability currentReachabilityStatus]; 
    return !(networkStatus == NotReachable);
}

+ (void) showConnectionDialog {
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Connessione non riuscita" 
                                                     message:@"Per poter utilizzare l'applicazione è necessario essere connessi ad Internet." 
                                                    delegate:self cancelButtonTitle:@"Annulla" otherButtonTitles:@"OK", nil] autorelease];
    
    [alert show];
}

+(void) centerMap:(MKMapView *) map{
    
    CLLocationCoordinate2D locationUser;
    locationUser.latitude= map.userLocation.coordinate.latitude;
    locationUser.longitude=map.userLocation.coordinate.longitude;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.012;
    span.longitudeDelta=0.012;
    region.center=locationUser;
    [map setRegion:region animated:YES];
}
@end
