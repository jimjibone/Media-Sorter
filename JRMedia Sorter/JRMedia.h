//
//  JRMedia.h
//  Media Sorter
//
//  Created by James Reuss on 15/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRMedia : NSObject
// File Information
@property (assign) NSString *path;
@property (assign) BOOL isAVI;
@property (assign) BOOL isTVShow;
@property (assign) NSString *convertedFileName;
// TV Show Information
@property (assign) NSString *seriesName;
//NSString *episodeName;
@property (assign) NSNumber *seasonNumber;
@property (assign) NSNumber *episodeNumber;

// Main
- (void)extractMediaInformation:(NSString*)newPath;
+ (JRMedia*)newMediaWithPath:(NSString*)newPath;

@end