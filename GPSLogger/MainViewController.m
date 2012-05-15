#import <CoreLocation/CoreLocation.h>
#import "MainViewController.h"
#import "LocationCell.h"
#import "GPXExporter.h"

@implementation MainViewController {
	BOOL isLogging;
	NSMutableArray *_locations;
	CLLocationManager *_locationManager;
@private
	NSTimer *_timer;
}
@synthesize startStopButton = _startStopButton;
@synthesize tableView = _tableView;
@synthesize clearButton = _clearButton;
@synthesize locations = _locations;
@synthesize locationManager = _locationManager;
@synthesize timer = _timer;


- (void)viewDidLoad {
	_locations = [[NSMutableArray alloc] init];
	isLogging = NO;
	self.clearButton.enabled = self.locations.count > 0;
}

- (void)viewDidUnload {
	[self setClearButton:nil];
	[super viewDidUnload];
}

- (IBAction)startStopButtonPressed:(id)sender {
	if (isLogging) {
		[self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
		isLogging = NO;
		[self.timer invalidate];
		self.timer = nil;
		self.clearButton.enabled = self.locations.count > 0;
	} else {
		[self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
		isLogging = YES;
		self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(fireTimer:) userInfo:nil repeats:YES];
		[self.timer fire];
		self.clearButton.enabled = NO;
	}
}

- (IBAction)clearButtonPressed:(id)sender {
	[_locations removeAllObjects];
	self.clearButton.enabled = self.locations.count > 0;
	[self.tableView reloadData];
}

- (IBAction)gpxButtonPressed:(id)sender {
	GPXExporter *gpxExporter = [[GPXExporter alloc] init];
	NSString *gpxString = [gpxExporter produceGPXFromLocations:self.locations];
	NSLog(@"gpxString = %@", gpxString);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
	cell.location = [self.locations objectAtIndex:(NSUInteger) indexPath.row];
	return cell;
}

- (void)fireTimer:(NSTimer *)timer {
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	[self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	[self.locationManager stopUpdatingLocation];
	self.locationManager = nil;

	CLLocation *location = [[CLLocation alloc] initWithCoordinate:newLocation.coordinate
	                                                     altitude:newLocation.altitude
			                                   horizontalAccuracy:newLocation.horizontalAccuracy
							                     verticalAccuracy:newLocation.verticalAccuracy
											            timestamp:[NSDate date]];
	[_locations insertObject:location atIndex:0];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]]
			withRowAnimation:UITableViewRowAnimationTop];
	self.clearButton.enabled = self.locations.count > 0;
}

@end
