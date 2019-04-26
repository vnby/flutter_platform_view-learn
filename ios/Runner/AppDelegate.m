// Copyright 2017, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#include "PlatformViewController.h"

@implementation AppDelegate {
  FlutterResult _flutterResult;
}

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //Initiate Notification Observer--START
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showMessageAlert:)
                                                 name:@"sendMessage"
                                               object:nil];
    //Initiate Notification Observer--END
    
  [GeneratedPluginRegistrant registerWithRegistry:self];
  FlutterViewController* controller =
  (FlutterViewController*)self.window.rootViewController;
  FlutterMethodChannel* channel =
  [FlutterMethodChannel methodChannelWithName:@"samples.flutter.io/platform_view"
                              binaryMessenger:controller];
  [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
    if ([@"switchView" isEqualToString:call.method]) {
    _flutterResult = result;
      PlatformViewController* platformViewController =
      [controller.storyboard instantiateViewControllerWithIdentifier:@"PlatformView"];
      //platformViewController.counter = ((NSNumber*)call.arguments).intValue;
      platformViewController.message = ((NSString*)call.arguments);
      platformViewController.delegate = self;
      UINavigationController* navigationController =
      [[UINavigationController alloc] initWithRootViewController:platformViewController];
      navigationController.navigationBar.topItem.title = @"Platform View";
      [controller presentViewController:navigationController animated:NO completion:nil];
     
      //Send Notification with Message from Flutter
      [self postNotification: platformViewController.message];
    } else {
      result(FlutterMethodNotImplemented);
    }
  }];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

// Function that will run when the Notification is triggered
- (void)showMessageAlert:(NSNotification *)note {
    NSString *msg = [[note userInfo] valueForKey:@"msg"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Listener:"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    NSLog(@"%@", msg);
}

- (void)didUpdateCounter:(int)counter {
  _flutterResult([NSNumber numberWithInt:counter]);
}

//Function for sending Notification
-(void) postNotification:(NSString*)message {
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSString stringWithString:message] forKey:@"msg"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendMessage"
                                                        object:self
                                                      userInfo:dict];
}

- (void) sendMessage: (NSString*)message {
    _flutterResult([NSString stringWithString:message]);
}

@end
