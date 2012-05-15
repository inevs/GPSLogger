#import <CoreLocation/CoreLocation.h>
#import "GPXExporter.h"


@implementation GPXExporter {
	NSArray *_locations;
}
@synthesize locations = _locations;


- (NSString *)produceGPXFromLocations:(NSArray *)locations {
	NSMutableString *gpx = [[NSMutableString alloc] init];
	[gpx appendString:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\" ?>\n"
			                  "\n"
			                  "<gpx xmlns=\"http://www.topografix.com/GPX/1/1\" creator=\"GPXLogger\" version=\"1.1\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd\">\n"];
	[gpx appendString:@"<trk>\n"
			                  "    <name>Example GPX Document</name>\n"
			                  "<trkseg>"];

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	[locations enumerateObjectsUsingBlock:^(CLLocation *location, NSUInteger index, BOOL *stop) {
		NSString *timestamp = [dateFormatter stringFromDate:location.timestamp];
		[gpx appendFormat:@"<trkpt lat=\"%1.6f\" lon=\"%1.6f\">\n"
				                  "        <ele>%1.2f</ele>\n"
				                  "        <time>%@</time>\n"
				                  "      </trkpt>", location.coordinate.latitude, location.coordinate.longitude,
						location.altitude, timestamp];
		NSLog(@"location.timestamp = %@", location.timestamp);
	}];

	[gpx appendString:@"</trkseg>"];
	[gpx appendString:@"</trk>"];
	[gpx appendString:@"</gpx>"];
	return gpx;
}
@end