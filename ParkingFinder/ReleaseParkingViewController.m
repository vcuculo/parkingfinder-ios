//
//  ReleaseParkingViewController.m
//  ParkingFinder
//
//  Created by Vittorio Cuculo on 03/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReleaseParkingViewController.h"

@interface ReleaseParkingViewController ()

@end

@implementation ReleaseParkingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
