//
//  AppDelegate.h
//  Kinector
//
//  Created by foo on 8/28/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) MainWindowController *controller;

@end
