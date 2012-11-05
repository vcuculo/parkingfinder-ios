//
//  ParkingInfoViewController.m
//  ParkingFinder
//
//  Created by Vittorio Cuculo on 03/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParkingInfoViewController.h"

@interface ParkingInfoViewController ()

@end

@implementation ParkingInfoViewController

double mLat, mLon;
int mType, mAcc;
NSString* address;

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
    [self setAddress];
    [latLabel setText:[NSString stringWithFormat:@"%f",mLat]];
    [lonLabel setText:[NSString stringWithFormat:@"%f",mLon]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) setLatitude:(double)lat andLongitude:(double)lon andType:(int)type andAccuracy:(int)acc {
    mLat = lat;
    mLon = lon;
    mType = type;
    mAcc = acc;
}

- (void) setAddress {
    
    CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
    CLLocation *location = [[[CLLocation alloc] initWithLatitude:mLat longitude:mLon] autorelease];
    
    [geocoder reverseGeocodeLocation:location  completionHandler: 
     
     ^(NSArray *placemarks, NSError *error) {
         
         //Get nearby address
         
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         
         //String to hold address
         
         NSString *addressTxt = [NSString stringWithFormat:@"%@, %@" ,[placemark thoroughfare], [placemark subThoroughfare]];         
         //Set the label text to current location
         
         [addressLabel setText:addressTxt];
         
     }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
