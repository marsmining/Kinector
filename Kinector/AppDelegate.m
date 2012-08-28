//
//  AppDelegate.m
//  Kinector
//
//  Created by foo on 8/14/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#import "AppDelegate.h"

#import "Kinect.h"

@interface AppDelegate()

@property (nonatomic, strong) Kinect *kinect;

@end

@implementation AppDelegate

// view controller
@synthesize controller = _controller;

// kinect object
// @synthesize kinect = _kinect;
//
//BOOL kinectContextIsOpen = NO;
//BOOL kinectDepthIsOpen = NO;

// methods

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSLog(@"starting app..");
    
    // create our window controller
    self.controller = [[MainWindowController alloc] init];
    
    // set color
    [self.controller.window setBackgroundColor:[NSColor orangeColor]];
    
    // display window
    [self.controller.window makeKeyAndOrderFront:self];
    
    // create and init kinect object
    
    //    self.kinect = [[Kinect alloc] init];
    //    kinectContextIsOpen = [self.kinect openDevice];
    //    kinectDepthIsOpen = [self.kinect openDepth];
    
    // create draw loop
    
}

- (void) applicationWillTerminate:(NSNotification *)notification {
    NSLog(@"terminating app..");
    
//    if (kinectDepthIsOpen) {
//        NSLog(@"result from closing depth is: %d", [self.kinect closeDepth]);
//    }
//    
//    if (kinectContextIsOpen) {
//        NSLog(@"result from closing device is: %d", [self.kinect closeDevice]);
//    }
}

@end
