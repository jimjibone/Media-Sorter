//
//  JRMediaUpdateFileController.h
//  Media Sorter
//
//  Created by James Reuss on 21/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRMediaSorter.h"
#import "TVDBApi.h"

@interface JRMediaUpdateFileController : NSObject {
    TVDBShow *currentShow;
    JRMedia *currentFile;
    NSMutableArray *fileArray;
    NSArray *showsArray;
}
@property (assign) IBOutlet NSWindow *updateFileWindow;
@property (assign) IBOutlet NSPopUpButton *foundFileSelector;
@property (assign) IBOutlet NSPopUpButton *foundShowsSelector;
@property (assign) IBOutlet NSTextField *showName;
@property (assign) IBOutlet NSTextField *showSeries;
@property (assign) IBOutlet NSTextField *showEpisode;
@property (assign) IBOutlet NSTextField *showEpisodeName;
@property (assign) IBOutlet NSTextField *showOverview;
@property (assign) IBOutlet NSTextField *updatedFilename;

- (IBAction)startManualUpdate:(id)sender;
- (IBAction)fileSelected:(id)sender;
- (IBAction)showSelected:(id)sender;
- (IBAction)updateFile:(id)sender;


@end
