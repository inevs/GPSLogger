#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import "MainViewController.h"
#import "LocationCell.h"
#import "GPXExporter.h"

@implementation MainViewController {
	BOOL isLogging;
	NSMutableArray *_locations;
	CLLocationManager *_locationManager;
}
@synthesize startStopButton = _startStopButton;
@synthesize tableView = _tableView;
@synthesize clearButton = _clearButton;
@synthesize locations = _locations;
@synthesize locationManager = _locationManager;


- (void)viewDidLoad {
	NSError *error;
	NSURL *path = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
	                                                     inDomain:NSUserDomainMask
			                                    appropriateForURL:nil create:YES error:&error];
	if (!path) {
		NSLog(@"error = %@", [error localizedDescription]);
	}

	_locations = [NSMutableArray arrayWithContentsOfURL:path];
	if (!_locations) {
		_locations = [[NSMutableArray alloc] init];
	}
	isLogging = NO;
	self.clearButton.enabled = self.locations.count > 0;

	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
}

- (IBAction)startStopButtonPressed:(id)sender {
	if (isLogging) {
		[self.locationManager stopMonitoringSignificantLocationChanges];

		[self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
		isLogging = NO;

		self.clearButton.enabled = self.locations.count > 0;
	} else {
		[self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
		isLogging = YES;

		[self.locationManager startMonitoringSignificantLocationChanges];

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
	if ([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
		NSData *gpxData = [gpxString dataUsingEncoding:NSUTF8StringEncoding];
		[mailComposeViewController addAttachmentData:gpxData mimeType:@"text" fileName:@"locations.gpx"];
		[mailComposeViewController setMessageBody:@"meine Locations" isHTML:NO];
		[mailComposeViewController setSubject:@"Locations"];
		mailComposeViewController.mailComposeDelegate = self;
		[self presentModalViewController:mailComposeViewController animated:YES];
	}
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[self dismissModalViewControllerAnimated:YES];
	NSLog(@"result = %d", result);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
	cell.location = [self.locations objectAtIndex:(NSUInteger) indexPath.row];
	return cell;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	CLLocation *location = [[CLLocation alloc] initWithCoordinate:newLocation.coordinate
	                                                     altitude:newLocation.altitude
			                                   horizontalAccuracy:newLocation.horizontalAccuracy
							                     verticalAccuracy:newLocation.verticalAccuracy
											            timestamp:[NSDate date]];
	[_locations insertObject:location atIndex:0];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]]
			withRowAnimation:UITableViewRowAnimationTop];
	self.clearButton.enabled = self.locations.count > 0;

	[self.locations writeToFile:@"locations" atomically:YES];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"error = %@", [error localizedDescription]);
}


@end
