//
//  ParkingDetailsViewController.m
//  ParkingFinder
//
//  Created by Antonio Luca on 11/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParkingDetailsViewController.h"

#define ALERTVIEW_OCCUPYPARKING_TAG 100
#define ALERTVIEW_CONFIRM_TAG 101

@implementation ParkingDetailsViewController

NSUserDefaults * defaults;
static NSString *const ID_KEY = @"parkingId";
static NSString *const TYPE_KEY = @"parkingType";
static NSString *const LAT_KEY = @"latitude";
static NSString *const LON_KEY = @"longitude";
static NSString *const ACC_KEY = @"accuracy";
static NSString *const PARKED_KEY = @"parked";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [descLatLabel setText: NSLocalizedString(@"LATITUDE",nil)];
    [descLonLabel setText: NSLocalizedString(@"LONGITUDE",nil)];
    [descFreeLabel setText: NSLocalizedString(@"FREE",nil)];
    [descCommentLabel setText: NSLocalizedString(@"COMMENTS",nil)];
    
    NSArray *types = [NSArray arrayWithObjects:NSLocalizedString(@"UNDEFINED_PARKING", nil), NSLocalizedString(@"FREE_PARKING", nil), NSLocalizedString(@"TOLL_PARKING", nil), NSLocalizedString(@"RESIDENTS_PARKING", nil), NSLocalizedString(@"DISABLED_PARKING", nil), NSLocalizedString(@"TIMED_PARKING", nil), nil];
    
    [self setTitle: [types objectAtIndex:[parking type]]];
    
    [lat setText:[NSString stringWithFormat:@"%f", [parking latitude]]];
    [lon setText:[NSString stringWithFormat:@"%f", [parking longitude]]];
    
    NSDate *freeSince = [NSDate dateWithTimeIntervalSinceNow:([parking time] / 1000)];
    
    [free setText:[freeSince timeAgo]];
    [comments setText:[parking getComments]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"OCCUPY", nil) style:UIBarButtonItemStyleDone target:self action:@selector(occupyParking)];
}

-(void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    defaults = [NSUserDefaults standardUserDefaults];
    
    if(buttonIndex == 1){
        [self sendOccupyRequest];
        [defaults setInteger:[parking idParking] forKey:ID_KEY];
        [defaults setInteger:[parking type] forKey:TYPE_KEY];
        [defaults setDouble:[parking latitude] forKey:LAT_KEY];
        [defaults setDouble:[parking longitude] forKey:LON_KEY];
        [defaults setInteger:[parking accuracy] forKey:ACC_KEY];
        [defaults setBool:TRUE forKey:PARKED_KEY];
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Parking finder" message:@"Parking occupied" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [myAlertView setTag:ALERTVIEW_CONFIRM_TAG];
        [myAlertView show]; 
    }
    if([alertView tag]== ALERTVIEW_CONFIRM_TAG && buttonIndex == 0){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

//comuncazione col server per occupare un parcheggio
-(void) sendOccupyRequest{
    int identifier = [parking idParking];
    
    NSString *request=[DataController marshallOccupyParking:identifier];
    CommunicationController *cc=[[CommunicationController alloc]initWithAction:@"park"];
    [cc sendRequest:request];
}

- (void) occupyParking {
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"OCCUPY_PARKING",nil)
                                                     message:NSLocalizedString(@"CONFIRM_OCCUPY_PARKING",nil) 
                                                    delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL",nil) otherButtonTitles:@"OK", nil] autorelease];
    [alert show];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) setParking: (Parking *) p{
    parking = p;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end