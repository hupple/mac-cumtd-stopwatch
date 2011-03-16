//
//  mtdAppDelegate.h
//  mtd
//
//  Created by Ping Hu on 11-1-22.
//  Copyright 2011 UIUC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface mtdAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
