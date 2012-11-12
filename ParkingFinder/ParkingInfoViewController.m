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
UIActionSheet* actionSheet;
UIPickerView *pickerView;

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
    [self setTitle:NSLocalizedString(@"PARKING_FINDER", nil)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveParking:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    
    [self setAddress];
    
    parkingTypes = [[NSMutableArray alloc] init];
    [parkingTypes addObject: NSLocalizedString(@"UNDEFINED_PARKING",nil)];
    [parkingTypes addObject: NSLocalizedString(@"FREE_PARKING",nil)];
    [parkingTypes addObject: NSLocalizedString(@"TOLL_PARKING",nil)];
    [parkingTypes addObject: NSLocalizedString(@"RESIDENTS_PARKING",nil)];
    [parkingTypes addObject: NSLocalizedString(@"DISABLED_PARKING",nil)];
    [parkingTypes addObject: NSLocalizedString(@"TIMED_PARKING",nil)];
    
    [descLatLabel setText: NSLocalizedString(@"LATITUDE",nil)];
    [descLonLabel setText: NSLocalizedString(@"LONGITUDE",nil)];
    [descTypeLabel setText: NSLocalizedString(@"TYPE",nil)];
    [descAddressLabel setText: NSLocalizedString(@"ADDRESS",nil)];
    [descCommentLabel setText: NSLocalizedString(@"COMMENT",nil)];
    
    [commentText.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [commentText.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [commentText.layer setBorderWidth: 1.0];
    [commentText.layer setCornerRadius:8.0f];
    [commentText.layer setMasksToBounds:YES];
    
    [latLabel setText:[NSString stringWithFormat:@"%f",mLat]];
    [lonLabel setText:[NSString stringWithFormat:@"%f",mLon]];
    [typeText setText: [parkingTypes objectAtIndex: mType]];
    
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


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSInteger len = [textView.text length] ;
    [counter setText: [NSString stringWithFormat:@"%d",(140 - len)]];
    if (len > MAX_LENGTH) {
        textView.text = [textView.text substringToIndex:MAX_LENGTH-1];
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)myTextField{  
    [myTextField resignFirstResponder];  

    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    NSInteger row = [parkingTypes indexOfObject:[myTextField text]];
    [pickerView selectRow: row inComponent:0 animated:NO];
    
    [actionSheet addSubview:pickerView];
    
    UIToolbar* pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    [barItems addObject:doneBtn];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
    [barItems addObject:cancelBtn];
    
    [pickerToolbar setItems:barItems animated:YES];
    
    [actionSheet addSubview:pickerToolbar];
    
    [actionSheet addSubview:pickerView];
    
    [actionSheet showInView:self.view];
    
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
      
}

-(void)doneButtonPressed:(id)sender{
    NSInteger row = [pickerView selectedRowInComponent:0];
    typeText.text = (NSString *)[parkingTypes objectAtIndex:row];
	[actionSheet dismissWithClickedButtonIndex:1 animated:YES];
}

-(void)cancelButtonPressed:(id)sender{
	[actionSheet dismissWithClickedButtonIndex:1 animated:YES];
}

-(void)saveParking:(id)sender{
}                                   

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
