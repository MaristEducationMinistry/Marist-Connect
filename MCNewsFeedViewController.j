/*
 * MCNewsFeedViewController.j
 * Marist Connect
 *
 * Created by Sheldon Levet on December 27, 2012.
 * Copyright 2012, Marist Education Ministry All rights reserved.
 */

@import <Foundation/Foundation.j>
@import "SLListView.j"

@implementation MCNewsFeedViewController : CPViewController
{
	@outlet MCFilterView newsFilterBar;
	@outlet CPScrollView newsScroller;
	
	SLListView newsListView;
	CPMutableArray newsData;
}

- (void)awakeFromCib
{
	newsListView = [[SLListView alloc] initWithFrame:CGRectMakeZero()];
	[newsScroller setDocumentView:newsListView];
	[newsListView setDelegate:self];
	//[newsListView setDataSource:self];

	[newsFilterBar setAnchor:MCFilterViewAnchorCentre];
	[newsFilterBar setTheme:MCFilterViewThemeDark];
	[newsFilterBar setDataSource:self];
	[newsFilterBar setDelegate:self];
	[newsFilterBar setWidth:[[self view] frame].size.width];
	[newsFilterBar reloadData];
}

- (CPString)filterBar:(id)aFilterBar titleForIndex:(int)aIndex
{
	if (aIndex == 0) {
		return "Date";
	} else {
		return "Location";
	}
}

- (CPString)filterBar:(id)aFilterBar identifierForIndex:(int)aIndex
{
	if (aIndex == 0) {
		return "Date";
	} else {
		return "Location";
	}
}

- (int)numberOfButtonsInFilterBar:(id)aFilterBar
{
	return 2;
}

@end