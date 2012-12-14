//
//  SettingsViewController.m
//  ParkingFinder
//
//  Created by Vittorio Cuculo on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

static NSString *const PREFERENCE_RANGE = @"my_range";
static NSString *const PREFERENCE_REFRESH = @"my_refresh";
static NSString *const PREFERENCE_AUDIO = @"my_audio";
static NSString *const PREFERENCE_FILTER_UNDEFINED = @"undefined";
static NSString *const PREFERENCE_FILTER_TOLL = @"toll";
static NSString *const PREFERENCE_FILTER_FREE = @"free";
static NSString *const PREFERENCE_FILTER_RESERVED = @"reserved";
static NSString *const PREFERENCE_FILTER_DISABLED = @"disabled";
static NSString *const PREFERENCE_FILTER_TIMED = @"timed";
NSMutableArray *parkingTypes;
NSUserDefaults * defaults;
NSMutableArray *checkedParkingType;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"SETTINGS_VIEW", nil)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveSettings:)];
    
    [rangeLabel setText: NSLocalizedString(@"PREFERENCE_RANGE",nil)];
    [refreshLabel setText: NSLocalizedString(@"PREFERENCE_REFRESH",nil)];
    [soundLabel setText: NSLocalizedString(@"PREFERENCE_SOUND",nil)];
    [typeLabel setText: NSLocalizedString(@"PREFERENCE_TYPE",nil)];
    
    parkingTypes = [[NSMutableArray alloc] init];
    
    [parkingTypes addObject:NSLocalizedString(@"UNDEFINED_PARKING",nil)];
    [parkingTypes addObject:NSLocalizedString(@"FREE_PARKING",nil)];
    [parkingTypes addObject:NSLocalizedString(@"TOLL_PARKING",nil)];
    [parkingTypes addObject:NSLocalizedString(@"RESIDENTS_PARKING",nil)];
    [parkingTypes addObject:NSLocalizedString(@"DISABLED_PARKING",nil)];
    [parkingTypes addObject:NSLocalizedString(@"TIMED_PARKING",nil)];
    
    defaults = [NSUserDefaults standardUserDefaults];
        
    parkingFilter.delegate = self;
    parkingFilter.dataSource = self;
}

- (void) viewDidAppear:(BOOL)animated
{
    float range = [defaults floatForKey:PREFERENCE_RANGE];
    float refresh = [defaults floatForKey: PREFERENCE_REFRESH];
    BOOL sound = [defaults boolForKey: PREFERENCE_AUDIO];
    BOOL undefined = [defaults boolForKey: PREFERENCE_FILTER_UNDEFINED];
    BOOL free = [defaults boolForKey: PREFERENCE_FILTER_FREE];
    BOOL toll = [defaults boolForKey: PREFERENCE_FILTER_TOLL];
    BOOL residents = [defaults boolForKey: PREFERENCE_FILTER_RESERVED];
    BOOL disabled = [defaults boolForKey: PREFERENCE_FILTER_DISABLED];
    BOOL timed = [defaults boolForKey: PREFERENCE_FILTER_TIMED];
    
    checkedParkingType = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:undefined], [NSNumber numberWithBool:free], [NSNumber numberWithBool:toll], [NSNumber numberWithBool:residents], [NSNumber numberWithBool:disabled], [NSNumber numberWithBool:timed], nil];
    
    [parkingFilter reloadData];
    [rangeSlider setValue:range];
    [refreshSlider setValue:refresh];
    
    [self changeRangeValue];
    [self changeRefreshValue];
    
    [audioSwitch setOn:sound];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [parkingTypes count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:path];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    cell.textLabel.text = [parkingTypes objectAtIndex:indexPath.row];
    if ([[checkedParkingType objectAtIndex:indexPath.row] boolValue] == TRUE)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    return cell;
}

- (IBAction) changeRangeValue {
    float value = round([rangeSlider value] / 100);
    [rangeValueLabel setText:[NSString stringWithFormat:@"%.0f", value * 100]];
}

- (IBAction) changeRefreshValue {
    float value = round([refreshSlider value] * 2);
    [refreshValueLabel setText:[NSString stringWithFormat:@"%.1f", value / 2]];
}

- (void)saveSettings:(id)sender{
    float range = [[rangeValueLabel text] floatValue];
    float refresh = [[refreshValueLabel text] floatValue];
    BOOL sound = [audioSwitch isOn];
    
    for (int i = 0; i < 6; i++)
        [checkedParkingType replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:[parkingFilter cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]].accessoryType == UITableViewCellAccessoryCheckmark]];
    
    [defaults setFloat:range forKey:PREFERENCE_RANGE];
    [defaults setFloat:refresh forKey:PREFERENCE_REFRESH];
    [defaults setBool:sound forKey:PREFERENCE_AUDIO];
    [defaults setBool:[[checkedParkingType objectAtIndex:0] boolValue] forKey:PREFERENCE_FILTER_UNDEFINED];
    [defaults setBool:[[checkedParkingType objectAtIndex:1] boolValue] forKey:PREFERENCE_FILTER_FREE];
    [defaults setBool:[[checkedParkingType objectAtIndex:2] boolValue] forKey:PREFERENCE_FILTER_TOLL];
    [defaults setBool:[[checkedParkingType objectAtIndex:3] boolValue] forKey:PREFERENCE_FILTER_RESERVED];
    [defaults setBool:[[checkedParkingType objectAtIndex:4] boolValue] forKey:PREFERENCE_FILTER_DISABLED];
    [defaults setBool:[[checkedParkingType objectAtIndex:5] boolValue] forKey:PREFERENCE_FILTER_TIMED];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
