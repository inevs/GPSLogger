#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>

@class CLLocationManager;

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong, readonly) NSArray *locations;

- (IBAction)startStopButtonPressed:(id)sender;
- (IBAction)clearButtonPressed:(id)sender;
- (IBAction)gpxButtonPressed:(id)sender;

@end
