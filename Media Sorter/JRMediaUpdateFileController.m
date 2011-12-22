//
//  JRMediaUpdateFileController.m
//  Media Sorter
//
//  Created by James Reuss on 21/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JRMediaUpdateFileController.h"

@implementation JRMediaUpdateFileController
@synthesize updateFileWindow;
@synthesize foundFileSelector;
@synthesize foundShowsSelector;
@synthesize showName;
@synthesize showSeries;
@synthesize showEpisode;
@synthesize showEpisodeName;
@synthesize showOverview;
@synthesize updatedFilename;

- (void)awakeFromNib {
	currentShow = [[TVDBShow alloc] init];
	currentFile = [[JRMedia alloc] init];
	fileArray = [[NSMutableArray alloc] init];
}

- (IBAction)startManualUpdate:(id)sender {
	// Make the manual file update window visible.
	[updateFileWindow makeKeyAndOrderFront:self];
	[NSApp activateIgnoringOtherApps:YES];
	
	// Populate the view with info from JRMediaSorter and TVDBApi.
	// Do a file search and fill the file array.
	JRMediaSorter *fileSearch = [[JRMediaSorter alloc] init];
	[fileSearch findMediaFilesInDirectory:[NSHomeDirectory() stringByAppendingPathComponent:@"Downloads"]];
	id oldArray = fileArray;
	fileArray = [[fileSearch getMediaList] retain];
	
	[foundFileSelector removeAllItems];
	NSEnumerator *fileEnumerator = [fileArray objectEnumerator];
	id fileInstance;
	while (fileInstance = [fileEnumerator nextObject]) {
		[foundFileSelector addItemWithTitle:[fileInstance path]];
	}
	
	// Now set up the view with the currently selected file info.
	[self fileSelected:nil];
	
	[oldArray release];
	[fileSearch release];
	[fileInstance release];
}//Done

- (IBAction)fileSelected:(id)sender {
	// Using the selected file populate the found shows selector with TVDBApi.
	// Get the list of shows found for the selected file.
	TVDBApi *showSearch = [[TVDBApi alloc] init];
	[showSearch searchForTVDBShowsWithName:[[[JRMedia newMediaWithPath:[[foundFileSelector selectedItem] title]] autorelease] seriesName]];
	id oldArray = showsArray;
	showsArray = [[showSearch getFoundShowArray] retain];
	
	[foundShowsSelector removeAllItems];
	NSEnumerator *showEnumerator = [showsArray objectEnumerator];
	id showInstance;
	while (showInstance = [showEnumerator nextObject]) {
		[foundShowsSelector addItemWithTitle:[showInstance seriesName]];
	}
	
	// Now fill out the view with the info for the currently selected show.
	[self showSelected:nil];
	
	[oldArray release];
	[showSearch release];
	[showInstance release];
}//Done

- (IBAction)showSelected:(id)sender {
	// Using the data already collected for the current show, populate the view with the info.
	// Find the info we want from the shows array and fill the view.
	id oldFile = currentFile;
	id oldShow = currentShow;
	currentFile = [[fileArray objectAtIndex:[foundFileSelector indexOfSelectedItem]] retain];
	currentShow = [[showsArray objectAtIndex:[foundShowsSelector indexOfSelectedItem]] retain];
	
	[showName setStringValue:[currentShow seriesName]];
	[showSeries setStringValue:[[currentFile seasonNumber] stringValue]];
	[showEpisode setStringValue:[[currentFile episodeNumber] stringValue]];
	[showOverview setStringValue:[currentShow overview]];
	
	[oldFile release];
	[oldShow release];
}

- (IBAction)updateFile:(id)sender {
	[updatedFilename setStringValue:@"im an updated filename."];
}
@end
