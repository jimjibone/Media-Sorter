//
//  JRMediaSorter.m
//  Media Sorter
//
//  Created by James Reuss on 15/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JRMediaSorter.h"

@implementation JRMediaSorter

- (id)init {
    self = [super init];
    if (self) {
        // Initiate Objects
        mediaList = [[NSMutableArray alloc] init];
        fileManager = [NSFileManager defaultManager];
        pathContents = [[NSArray alloc] init];
    }
    return self;
}//Done

//-------------------------------------------------------------------------------------
// File Methods
//-------------------------------------------------------------------------------------
- (void)findMediaFilesInDirectory:(NSString*)directory {
    // Prepare objects.
    [mediaList removeAllObjects];
    
    // Get the contents of the path.
    pathContents = [fileManager contentsOfDirectoryAtPath:directory error:nil];
    
    // Enumerate through it and store the path if it is a video file.
    NSEnumerator *contentsEnumerator = [pathContents objectEnumerator];
    NSString *contentsPath, *contentsExtension;
    
    while (contentsPath = [contentsEnumerator nextObject]) {
        contentsExtension = [contentsPath pathExtension];
        if ([contentsExtension isEqualToString:@"avi"] || 
            [contentsExtension isEqualToString:@"mp4"] ||
            [contentsExtension isEqualToString:@"m4v"] ||
            [contentsExtension isEqualToString:@"mkv"]   ) {
            [mediaList addObject:[[JRMedia newMediaWithPath:contentsPath] autorelease]];
        }
    }
}//Done
- (void)updateFileNamesWithDirectory:(NSString*)directory {
    // Run through the list of files already found and apply the new file names to them.
    NSEnumerator *fileEnumerator = [mediaList objectEnumerator];
    JRMedia *currentFile;
    
    while (currentFile = [fileEnumerator nextObject]) {
        // Get the old and new file names and give them the proper full path.
        NSString *oldPath = [directory stringByAppendingPathComponent:[currentFile path]];
        NSString *newPath = [directory stringByAppendingPathComponent:[currentFile convertedFileName]];
        
        NSLog(@"Old: %@", oldPath);
        NSLog(@"New: %@", newPath);
        
        // Check to see that the name conversion worked properly. If so, then apply the new file name to that file.
        if (![oldPath isEqualToString:newPath]) {
            if (![fileManager moveItemAtPath:oldPath toPath:newPath error:nil]) {
                NSLog(@"There was an error while changing the name!");
            }
        } else {
            NSLog(@"No change in file name. Did not convert.");
        }
    }
}


//-------------------------------------------------------------------------------------
// Getters
//-------------------------------------------------------------------------------------
- (NSMutableArray*)getMediaList {
    return mediaList;
}//Done

@end
