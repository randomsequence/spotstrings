//
//  MySpotlightImporter.m
//  SpotStringsMetadataImporter
//
//  Created by Johnnie Walker on 14/06/2012.
//  Copyright (c) 2012 Random Sequence. All rights reserved.
//

#import "MySpotlightImporter.h"

@interface MySpotlightImporter ()
@end

@implementation MySpotlightImporter

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)importFileAtPath:(NSString *)filePath attributes:(NSMutableDictionary *)spotlightData error:(NSError **)error
{
        
    NSString *string = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    [spotlightData setObject:string forKey:(NSString *)kMDItemDisplayName];

    return YES;
}

@end
