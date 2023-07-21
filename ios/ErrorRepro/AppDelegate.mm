#import "AppDelegate.h"

#import <CleverTap-iOS-SDK/CleverTap.h>
#import "CleverTapGeofencingWrapper.h"


#import <React/RCTBundleURLProvider.h>
#import <React/RCTLinkingManager.h>

#import "RNSplashScreen.h"
#import "ExpoModulesCore-Swift.h"
#import "ErrorRepro-Swift.h"

#import <Firebase.h>
#import "RNNotifications.h"
#import <CodePush/CodePush.h>
#import <RNGoogleSignin/RNGoogleSignin.h> 
#import <GoogleMaps/GoogleMaps.h>

#import <UserNotifications/UserNotifications.h>
#import "RudderCleverTapIntegration.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
#ifdef DEBUG
   [CleverTap setDebugLevel:CleverTapLogDebug];
#else
   [CleverTap setDebugLevel:CleverTapLogOff];
#endif

  [GMSServices provideAPIKey:@"test"];
  [FIRApp configure];
  
  self.moduleName = @"ErrorRepro";
  // You can add your custom initial props in the dictionary below.
  // They will be passed down to the ViewController used by React Native.
  self.initialProps = @{};

  [super application:application didFinishLaunchingWithOptions:launchOptions];
  [RNNotifications startMonitorNotifications];
  
  UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
//  center.delegate = self;
  [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge)
  completionHandler:^(BOOL granted, NSError * _Nullable error) {
    if (granted) {
      dispatch_async(dispatch_get_main_queue(), ^(void) {
          [[UIApplication sharedApplication] registerForRemoteNotifications];
          });
    }
  }];
  
  [CleverTapGeofencingWrapper CleverTapGeofencingWrapperForMonitor:launchOptions];
  
  BOOL success = [super application:application didFinishLaunchingWithOptions:launchOptions];
   
    if (success) {
      //This is where we will put the logic to get access to rootview
      UIView *rootView = self.window.rootViewController.view;
      
      rootView.backgroundColor = [UIColor whiteColor]; // change with your desired backgroundColor
   
      Dynamic *t = [Dynamic new];
      UIView *animationUIView = (UIView *)[t createAnimationViewWithRootView:rootView lottieName:@"splash"]; // change lottieName to your lottie files name
   
      // register LottieSplashScreen to RNSplashScreen
      [RNSplashScreen showLottieSplash:animationUIView inRootView:rootView];
      // casting UIView type to AnimationView type
      AnimationView *animationView = (AnimationView *) animationUIView;
      // play
      [t playWithAnimationView:animationView];
      // If you want the animation layout to be forced to remove when hide is called, use this code
      [RNSplashScreen setAnimationFinished:true];
    }
   
    return success;
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [CodePush bundleURL];
#endif
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [RNNotifications didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
  [[RudderCleverTapIntegration alloc] registeredForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  [RNNotifications didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
  completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
  [[RudderCleverTapIntegration alloc] receivedRemoteNotification:response.notification.request.content.userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
  [[RudderCleverTapIntegration alloc] receivedRemoteNotification:userInfo];
  [RNNotifications didReceiveBackgroundNotification:userInfo withCompletionHandler:completionHandler];
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options {
  if ([RNGoogleSignin application:application openURL:url options:options]) {
      return YES;
  }
  return [RCTLinkingManager application:application openURL:url options:options];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity
 restorationHandler:(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler
{
 return [RCTLinkingManager application:application
                  continueUserActivity:userActivity
                    restorationHandler:restorationHandler];
}

@end
