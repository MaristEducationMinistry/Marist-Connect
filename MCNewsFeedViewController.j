/*
 * MCNewsFeedViewController.j
 * Marist Connect
 *
 * Created by Sheldon Levet on December 27, 2012.
 * Copyright 2012, Marist Education Ministry All rights reserved.
 */

@import <Foundation/Foundation.j>
@import "SLListView.j"
@import "SLListViewCell.j"
@import "MCFilterView.j"

@implementation MCNewsFeedViewController : CPViewController
{
	MCFilterView newsFilterBar @accessors;
	@outlet CPScrollView newsScroller;
	
	SLListView newsListView;
	CPMutableArray newsData;
	
	@outlet CPView newsFeedItemView;
	@outlet CPView newsFeedLoadView;
	
	BOOL loaded;
}

- (void)resizeUI:(id)frame
{
	[newsFilterBar resizeUI:frame];
}

- (void)awakeFromCib
{
	if (loaded) {return;}
	loaded = true;
	newsListView = [[SLListView alloc] initWithFrame:CGRectMakeZero()];
	[newsScroller setDocumentView:newsListView];
	[newsListView setDelegate:self];
	//[newsListView setDataSource:self];
	newsFilterBar = [[MCFilterView alloc] initWithWidth:[[self view] frame].size.width Buttons:nil Theme:MCFilterViewThemeDark Anchor:MCFilterViewAnchorCentre];
	[newsFilterBar setAnchor:MCFilterViewAnchorCentre];
	[newsFilterBar setTheme:MCFilterViewThemeDark];
	[newsFilterBar setDataSource:self];
	[newsFilterBar setDelegate:self];
	[newsFilterBar reloadData];
	[[self view] addSubview:newsFilterBar];
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

-(void) filterBar:(MCFilterView)view itemSelectedWithIdentifier:(CPString)identifier {
	
}

@end

@implementation MCNewsFeedItem : SLListViewCell
{
	
}

-(int) numberOfRowsInListView:(SLListView)list {
	return [data count];
}

-(int) listview:(SLListView)list heightForRow:(int)row {
	if ((row % 2) == 0) {
		return 25.0;
	} else {
		return 46.0;
	}
}

-(id) listview:(SLListView)list objectForRow:(int)row {
	//return Parse.User.current();
	return [data objectAtIndex:row];
}

-(CPView) listview:(SLListView)list viewForRow:(int)row {
	if ((row % 2) == 0) {
		var viewController = [[MCCourseHeaderViewController alloc] initWithCibName:@"MCCourseHeaderView" bundle:nil];
	} else {
		var viewController = [[MCCourseCellViewController alloc] initWithCibName:@"MCCourseCellView" bundle:nil];
	}
	
	return [viewController view];
}

@end

@implementation MCNewsFeedLoader : SLListViewCell
{
	@outlet CPImageView loadMoreImage;
}

- (void)awakeFromCib
{

}

- (void)drawRect:(CGRect)aRect
{
	[super drawRect:aRect];
	
	//draw gradient
	var rect = [self frame];
	var startPoint = CGPointMake(0, 0); 
	var endPoint = CGPointMake(0, rect.size.height); 
	var startColor = [CPColor colorWithHexString:@"FFFFFF"]; 
	var endColor = [CPColor colorWithHexString:@"F0F0F0"]; 
	var currentContext = [[CPGraphicsContext currentContext] graphicsPort]; 
	var fStyle = currentContext.createLinearGradient(startPoint.x, startPoint.y, endPoint.x, endPoint.y); 
	fStyle.addColorStop(0.0, "rgba("+ROUND(255*[startColor components][0])+", "+ROUND(255*[startColor components][1])+", "+ROUND(255*[startColor components][2])+", "+[startColor components][3]+")"); 
	fStyle.addColorStop(1.0, "rgba("+ROUND(255*[endColor components][0])+", "+ROUND(255*[endColor components][1])+", "+ROUND(255*[endColor components][2])+", "+[endColor components][3]+")");
	currentContext.fillStyle = fStyle; currentContext.fillRect(0, 0, rect.size.width, rect.size.height); 

	//draw count backer
    var path = [CPBezierPath bezierPath];
    var frame = [courseCountLabel frame];
	var rect = CGRectMake([self frame].size.width - 34.0 - frame.size.width,4.0,frame.size.width + 16.0, frame.size.height);
	[path appendBezierPathWithRoundedRect:rect xRadius:frame.size.height/2 yRadius:frame.size.height/2];
	[[CPColor colorWithHexString:@"c2c2c2"] setFill];
	[path fill];
	
}

@end