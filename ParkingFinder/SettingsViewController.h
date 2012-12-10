//
//  SettingsViewController.h
//  ParkingFinder
//
//  Created by Vittorio Cuculo on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UILabel *rangeLabel, *refreshLabel, *soundLabel, *typeLabel, *rangeValueLabel, *refreshValueLabel;
    IBOutlet UITableView *parkingFilter;
    IBOutlet UISlider *rangeSlider, *refreshSlider;
    IBOutlet UISwitch *audioSwitch;
}
- (void)saveSettings:(id)sender;
- (IBAction) changeRangeValue;
- (IBAction) changeRefreshValue;

@end
