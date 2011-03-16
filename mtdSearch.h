//
//  mtdSearch.h
//  mtd
//
//  Created by Ping Hu on 11-1-22.
//  Copyright 2011 UIUC. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface mtdSearch : NSObject {
	IBOutlet NSTextField *resultTitle;
		//IBOutlet NSProgressIndicator *progess;
	IBOutlet NSSearchField *searchField;
	IBOutlet NSTableView *searchResults;
	NSString *result;
	NSMutableArray *stopwatch;
}
-(IBAction)stopWatch:(id)sender;
-(void)stopWatchwithString:(NSString*)sstring;

@end
