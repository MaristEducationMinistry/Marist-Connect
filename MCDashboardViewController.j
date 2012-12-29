@import "MCCourseSelectionViewController.j"

@implementation MCDashboardViewController : CPViewController
{
    @outlet CPView leftDashboardView;
    @outlet CPView rightDashboardView;
    
    MCCourseSelectionViewController _courseSelectionViewController;
}

- (void)awakeFromCib
{
	//[[self view] setDelegate:self];
	_courseSelectionViewController = [[MCCourseSelectionViewController alloc] initWithUser:Parse.User.current() ofClass:@"user"];
	[[_courseSelectionViewController view] setFrame:[[self view] frame]];
	[[_courseSelectionViewController view] setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable | CPViewMinXMargin | CPViewMinYMargin | CPViewMaxXMargin | CPViewMaxYMargin];
	[leftDashboardView addSubview:[_courseSelectionViewController view]];
}

- (void)resize
{
	window.console.log([[self view] frame]);
}

-(void) layoutSubviews {
	var frame = [[self view] frame];
	[[_courseSelectionViewController view] setFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
}
/*
- (float)splitView:(CPSplitView)aSplitView constrainMinCoordinate:(float)proposedMin ofSubviewAt:(int)subviewIndex
{
	return 300.0;
}

- (float)splitView:(CPSplitView)aSplitView constrainMaxCoordinate:(float)proposedMax ofSubviewAt:(int)subviewIndex
{
	return 300.0;
}
*/

@end