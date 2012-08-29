//
//  MainWindowController.m
//  Altnect
//
//  Created by foo on 8/28/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#import "MainWindowController.h"

/**
 * Coordinates all objects lifecycle and activities.
 */
@implementation MainWindowController

// our gl view
@synthesize glView = _glView;

// kinect instance
@synthesize kinect = _kinect;

BOOL kinectContextIsOpen = NO;
BOOL kinectDepthIsOpen = NO;

- (id) init
{
    self = [super initWithWindowNibName:@"MainWindow"];
    
    if (self) {        
        
        // create and init kinect object
        
        //    self.kinect = [[Kinect alloc] init];
        //    kinectContextIsOpen = [self.kinect openDevice];
        //    kinectDepthIsOpen = [self.kinect openDepth];
        
        // create draw loop
    }
    return self;
}

- (void) windowDidLoad
{
    [super windowDidLoad];

    // code
}

- (void) stop
{
    NSLog(@"stop");
    
    if (kinectDepthIsOpen) {
        NSLog(@"result from closing depth is: %d", [self.kinect closeDepth]);
    }
    
    if (kinectContextIsOpen) {
        NSLog(@"result from closing device is: %d", [self.kinect closeDevice]);
    }
}

- (IBAction) toggleDisplay:(NSButton *)sender {
    NSLog(@"toggleDisplay");
    
    if (self.glView.isRunning) {
        [self.glView stop];
        sender.title = @"Start OpenGL";
    } else {
        [self.glView start];
        sender.title = @"Stop OpenGL";
    }
}

- (IBAction)toggleKinect:(NSButton *)sender {
    NSLog(@"toggleKinect");

}

@end
