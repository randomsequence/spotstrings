//
//  WindowController.h
//  SpotStrings
//
//  Created by Johnnie Walker on 14/06/2012.
//  Copyright (c) 2012 Random Sequence. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WindowController : NSWindowController <NSTableViewDelegate, NSTableViewDataSource>
@property (assign) IBOutlet NSTableView *tableView;
- (IBAction)save:(id)sender;
- (IBAction)clear:(id)sender;
- (IBAction)newString:(id)sender;
- (void)openFile:(NSString *)file;
@end
