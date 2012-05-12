#import <Foundation/Foundation.h>

@class Location;

@interface LocationCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *timeStampLabel;
@property (nonatomic, weak) IBOutlet UILabel *longitudeLabel;
@property (nonatomic, weak) IBOutlet UILabel *latitudeLabel;
@property(nonatomic, strong) CLLocation *location;
@end
