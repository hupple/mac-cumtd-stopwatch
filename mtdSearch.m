//
//  mtdSearch.m
//  mtd
//
//  Created by Ping Hu on 11-1-22.
//  Copyright 2011 UIUC. All rights reserved.
//

#import "mtdSearch.h"


@implementation mtdSearch
- (void)dealloc{
	[stopwatch release];
	[super dealloc];
}

- (void)awakeFromNib {
    [searchField setTarget:self];
    [searchResults setDoubleAction:@selector(doubleClick:)];
    [searchField setStringValue:@"MTD7411"];
    [self stopWatchwithString:@"MTD7411"];
    
}

-(IBAction)stopWatch:(id)sender{
	
	NSString *input = [searchField stringValue];
	if ([input length] == 0) {
		return;
	}
    //NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    [self stopWatchwithString:input];
    //[pool drain];
}
-(void)stopWatchwithString:(NSString*)sstring
{
    //[progess startAnimation:nil];
	NSInteger intstring = [sstring integerValue];
	NSMutableString *sss = [NSMutableString stringWithString:sstring];
	if (intstring > 0 && intstring < 10000) {
		[sss insertString:@"MTD" atIndex:0];
	}
	NSString *urlinput = [sss stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSString *urlString = [NSString stringWithFormat:
						   @"http://stopwatch.cumtd.mobi/?__EVENTTARGET=&__EVENTARGUMENT=&txtSearch="
						   @"%@"
						   @"&cmdSubmit=Search",urlinput];
	
	NSURL *url = [NSURL URLWithString:urlString];
	if (!url) {
		NSLog(@"URL");
		exit(1);
	}
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
															  cachePolicy:NSURLRequestReturnCacheDataElseLoad
														  timeoutInterval:30];
	[urlRequest addValue:@"Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0" forHTTPHeaderField: @"User-Agent"];
	NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
	if (!urlData) {
		return;
	}
	result = [[NSString alloc] initWithData:urlData
                                   encoding:NSASCIIStringEncoding];
    //NSLog(@"result = %@", doc);
	NSMutableString *sep;
	NSUInteger head, end;
	if ([result rangeOfString:@"Search Results</title>"].location != NSNotFound) {
		sep = [NSMutableString stringWithString:@"<a href=\"ViewStop.aspx?sp="];
		head = 1;
		end = 0;
	}
	else if ([result rangeOfString:@"<title>Champaign Urbana Mass Transit District</title>"].location != NSNotFound) {
		[stopwatch release];
		stopwatch = [[NSMutableArray arrayWithObject:@"No bus stops found..."] retain];
		[resultTitle setStringValue:@"Search Results"];
		[searchResults reloadData];
        //[progess stopAnimation:nil];
        //NSLog(@"No such stop.");
		return;
	}
	else {
		sep = [NSMutableString stringWithString:@"face=\"verdana, arial\""];
		head = 2;
		end = 2;
	}
	
	NSArray *info = [result componentsSeparatedByString:sep];
	[result release];
	NSUInteger i = head;
	NSUInteger l = [info count];
	[stopwatch release];
	stopwatch =[[NSMutableArray arrayWithCapacity:l] retain];
	while (i < l - end) {
        //NSLog(@"%@",[info objectAtIndex:i]);
		[stopwatch addObject:[[[[[info objectAtIndex:i] componentsSeparatedByString:@"<"] objectAtIndex:0] componentsSeparatedByString:@">"] objectAtIndex:1]];
		i++;
	}
	if ([[stopwatch objectAtIndex:1] rangeOfString:@"No routes are currently scheduled for this stop or the server is not displaying any results."].location != NSNotFound) {
		[stopwatch removeLastObject];
		[stopwatch addObject:@"There are no buses coming..."];
	}
	if (head == 1) {
		[resultTitle setStringValue:@"Search Results"]; 
	}
	else {
		[resultTitle setStringValue:[stopwatch objectAtIndex:0]];
		[stopwatch removeObjectAtIndex:0];
	}
    
	/*
     for(i=0;i<l-head-end; i++){
     NSLog(@"%@",[stopwatch objectAtIndex:i]);
     }*/
	
	[searchResults reloadData];
    //[progess stopAnimation:nil];
}
-(void)doubleClick:(id)a
{
	NSInteger rowIndex = [searchResults clickedRow];
	NSString *rowString = [stopwatch objectAtIndex:rowIndex];
	NSRange MTDrange = [rowString rangeOfString:@"MTD"];
	if (MTDrange.location == NSNotFound) {
		return;
	}
	MTDrange.length += 4;	//range for MTDnnnn
	NSString *input = [rowString substringWithRange:MTDrange];
	[searchField setStringValue:input];
	NSArray* recent = [searchField recentSearches];
	NSMutableArray* newrecent = [NSMutableArray arrayWithArray:recent];
	[newrecent removeObject:input];
	[newrecent insertObject:input atIndex:0];
	[searchField setRecentSearches:newrecent];
    //[recent release];
	[self stopWatchwithString:input];
}
#pragma mark -
#pragma mark NSTableView datasource
-(NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView{
	return [stopwatch count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex{
	return [stopwatch objectAtIndex:rowIndex];
}

@end