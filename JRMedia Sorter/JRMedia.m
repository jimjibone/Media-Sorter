//
//  JRMedia.m
//  Media Sorter
//
//  Created by James Reuss on 15/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JRMedia.h"

@implementation JRMedia
@synthesize path, isAVI, isTVShow, convertedFileName;
@synthesize seriesName;
@synthesize seasonNumber, episodeNumber;

//-------------------------------------------------------------------------------------
// Main
//-------------------------------------------------------------------------------------
- (void)extractMediaInformation:(NSString*)newPath {
    // Set up the object.
	[self setPath:[NSString stringWithString:newPath]];
	[self setIsAVI:FALSE];
	[self setIsTVShow:FALSE]; 
    NSUInteger SEElement = 0;
    
    NSString *separator = [NSString stringWithString:@""];
    
    NSPredicate *dotSearch = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"."];
    NSPredicate *spaceSearch = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @" "];
    if ([dotSearch evaluateWithObject:[path stringByDeletingPathExtension]]) {
        // If the file found needs to be converted from dot form.
        separator = @".";
        NSLog(@"dot search");
    } else if ([spaceSearch evaluateWithObject:[path stringByDeletingPathExtension]]) {
        // If the file found needs to be converted from space form.
        separator = @" ";
        NSLog(@"space search");
    } else {
        NSLog(@"no search");
    }
    
    // First split up the path into its parts separated by '.'
    NSMutableArray *filenameParts = [[NSMutableArray alloc] initWithArray:[[path stringByDeletingPathExtension] componentsSeparatedByString:separator]];
    NSString *currentPart;
    
    // Then iterate through the parts to find the season and episode string.
    // Find the location of the Season and Episode numbers and pull out their values.
    for (NSUInteger currentElement = 0; currentElement < [filenameParts count]; currentElement++) {
        currentPart = [filenameParts objectAtIndex:currentElement];
        
        // Check to see if its the Season and Episode section.
        NSString *SEString = @"S??E??";
        NSPredicate *SESearch = [NSPredicate predicateWithFormat:@"SELF LIKE %@", SEString];
        
        if ([SESearch evaluateWithObject:currentPart]) {
            // Pull out the season and episode number.
            // Location 012345
            // String   S00E00
			[self setSeasonNumber:
			 [NSNumber numberWithInt:[[currentPart substringWithRange:NSMakeRange(1, 2)] intValue]]];
			[self setEpisodeNumber:
			 [NSNumber numberWithInt:[[currentPart substringWithRange:NSMakeRange(4, 2)] intValue]]];
            isTVShow = TRUE;
            SEElement = currentElement;
        } else if ([currentPart isEqualToString:@"avi"]) {
            [self setIsAVI:TRUE];
        }
    }
    
    // Now get the show name up to the element containing the Season and Episode Number.
    for (NSUInteger currentElement = 0; currentElement < SEElement; currentElement++) {
        currentPart = [filenameParts objectAtIndex:currentElement];
        
        if (currentElement == 0) {
            // If it is the first word in the title.
			[self setSeriesName:[seriesName stringByAppendingString:currentPart]];
        } else {
            // If it isn't the first word.
			[self setSeriesName:[[seriesName stringByAppendingString:@" "] stringByAppendingString:currentPart]];
        }
    }
    
    if (![separator isEqualToString:@""]) {
        // Now make a new filename for this object.
		[self setConvertedFileName:[NSString localizedStringWithFormat:
									@"%@ S%02iE%02i.%@", 
									seriesName, 
									[seasonNumber intValue], 
									[episodeNumber intValue], 
									[path pathExtension]
									]];
    } else {
		[self setConvertedFileName:[NSString stringWithString:path]];
    }
	
	[filenameParts release];
}//Done
+ (JRMedia*)newMediaWithPath:(NSString*)newPath {
    // Set up the object.
    BOOL isAVI = FALSE;
    BOOL isTVShow = FALSE;
    NSUInteger SEElement = 0;
    NSNumber *seasonNumber = [NSNumber numberWithInt:0];
    NSNumber *episodeNumber = [NSNumber numberWithInt:0];
    NSString *seriesName = [NSString stringWithString:@""];
    NSString *newFileName = [NSString stringWithString:@""];
    
    NSString *separator = [NSString stringWithString:@""];
    
    NSPredicate *dotSearch = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"."];
    NSPredicate *spaceSearch = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @" "];
    if ([dotSearch evaluateWithObject:[newPath stringByDeletingPathExtension]]) {
        // If the file found needs to be converted from dot form.
        separator = @".";
    } else if ([spaceSearch evaluateWithObject:[newPath stringByDeletingPathExtension]]) {
        // If the file found needs to be converted from space form.
        separator = @" ";
    } else {
        NSLog(@"no search");
    }
    
    // First split up the path into its parts separated by '.'
    NSMutableArray *filenameParts = [[NSMutableArray alloc] initWithArray:[[newPath stringByDeletingPathExtension] componentsSeparatedByString:separator]];
    NSString *currentPart;
    
    // Then iterate through the parts to find the season and episode string.
    // Find the location of the Season and Episode numbers and pull out their values.
    for (NSUInteger currentElement = 0; currentElement < [filenameParts count]; currentElement++) {
        currentPart = [filenameParts objectAtIndex:currentElement];
        
        // Check to see if its the Season and Episode section.
        NSString *SEString = @"S??E??";
        NSPredicate *SESearch = [NSPredicate predicateWithFormat:@"SELF LIKE %@", SEString];
        
        if ([SESearch evaluateWithObject:currentPart]) {
            // Pull out the season and episode number.
            // Location 012345
            // String   S00E00
            seasonNumber = [NSNumber numberWithInt:[[currentPart substringWithRange:NSMakeRange(1, 2)] intValue]];
            episodeNumber = [NSNumber numberWithInt:[[currentPart substringWithRange:NSMakeRange(4, 2)] intValue]];
            isTVShow = TRUE;
            SEElement = currentElement;
        } else if ([currentPart isEqualToString:@"avi"]) {
            isAVI = TRUE;
        }
    }
    
    // Now get the show name up to the element containing the Season and Episode Number.
    for (NSUInteger currentElement = 0; currentElement < SEElement; currentElement++) {
        currentPart = [filenameParts objectAtIndex:currentElement];
        
        if (currentElement == 0) {
            // If it is the first word in the title.
            seriesName = [seriesName stringByAppendingString:currentPart];
        } else {
            // If it isn't the first word.
            seriesName = [[seriesName stringByAppendingString:@" "] stringByAppendingString:currentPart];
        }
    }
    
    if (![separator isEqualToString:@""]) {
        // Now make a new filename for this object.
        newFileName = [NSString localizedStringWithFormat:
                       @"%@ S%02iE%02i.%@", 
                       seriesName, 
                       [seasonNumber intValue], 
                       [episodeNumber intValue], 
                       [newPath pathExtension]
                       ];
    } else {
        newFileName = newPath;
    }
    
    // Make a new object to be returned.
    JRMedia *newMedia = [[JRMedia alloc] init];
	[newMedia setPath:newPath];
	[newMedia setIsAVI:isAVI];
	[newMedia setSeasonNumber:seasonNumber];
	[newMedia setEpisodeNumber:episodeNumber];
	[newMedia setSeriesName:seriesName];
	[newMedia setConvertedFileName:newFileName];
    
	[filenameParts release];
    return newMedia;
}//Done

@end