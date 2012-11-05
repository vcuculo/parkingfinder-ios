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
@end
