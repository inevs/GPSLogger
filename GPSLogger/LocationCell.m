#import <CoreLocation/CoreLocation.h>
#import "LocationCell.h"

@implementation LocationCell {
	__weak UILabel *_timeStampLabel;
	__weak UILabel *_longitudeLabel;
	__weak UILabel *_latitudeLabel;
	CLLocation *_location;
}

@synthesize timeStampLabel = _timeStampLabel;
@synthesize longitudeLabel = _longitudeLabel;
@synthesize latitudeLabel = _latitudeLabel;
@synthesize location = _location;

- (void)setLocation:(CLLocation *)location {
	_location = location;
	_timeStampLabel.text = [NSDateFormatter localizedStringFromDate:location.timestamp
														  dateStyle:NSDateFormatterMediumStyle
														  timeStyle:NSDateFormatterMediumStyle];
	_longitudeLabel.text = [NSString stringWithFormat:@"%1.4f", location.coordinate.longitude];
	_latitudeLabel.text = [NSString stringWithFormat:@"%1.4f", location.coordinate.latitude];
}

@end
