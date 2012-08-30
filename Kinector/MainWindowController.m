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

@synthesize glView = _glView;
@synthesize kinect = _kinect;
@synthesize renderer = _renderer;

// getters w/lazy init

- (Kinect *) kinect {
    if (!_kinect)
        _kinect = [[Kinect alloc] init];
    return _kinect;
}

- (Renderer *) renderer {
    if (!_renderer)
        _renderer = [[Renderer alloc] initWithDelegate:self];
    return _renderer;
}

// buffer delegate

- (uint8_t *) getDepthBuffer {
    NSLog(@"MainWindowController - getDepthBuffer");
    
    return [self.kinect getDepthBuffer];
}

- (id) init
{
    self = [super initWithWindowNibName:@"MainWindow"];
    
    if (self) {        
        // code
    }
    return self;
}

- (void) windowDidLoad
{
    [super windowDidLoad];

    // code
    self.glView.renderer = self.renderer;
}

- (void) stop
{
    NSLog(@"stop");
    
    [self.kinect stop];
    [self.glView stop];
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

    if (self.kinect.isRunning) {
        [self.kinect stop];
        sender.title = @"Start Kinect";
    } else {
        [self.kinect start];
        sender.title = @"Stop Kinect";
    }
}

@end
