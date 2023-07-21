#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import <React/RCTI18nUtil.h>

int main(int argc, char *argv[])
{
  @autoreleasepool {
    BOOL isAppLaunched = [[NSUserDefaults standardUserDefaults] boolForKey:@"launchedBefore"];

    if (!isAppLaunched) {
      NSMutableArray * locales = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey: @"AppleLanguages"] ];
      [locales insertObject:@"ar" atIndex:0];
      [[NSUserDefaults standardUserDefaults] setObject:locales forKey: @"AppleLanguages"];
      [[NSUserDefaults standardUserDefaults] synchronize];
      [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"launchedBefore"];
      [[RCTI18nUtil sharedInstance] allowRTL:YES];
      [[RCTI18nUtil sharedInstance] forceRTL:YES];
    }
    
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
  }
}
