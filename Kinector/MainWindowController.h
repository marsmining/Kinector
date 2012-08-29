//
//  MainWindowController.h
//  Altnect
//
//  Created by foo on 8/28/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SimpleGLView.h"
#import "Kinect.h"

@interface MainWindowController : NSWindowController

@property (weak) IBOutlet SimpleGLView *glView;

@property (nonatomic, strong) Kinect *kinect;

- (void) stop;

- (IBAction)toggleDisplay:(NSButton *)sender;

- (IBAction)toggleKinect:(NSButton *)sender;

@end
