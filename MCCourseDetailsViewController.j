@import <Foundation/Foundation.j>
@import "MCCourseDetailsHeaderViewController.j"
@import "MCFilterView.j"

@implementation MCCourseDetailsViewController : CPViewController
{
	MCCourseDetailsHeaderViewController _detailsHeader;
	MCFilterView _personTypeFilterView;
	
	id _course;
}

- (void)awakeFromCib
{
	_detailsHeader = [[MCCourseDetailsHeaderViewController alloc] initWithCibName:@"MCCourseDetailsHeaderViewController" bundle:nil];
	_personTypeFilterView = [[MCFilterView alloc] initWithWidth:[[self view] frame].size.width Buttons:nil Theme:MCFilterViewThemeLight Anchor:MCFilterViewAnchorRight];
	
	[[_detailsHeader view] setFrame:CGRectMake(0.0, 0.0, [[self view] frame].size.width, 102.0)];
	[[_detailsHeader view] setAutoresizingMask: CPViewMaxYMargin | CPViewMinXMargin | CPViewMinYMargin];
	[_personTypeFilterView setFrame:CGRectMake(0.0, 102.0, [[self view] frame].size.width, 25.0)];
	[_personTypeFilterView setDataSource:self];
	[_personTypeFilterView setDelegate:self];
	[_personTypeFilterView reloadData];
	
	[[self view] addSubview:[_detailsHeader view]];
	[[self view] addSubview:_personTypeFilterView];
}

- (void)setCourseObject:(id)course status:(int)aStatus
{
	_course = course;
	[_detailsHeader setCourseName:_course.get("name")];
	[_detailsHeader setCourseObject:course status:aStatus];
}

- (void)resizeUI:(CGRect)frame
{
	[[self view] setFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
	
	[[_detailsHeader view] setFrameOrigin:CGPointMake(0.0, 0.0)];
	[[_detailsHeader view] setFrameSize:CGSizeMake(frame.size.width, 102.0)];
	
	[_personTypeFilterView setFrameOrigin:CGPointMake(0.0, 102.0)];
	[_personTypeFilterView resizeUI:frame];
}

//filter bar delegate
-(int) numberOfButtonsInFilterBar:(MCFilterView)view {
	 return 3;
 }
 
-(CPString) filterBar:(MCFilterView)view titleForIndex:(int)rowIndex {
	if (rowIndex == 0) {
		return @"Available";
	} else if (rowIndex == 1) {
		return @"Enrolled";
	} else {
		return @"Completed";
	}
}

-(CPString) filterBar:(MCFilterView)view identifierForIndex:(int)rowIndex {
	if (rowIndex == 0) {
		return @"Available";
	} else if (rowIndex == 1) {
		return @"Enrolled";
	} else {
		return @"Completed";
	}
}

-(void) filterBar:(MCFilterView)view itemSelectedWithIdentifier:(CPString)identifier {
	if ([identifier isEqualToString: @"Available"]) {
		[self setCurrentDataSource:@"avaliableCourse"];
	} else if ([identifier isEqualToString: @"Completed"]) {
		[self setCurrentDataSource:_currentCourses];
	} else {
		[self setCurrentDataSource:_pastCourses];
	}
}

- (void)setCurrentDataSource:(id)sourse
{

}

@end