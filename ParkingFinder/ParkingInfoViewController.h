//
//  ParkingInfoViewController.h
//  ParkingFinder
//
//  Created by Vittorio Cuculo on 03/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"
#import "Parking.h"
#import "DataController.h"
#import "CommunicationController.h"
#define MAX_LENGTH 140

@interface ParkingInfoViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate, UITextFieldDelegate> {
    IBOutlet UILabel *latLabel, *lonLabel, *addressLabel, *descCommentLabel, *descTypeLabel, *descLatLabel, *descLonLabel, *descAddressLabel, *counter;
    IBOutlet UITextView *commentText;
    IBOutlet UITextField *typeText;
    NSMutableArray *parkingTypes;
}
- (void) setAddress;
- (void) setParking:(Parking*) p;
@end
