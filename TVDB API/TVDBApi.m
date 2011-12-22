//
//  TVDBApi.m
//  Media Sorter
//
//  Created by James Reuss on 21/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TVDBApi.h"

@implementation TVDBApi
@synthesize APIKey, mirrorPath, getSeriesPath, currentSearchType;
@synthesize foundShow, collectedData, foundShowArray;

- (id)init {
    self = [super init];
    if (self) {
        // Initialisations
		APIKey = [[NSString alloc] initWithString:@"7F6CCD965D3EF4EC"];
		mirrorPath = [[NSString alloc] initWithString:@"http://www.thetvdb.com/api/"];
		getSeriesPath = [[NSString alloc] initWithString:@"GetSeries.php?seriesname="];
		currentSearchType = 0;
		foundShowArray = [[NSMutableArray alloc] init];
    }
    return self;
}

//-------------------------------------------------------------------------------------
// Search Methods
//-------------------------------------------------------------------------------------
- (void)searchForTVDBShowsWithName:(NSString*)showName {
	// Set up the url to search for the show 'showName'.
	showName = [showName stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSURL *showSearchURL = [[NSURL alloc] initWithString:
							[NSString stringWithFormat:@"%@%@%@", mirrorPath, getSeriesPath, showName]];
	
	// Set up the search type and show array.
	[self setCurrentSearchType:(searchType)seriesSearch];
	[foundShowArray removeAllObjects];
	
	// Create a XML parser to search through the returned results for us.
	NSXMLParser *XMLParser = [[NSXMLParser alloc] initWithContentsOfURL:showSearchURL];
	[XMLParser setDelegate:self];
	[XMLParser parse];
	
	// Release all the local objects.
	[showSearchURL release];
	[XMLParser release];
}

//-------------------------------------------------------------------------------------
// NSXML Parser Methods
//-------------------------------------------------------------------------------------
- (void)parser:(NSXMLParser*)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	// Run different searches for different search types.
	if (currentSearchType == (searchType)seriesSearch) {
		// If we are doing a Series search then we want to create a new TVDBShow object to work with for each show we encounter in the search.
		if ([elementName isEqualToString:@"seriesid"]) {
			foundShow = [[TVDBShow alloc] init];
		}
	} else if (currentSearchType == (searchType)episodeSearch) {
		// If we are doing an Episode search then......
		NSLog(@"Implement Episode Search");
	}
}//Done
- (void)parser:(NSXMLParser*)parser foundCharacters:(NSString *)string {
	// This will be the same for all search types as it just collects the data we want.
	if (!collectedData) {
		collectedData = [[NSMutableString alloc] initWithString:@""];
	}
	[collectedData appendString:
	 [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}//Done
- (void)parser:(NSXMLParser*)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	// Also run different searches for different search types.
	if (currentSearchType == (searchType)seriesSearch) {
		// So were doing a Series search. We must pick out all the information we want and put it into the relevant field of foundShow.
		if		  ([elementName isEqualToString:@"seriesid"]) {
			[foundShow setSeriesID:[NSString stringWithString:collectedData]];
		} else if ([elementName isEqualToString:@"language"]) {
			[foundShow setLanguage:[NSString stringWithString:collectedData]];
		} else if ([elementName isEqualToString:@"SeriesName"]) {
			[foundShow setSeriesName:[NSString stringWithString:collectedData]];
		} else if ([elementName isEqualToString:@"Overview"]) {
			[foundShow setOverview:[NSString stringWithString:collectedData]];
		}
		if ([elementName isEqualToString:@"id"]) {
			// This is the final element in this shows XML tree and because were not interested in this we can use it to close off the assignment of this shows details and add it to the foundShowArray.
			[collectedData release];
			collectedData = nil;
			
			// Check that all the fields are filled. If not then fill with blank.
			if (![foundShow seriesID])   [foundShow setSeriesID:@"N/A"];
			if (![foundShow language])   [foundShow setLanguage:@"N/A"];
			if (![foundShow seriesName]) [foundShow setOverview:@"N/A"];
			if (![foundShow overview])	 [foundShow setOverview:@"N/A"];
			
			[foundShowArray addObject:foundShow];
			[foundShow release];
		} else {
			[collectedData setString:@""];
		}
	} else if (currentSearchType == (searchType)episodeSearch) {
		NSLog(@"Implement Episode Search");
	}
}

//-------------------------------------------------------------------------------------
// Getters
//-------------------------------------------------------------------------------------
- (NSArray*)getFoundShowArray {
	return foundShowArray;
}

@end
