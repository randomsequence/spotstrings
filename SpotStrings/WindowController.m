//
//  WindowController.m
//  SpotStrings
//
//  Created by Johnnie Walker on 14/06/2012.
//  Copyright (c) 2012 Random Sequence. All rights reserved.
//

#import "WindowController.h"

#define kUserDefaultsStringsKey @"strings"
#define kSpotStringMetadataPathExtension @"SpotStringMetadata"

@interface WindowController () {
    NSMutableArray *_strings;  
    NSArray *_countries;
}

@end

@implementation WindowController
@synthesize tableView;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        srandomdev();
        _strings = [[NSMutableArray alloc] initWithCapacity:100];
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"];
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonPath] options:0 error:&error];
        if (nil != error)
            NSLog(@"error: %@", error);
//        NSLog(@"json: %@", json);
        _countries = (NSArray *)[[json allValues] copy];
    }
    
    return self;
}

- (void)dealloc
{
    [_countries release];
    [_strings release];
    [super dealloc];
}

- (NSString *)randomString {

    NSString *string = @"";
    for (NSUInteger i=0; i<3; i++) {
        NSUInteger index = (random() % ([_countries count]-1));
        NSString *countryName = [[[_countries objectAtIndex:index] objectForKey:@"Name"] stringByReplacingOccurrencesOfString:@" " withString:@""];
        string = [string stringByAppendingString:countryName];
    }    
    
    return string;
}

- (IBAction)save:(id)sender {
    [self saveData];
}

- (IBAction)clear:(id)sender {
    [_strings removeAllObjects];
    [tableView reloadData];
}

- (IBAction)newString:(id)sender {
    NSUInteger index = [_strings count];
    [_strings addObject:[self randomString]];
    [tableView beginUpdates];
    [tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:index] withAnimation:NSTableViewAnimationSlideDown];
    [tableView endUpdates];
    [self saveData];    
}

- (void)loadData {
    NSArray *strings = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsStringsKey];
    [_strings removeAllObjects];
    [_strings addObjectsFromArray:strings];
}

- (void)saveData {
    [[NSUserDefaults standardUserDefaults] setObject:_strings forKey:kUserDefaultsStringsKey];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
	NSString *metadataDir = [[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Metadata"] stringByAppendingPathComponent:appName];
    NSError *error = nil;
    [fileManager createDirectoryAtPath:metadataDir withIntermediateDirectories:YES attributes:nil error:&error];
    NSAssert1((nil == error), @"createDirectoryAtPath error: %@", error);
    
    for (NSString *filename in [fileManager contentsOfDirectoryAtPath:metadataDir error:&error]) {
        if ([[filename pathExtension] isEqualToString:kSpotStringMetadataPathExtension]) {
            [fileManager removeItemAtPath:[metadataDir stringByAppendingPathComponent:filename] error:&error];
            NSAssert1((nil == error), @"removeItemAtPath error: %@", error);            
        }
    }
    
    for (NSInteger i=[_strings count]-1; i>-1; i--) {
        NSString *metadataPath = [metadataDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%i.%@", i, kSpotStringMetadataPathExtension]];
        [[_strings objectAtIndex:i] writeToFile:metadataPath atomically:NO encoding:NSUTF8StringEncoding error:&error];
        NSAssert1((nil == error), @"writeToFile error: %@", error);        
    }    
}

- (void)openFile:(NSString *)file {
    if ([[file pathExtension] isEqualToString:kSpotStringMetadataPathExtension]) {
        NSUInteger row = (NSUInteger)[[[file lastPathComponent] stringByDeletingPathExtension] integerValue];
        if (row < [_strings count])
            [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];        
    }
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self loadData];
    
    if ([_strings count] == 0) {
        for (NSUInteger i=0; i<25; i++) {
            [_strings addObject:[self randomString]];
        }
        [self saveData];        
    }
    
    [tableView reloadData];
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    return [_strings count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    return [_strings objectAtIndex:rowIndex];
}

#pragma mark - NSTableViewDelegate

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    NSInteger selectedRow = [tableView selectedRow];
    if (selectedRow > -1) {
        NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
        [pasteBoard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
        [pasteBoard setString:[_strings objectAtIndex:selectedRow] forType:NSStringPboardType];
    }
}

@end
