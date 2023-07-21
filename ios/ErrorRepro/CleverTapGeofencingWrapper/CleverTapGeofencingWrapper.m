#import "CleverTapGeofencingWrapper.h"

@import CleverTapGeofence;

@implementation CleverTapGeofencingWrapper


+ (void)CleverTapGeofencingWrapperForMonitor: (NSDictionary *)launchOptions
{
  [[CleverTapGeofence monitor] startWithDidFinishLaunchingWithOptions:launchOptions];
}

@end
