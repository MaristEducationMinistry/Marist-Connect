@import "MCCourseSelectionViewController.j"
@import "MCCourseDetailsViewController.j"

@implementation MCDashboardViewController : CPViewController
{
    @outlet CPView leftDashboardView;
    @outlet CPView rightDashboardView;
    
    MCCourseSelectionViewController _courseSelectionViewController;
    MCCourseDetailsViewController _courseDetailsViewController;
    
    id _currentCourseObject;
    
    CPMutableDictionary _cachedCourseControllers;
    id _currentCourseController;
}

- (void)awakeFromCib
{
	[[self view] setDelegate:self];
	[[self view] setPosition:300.0 ofDividerAtIndex:0];
	_courseSelectionViewController = [[MCCourseSelectionViewController alloc] initWithUser:Parse.User.current() ofClass:@"user"];
	[[_courseSelectionViewController view] setFrame:[leftDashboardView frame]];
	[[_courseSelectionViewController view] setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable | CPViewMinXMargin | CPViewMinYMargin | CPViewMaxXMargin | CPViewMaxYMargin];
	[_courseSelectionViewController setDelegate:self];
	
	[leftDashboardView addSubview:[_courseSelectionViewController view]];
}

- (void)resizeUI:frame
{
	[_currentCourseController resizeUI:[rightDashboardView frame]];
}

-(void) layoutSubviews {
	var frame = [[self view] frame];
	[[_courseSelectionViewController view] setFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
}

- (float)splitView:(CPSplitView)aSplitView constrainMinCoordinate:(float)proposedMin ofSubviewAt:(int)subviewIndex
{
	return 300.0;
}

- (float)splitView:(CPSplitView)aSplitView constrainMaxCoordinate:(float)proposedMax ofSubviewAt:(int)subviewIndex
{
	return 300.0;
}

- (void)splitView:(CPSplitView)aSplitView resizeSubviewsWithOldSize:(CGSize)oldSize
{
	var leftView = [[aSplitView subviews] objectAtIndex:0];
	var rightView = [[aSplitView subviews] objectAtIndex:1];
	
	var splitViewSize = [aSplitView frame].size;
	
	var leftSize = [leftView frame].size;
	leftSize.height = splitViewSize.height;
	
	var rightSize = CGSizeMake(0.0, 0.0);
	rightSize.height = splitViewSize.height;
	rightSize.width = splitViewSize.width - [aSplitView dividerThickness] - leftSize.width;
	
	[leftView setFrameSize:leftSize];
	[[_courseSelectionViewController view] setFrameOrigin:CGPointMake(0.0, 0.0)];
	[[_courseSelectionViewController view] setFrameSize:leftSize];
	
	[rightView setFrameSize:rightSize];
	[[_courseDetailsViewController view] setFrameOrigin:CGPointMake(0.0, 0.0)];
	[[_courseDetailsViewController view] setFrameSize:CGSizeMake(rightSize.width, rightSize.height)];
	
	[_courseDetailsViewController resizeUI:[rightView frame]];
}

- (void)courseSelectionHasChanged:(id)courseObject enrolled:(int)aStatus
{
	var viewController = [_cachedCourseControllers objectForKey:courseObject.get("objectId")];
	if (!viewController) {
		var viewController = [[MCCourseDetailsViewController alloc] initWithCibName:@"MCCourseDetailsViewController" bundle:nil];	
	}
	if (!_currentCourseController) {
		[rightDashboardView addSubview:[viewController view]];
		_currentCourseController = viewController;
	} else {
		[rightDashboardView replaceSubview:[_currentCourseController view] with:[viewController view]];
		_currentCourseController = viewController;
	}
	[_currentCourseController setCourseObject:courseObject status:aStatus];
	_currentCourseObject = courseObject;
	[self resizeUI:[[self view] frame]];
}

@end