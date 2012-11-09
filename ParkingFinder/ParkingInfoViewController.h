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

@interface ParkingInfoViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    IBOutlet UILabel *latLabel, *lonLabel, *addressLabel;
    IBOutlet UITextView *commentText;
    IBOutlet UITextField *typeText;
    IBOutlet UIPickerView *typePicker;
    NSMutableArray *parkingTypes;
}
- (IBAction)showTypePicker:(id)sender;
- (void) setLatitude:(double)lat andLongitude:(double)lon andType:(int)type andAccuracy:(int)acc;
- (void) setAddress;
@end
