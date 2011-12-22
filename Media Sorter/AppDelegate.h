//
//  AppDelegate.h
//  Media Sorter
//
//  Created by James Reuss on 21/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
}

- (IBAction)quitApp:(id)sender;

@end
