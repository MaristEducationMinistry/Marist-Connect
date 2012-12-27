@implementation MCDashboardViewController : CPViewController
{
    @outlet CPView leftDashboardView;
    @outlet CPView rightDashboardView;
}

- (void)awakeFromCib
{
	[[self view] setDelegate:self];
}

- (float)splitView:(CPSplitView)aSplitView constrainMinCoordinate:(float)proposedMin ofSubviewAt:(int)subviewIndex
{
	return 300.0;
}

- (float)splitView:(CPSplitView)aSplitView constrainMaxCoordinate:(float)proposedMax ofSubviewAt:(int)subviewIndex
{
	return 300.0;
}

@end