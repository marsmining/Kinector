//
//  AppDelegate.m
//  Kinector
//
//  Created by foo on 8/14/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

// view controller
@synthesize controller = _controller;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSLog(@"starting app..");
    
    // create our window controller
    self.controller = [[MainWindowController alloc] init];
    
    // set color
    [self.controller.window setBackgroundColor:[NSColor orangeColor]];
    
    // display window
    [self.controller.window makeKeyAndOrderFront:self];
    
}

- (void) applicationWillTerminate:(NSNotification *)notification {
    NSLog(@"terminating app..");
    
    [self.controller stop];
}

@end
