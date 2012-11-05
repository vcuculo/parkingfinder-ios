//
//  SearchParkingViewController.h
//  ParkingFinder
//
//  Created by Vittorio Cuculo on 02/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Utility.h"

@interface SearchParkingViewController : UIViewController <MKMapViewDelegate>{
    IBOutlet MKMapView *myMap;
    IBOutlet UIButton *releaseButton;
}
@end
