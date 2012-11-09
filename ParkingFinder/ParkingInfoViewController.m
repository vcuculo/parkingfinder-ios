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
    
    parkingTypes = [[NSMutableArray alloc] init];
    [parkingTypes addObject: NSLocalizedString(@"UNDEFINED_PARKING",nil)];
    [parkingTypes addObject: NSLocalizedString(@"FREE_PARKING",nil)];
    [parkingTypes addObject: NSLocalizedString(@"TOLL_PARKING",nil)];
    [parkingTypes addObject: NSLocalizedString(@"RESIDENTS_PARKING",nil)];
    [parkingTypes addObject: NSLocalizedString(@"DISABLED_PARKING",nil)];
    [parkingTypes addObject: NSLocalizedString(@"TIMED_PARKING",nil)];
    
    [commentText.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [commentText.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [commentText.layer setBorderWidth: 1.0];
    [commentText.layer setCornerRadius:8.0f];
    [commentText.layer setMasksToBounds:YES];
    
    [latLabel setText:[NSString stringWithFormat:@"%f",mLat]];
    [lonLabel setText:[NSString stringWithFormat:@"%f",mLon]];
    [typeText setText: [parkingTypes objectAtIndex: mType]];
    typeText.inputView = typePicker;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
         
         if (error){
             NSLog(@"Geocode failed with error: %@", error);            
             return;
         }
         
         if(placemarks && placemarks.count > 0){

             //Get nearby address
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
         
             //String to hold address
             NSString *addressTxt = [NSString stringWithFormat:@"%@, %@" ,[placemark thoroughfare], [placemark subThoroughfare]];         
         
             //Set the label text to current location
             [addressLabel setText:addressTxt];
         }
         
     }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [parkingTypes count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [parkingTypes objectAtIndex:row];
}


-(IBAction)showTypePicker:(id)sender {
    UIToolbar*  mypickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    mypickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [mypickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked)];
    [barItems addObject:doneBtn];
    
    [mypickerToolbar setItems:barItems animated:YES];
    
    typeText.inputAccessoryView = mypickerToolbar;
    
    [typePicker setHidden:FALSE];
}

-(void)pickerDoneClicked

{
    [typeText resignFirstResponder];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    typeText.text = (NSString *)[parkingTypes objectAtIndex:row];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
