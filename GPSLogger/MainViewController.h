#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class CLLocationManager;

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong, readonly) NSArray *locations;

@property(nonatomic, strong) NSTimer *timer;

- (IBAction)startStopButtonPressed:(id)sender;

@end