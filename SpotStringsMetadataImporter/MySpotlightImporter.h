//
//  MySpotlightImporter.h
//  SpotStringsMetadataImporter
//
//  Created by Johnnie Walker on 14/06/2012.
//  Copyright (c) 2012 Random Sequence. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MySpotlightImporter : NSObject

- (BOOL)importFileAtPath:(NSString *)filePath attributes:(NSMutableDictionary *)attributes error:(NSError **)error;

@end
