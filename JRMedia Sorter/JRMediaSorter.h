//
//  JRMediaSorter.h
//  Media Sorter
//
//  Created by James Reuss on 15/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRMedia.h"

@interface JRMediaSorter : NSObject {
    // Objects
    NSMutableArray *mediaList;
    NSFileManager *fileManager;
    NSArray *pathContents;
}

// File Methods
- (void)findMediaFilesInDirectory:(NSString*)directory;
- (void)updateFileNamesWithDirectory:(NSString*)directory;
//- (void)

// Getters
- (NSMutableArray*)getMediaList;

@end
