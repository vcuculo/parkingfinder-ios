//
//  ParkingDetailsViewController.h
//  ParkingFinder
//
//  Created by Antonio Luca on 11/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parking.h"
#import "NSDate+TimeAgo.h"
#import "DataController.h"
#import "CommunicationController.h"

@interface ParkingDetailsViewController : UIViewController
{
    Parking *parking;
    IBOutlet UILabel *lat, *lon, *free;
    IBOutlet UITextView *comments;
}

-(id) initWithParking: (Parking *) p;
-(void) sendOccupyRequest;
@end
