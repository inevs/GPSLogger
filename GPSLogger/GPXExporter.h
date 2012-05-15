#import <Foundation/Foundation.h>


@interface GPXExporter : NSObject
@property (nonatomic, strong) NSArray *locations;
- (NSString *)produceGPXFromLocations:(NSArray *)locations;
@end