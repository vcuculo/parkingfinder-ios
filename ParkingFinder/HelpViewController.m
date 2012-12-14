//
//  HelpViewController.m
//  ParkingFinder
//
//  Created by Vittorio Cuculo on 12/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/* TODO : Scrollable Help
          Strings localization
 */

#import "HelpViewController.h"

@implementation HelpViewController

UINavigationItem* navItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)setNavigationItem: (UINavigationItem *) item {
    navItem = item;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [titleLabel setText: NSLocalizedString(@"HELP_TITLE",nil)];
    [label1 setText: NSLocalizedString(@"HELP_LABEL1",nil)];
    [undefinedLabel setText: NSLocalizedString(@"UNDEFINED_PARKING",nil)];
    [freeLabel setText: NSLocalizedString(@"FREE_PARKING",nil)];
    [tollLabel setText: NSLocalizedString(@"TOLL_PARKING",nil)];
    [residentsLabel setText: NSLocalizedString(@"RESIDENTS_PARKING",nil)];
    [disabledLabel setText: NSLocalizedString(@"DISABLED_PARKING",nil)];
    [timedLabel setText: NSLocalizedString(@"TIMED_PARKING",nil)];
    [label2 setText: NSLocalizedString(@"HELP_LABEL2",nil)];
    [trans1label setText: NSLocalizedString(@"HELP_TRANS1",nil)];
    [trans2label setText: NSLocalizedString(@"HELP_TRANS2",nil)];
    [trans3label setText: NSLocalizedString(@"HELP_TRANS3",nil)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)close:(id)sender{
    [navItem.rightBarButtonItem setEnabled:YES];
    [self.view removeFromSuperview];
}

@end
