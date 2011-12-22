//
//  TVDBApi.h
//  Media Sorter
//
//  Created by James Reuss on 21/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TVDBShow.h"

typedef enum searchType {
    seriesSearch = 0,
    episodeSearch
} searchType;

@interface TVDBApi : NSObject
// API Objects
@property (assign) NSString *APIKey;
@property (assign) NSString *mirrorPath;
@property (assign) NSString *getSeriesPath;
@property (assign) NSUInteger currentSearchType;
// Show Objects
@property (assign) TVDBShow *foundShow; // Initalise and release when needed instead of in init.
@property (assign) NSMutableString *collectedData;
@property (assign) NSMutableArray *foundShowArray;

// Search Methods
- (void)searchForTVDBShowsWithName:(NSString*)showName;

// NSXML Parser Methods
- (void)parser:(NSXMLParser*)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
- (void)parser:(NSXMLParser*)parser foundCharacters:(NSString *)string;
- (void)parser:(NSXMLParser*)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;

// Getters
- (NSArray*)getFoundShowArray;

@end
