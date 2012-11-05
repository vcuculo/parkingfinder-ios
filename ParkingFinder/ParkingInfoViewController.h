//
//  ParkingInfoViewController.h
//  ParkingFinder
//
//  Created by Vittorio Cuculo on 03/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface ParkingInfoViewController : UIViewController {
    IBOutlet UILabel *latLabel, *lonLabel, *typeLabel, *addressLabel;
}

- (void) setLatitude:(double)lat andLongitude:(double)lon andType:(int)type andAccuracy:(int)acc;
- (void) setAddress;
@end
