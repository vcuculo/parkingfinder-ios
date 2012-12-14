//
//  HelpViewController.h
//  ParkingFinder
//
//  Created by Vittorio Cuculo on 12/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController
{
    IBOutlet UILabel *titleLabel, *label1, *undefinedLabel, *freeLabel, *tollLabel, *residentsLabel, *disabledLabel, *timedLabel, *label2, *trans1label, *trans2label, *trans3label;
}
- (IBAction)close:(id)sender;
- (void)setNavigationItem: (UINavigationItem *) item;
@end
