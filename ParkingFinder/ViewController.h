//
//  ViewController.h
//  ParkingFinder
//
//  Created by Vittorio Cuculo on 02/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h> 
#import "SearchParkingViewController.h"
#import "ReleaseParkingViewController.h"
#import "Utility.h"

@interface ViewController : UIViewController{
    IBOutlet UIButton *searchButton;
    IBOutlet UIButton *releaseButton;
}

- (IBAction)searchButton:(id)sender;
- (IBAction)releaseButton:(id)sender;

@end
