//
//  ParkingInfoViewController.m
//  ParkingFinder
//
//  Created by Vittorio Cuculo on 03/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParkingInfoViewController.h"
#define ALERTVIEW_THANKS 102

@interface ParkingInfoViewController ()

@end

@implementation ParkingInfoViewController

double mLat, mLon;
int mType, mAcc;
NSString* address;
UIActionSheet* actionSheet;
UIPickerView *pickerView;
UINavigationController *navController;
UIActivityIndicatorView * activityView;
Parking *mP;

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
    
    activityView=[[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    [activityView setFrame:self.view.frame];
    [activityView.layer setBackgroundColor:[[UIColor colorWithWhite: 0.0 alpha:0.30] CGColor]];
    activityView.center=self.view.center;
    [self.view addSubview:activityView];
    
    navController = self.navigationController;
    [self setTitle:NSLocalizedString(@"PARKING_FINDER", nil)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveParking:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BACK", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(handleBack:)];
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

- (void) setParking:(Parking*) p {
    mP = p;
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
    [counter setText: [NSString stringWithFormat:@"%d",(141 - len)]];
    if (len > MAX_LENGTH) {
        textView.text = [textView.text substringToIndex:MAX_LENGTH - 1];
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)myTextField{  
    [myTextField resignFirstResponder];  

    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];

    CGRect pickerFrame, actionFrame, toolbarFrame;
    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||  self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        pickerFrame = CGRectMake(0, 30, 0, 0);
        toolbarFrame = CGRectMake(0, 0, 480, 44);
        actionFrame = CGRectMake(0, 0, 480, 365);
    }else{
        pickerFrame = CGRectMake(0, 40, 0, 0);
        toolbarFrame = CGRectMake(0, 0, 320, 44);
        actionFrame = CGRectMake(0, 0, 320, 485);
    }
    
    pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    NSInteger row = [parkingTypes indexOfObject:[myTextField text]];
    [pickerView selectRow: row inComponent:0 animated:NO];
    
    [actionSheet addSubview:pickerView];
    
    UIToolbar* pickerToolbar = [[UIToolbar alloc] initWithFrame:toolbarFrame];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(typeDoneButtonPressed:)];
    [barItems addObject:doneBtn];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(typeCancelButtonPressed:)];
    [barItems addObject:cancelBtn];
    
    [pickerToolbar setItems:barItems animated:YES];
    
    [actionSheet addSubview:pickerToolbar];
    
    [actionSheet addSubview:pickerView];
    
    [actionSheet showInView:self.view];
    
    [actionSheet setBounds:actionFrame];
        
      
}

-(void)typeDoneButtonPressed:(id)sender{
    NSInteger row = [pickerView selectedRowInComponent:0];
    typeText.text = (NSString *)[parkingTypes objectAtIndex:row];
	[actionSheet dismissWithClickedButtonIndex:1 animated:YES];
}

-(void)typeCancelButtonPressed:(id)sender{
	[actionSheet dismissWithClickedButtonIndex:1 animated:YES];
}

-(void)saveParking:(id)sender{

    
    [activityView startAnimating];
    // TODO: create parking getting values inserted from user
    NSString *request = [DataController marshallParking:mP];
    CommunicationController *cc = [[CommunicationController alloc]initWithAction:@"freePark"];
    NSString *response = [cc sendRequest:request];
    NSLog(response);
    
    [activityView stopAnimating];
    
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"PARKING_RELEASED",nil)
                                                     message:NSLocalizedString(@"THANKS",nil) 
                                                    delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease];
    [alert setTag:ALERTVIEW_THANKS];
    [alert show];
}                                   


- (void) handleBack:(id)sender
{
    [activityView startAnimating];
    
    NSString *request = [DataController marshallParking:mP];
    CommunicationController *cc = [[CommunicationController alloc]initWithAction:@"freePark"];
    NSString *response = [cc sendRequest:request];
    NSLog(response);
    
    [activityView stopAnimating];   
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"PARKING_RELEASED",nil)
                                                     message:NSLocalizedString(@"THANKS",nil) 
                                                    delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease];
    [alert setTag:ALERTVIEW_THANKS];
    [alert show];  
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == ALERTVIEW_THANKS)
            [navController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
