//
//  AppDelegate.m
//  SpotStrings
//
//  Created by Johnnie Walker on 14/06/2012.
//  Copyright (c) 2012 Random Sequence. All rights reserved.
//

#import "AppDelegate.h"
#import "WindowController.h"

@implementation AppDelegate

@synthesize windowController = _windowController;

- (void)dealloc
{
    self.windowController = nil;
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    WindowController *controller = [[WindowController alloc] initWithWindowNibName:@"WindowController"];
    self.windowController = controller;
    [controller release];
    
    [self.windowController showWindow:nil];
}

- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames {
    for (NSString *filename in filenames) {
        [self.windowController openFile:filename];
    }
}

@end
