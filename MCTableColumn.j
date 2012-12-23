/*
 * MCTableColumn.j
 * Marist Connect
 *
 * Created by Steffan Levet on December 20, 2012.
 * Copyright 2012, Marist Education Ministry All rights reserved.
 */

@import <Foundation/CPObject.j>

@implementation MCTableColumn : CPView {
	
	CPMutableDictionary _dataViews;
	
}

- (id)initWithIdentifier:(id)anIdentifier {
	
	self = [super initWithIdentifier:anIdentifier];
	
	if (self) {
		_dataViews = [CPMutableDictionary dictionary];
	}
	return self;
}

- (id)dataViewForRow:(int)aRowIndex {
	
	// return a generic if needed
	if (aRowIndex == -1) {
		return [self dataView];
	}
	
	var viewForRow = [_dataViews objectForKey:[[CPNumber numberWithInt:aRowIndex] stringValue]];
	return viewForRow;
}



-(void) setDataView:(CPView)aView forRow:(int)aRowIndex {
	[aView setAutoresizingMask:CPViewNotSizable];
	[_dataViews setObject:aView forKey:[[CPNumber numberWithInt:aRowIndex] stringValue]];
}


@end