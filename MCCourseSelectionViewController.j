/*
 * MCCourseSelectionViewController.j
 * Marist Connect
 *
 * Created by Steffan Levet on December 24, 2012.
 * Copyright 2012, Marist Education Ministry All rights reserved.
 */
 
@import <Foundation/Foundation.j>
@import "EKActivityIndicatorView.j"
@import "SLListView.j"
@import "MCCourseCellView.j"
@import "MCCourseHeaderView.j"
@import "MCCourseHeaderViewController.j"
@import "MCCourseCellViewController.j"
 
@implementation MCCourseSelectionViewController : CPViewController {
	MCFilterView filterView;
	CPScrollView scrollView;
	 
	@outlet EKActivityIndicatorView progressView;
	@outlet CPImageView emptyImage;
	 
	@outlet MCCourseHeaderView listHeaderView;
	@outlet MCCourseCellView listCellView;
	 
	SLListView _listView;
	 
	CPArray _availableCourses;
	CPArray _currentCourses;
	CPArray _pastCourses;
	 
	CPArray _currentDataSource;
	 
	Object _user;
	CPString _userClassname;
	id _delegate;
	 
	CPArray data;
}
 
-(id) initWithUser:(id)aUser ofClass:(CPString)classname {
	self = [super initWithCibName:@"MCCourseSelectionViewController" bundle:nil];
	if (self) {
		//_user = aUser;
		_userClassname = classname;
	}
	return self;
}
 
/*
 -(void) layoutSubviews {
	window.console.log("laying out");
	window.console.log([[self view] frame]);
	var frame = [[self view] frame];
	[_scrollView setFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
	window.console.log([[_courseSelectionViewController view] frame]);
}
*/

- (void)setDelegate:(id)aDelegate
{
	_delegate = aDelegate;
}
 
-(void) awakeFromCib {
	var frame = [[self view] frame];
	 
	// set up the filter bar and list view
	filterView = [[MCFilterView alloc] initWithWidth:300.0 Buttons:nil Theme:MCFilterViewThemeDark Anchor:MCFilterViewAnchorCentre];
	scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0.0, 25.0, frame.size.width, frame.size.height-25)];
	[scrollView setAutoresizingMask: CPViewHeightSizable];
	[scrollView setAutohidesScrollers:YES];
	 
	[filterView setTheme:MCFilterViewThemeDark];
	[filterView setAnchor:MCFilterViewAnchorCentre];
	[filterView setDataSource:self];
	[filterView setDelegate:self];
	[filterView reloadData];
	  
	var image = [[CPImage alloc] initWithContentsOfFile:@"Image Resources/window-noise.png"];
    [scrollView setBackgroundColor:[CPColor colorWithPatternImage:image]];
	_listView = [[SLListView alloc] initWithFrame:CGRectMakeZero()];
	[_listView setAutoresizingMask: CPViewWidthSizable];
	[_listView setDividerColor:[CPColor colorWithHexString:@"cbcbcb"]];
    [_listView setHighlightColor:[CPColor blackColor]];
    
    var col1 = [CPColor colorWithHexString:@"0054a6"];
    col1 = [col1 colorWithAlphaComponent: 0.39];
    var col2 = [CPColor colorWithHexString:@"9fcaf4"];
    col2 = [col2 colorWithAlphaComponent: 0.39];
    
    //create the progress view
    progressView = [[EKActivityIndicatorView alloc] initWithFrame:CGRectMake(126.0, (frame.size.height - 49.0) / 2, 48.0, 48.0)];
    
    [_listView setGradientHighlightColors:[CPArray arrayWithObjects: col1, col2, nil]];
    [scrollView setDocumentView:_listView];
    [scrollView flashScrollers];
	[_listView setDataSource:self];
	[_listView setDelegate:self];
	[[self view] addSubview:filterView];
	[[self view] addSubview:scrollView];
	[[self view] addSubview:progressView];
}
 
-(void) setCurrentDataSource:(CPString) arrayString {
	 
	// first empty the list view and reload the data
	_currentDataSource = [CPArray array];
	[_listView reloadData];
	
	// make sure the progress indicator and empty image are hidden
	[progressView startAnimating];
	 
	if (arrayString == @"avaliableCourse") {
		var array = _availableCourses;
	}
	 
	// check the condition of the new data and handle it apropiatly
	if (array == nil) {
		// this set of courses currently hasn't been fetched
		 
		// start the progress indicator
		 
		// extend the object
		var Course = Parse.Object.extend("Course");
		var HistoricCourse = Parse.Object.extend("HistoricCourse");
		var CourseType = Parse.Object.extend("CourseType");
		 
		if (arrayString == @"avaliableCourse") {
			var courseTypeQuery = new Parse.Query(CourseType);
			 
			if (_userClassname == @"Person") {
				//courseTypeQuery.contains("peopleAllowedToEnrol", _user.get("personType").get("bitwiseCode"));
			} else {
				//courseTypeQuery.contains("institutionsAllowedToEnrol", _user.get("institutionType").get("bitwiseCode"));
			}
			 
			var mainQuery = new Parse.Query(Course)
			 
			mainQuery.matchesQuery("courseType", courseTypeQuery);
			mainQuery.include("courseType");
			mainQuery.find({
			success: function(results) {
			    // transfer the new data
			    var temp = [CPMutableArray array];
			    	for (var x = 0; x != results.length; x++) {
				    	[temp addObject: results[x]];
			    	}
			    	// we need to sort them into a logical order
			    	var dictOfItems = [CPMutableDictionary dictionary];
			    	for (var i = 0; i != [temp count]; i++) {
				    	var course = [temp objectAtIndex:i];
				    	var type = course.get("courseType").get("typeName");
				    	var allTypes = [dictOfItems objectForKey:type];
				    	if (allTypes == nil) {
					    	// this is the first one
					    	var items = [CPMutableArray array];
					    	[items addObject:course];
					    	[dictOfItems setObject:items forKey:type];
				    	} else {
					    	[allTypes addObject:course];
					    	[dictOfItems setObject:allTypes forKey:type];
				    	}
			    	}
			    	temp = [CPMutableArray array];
			    	// now the dictionary should have the course sorted by type
			    	var allKeys = [dictOfItems allKeys];
			    	for (var i = 0; i != [allKeys count]; i++) {
				    	var items = [dictOfItems objectForKey:allKeys[i]];
				    	[temp addObject:[[MCCourseHeaderObject alloc] initWithTitle:allKeys[i] count:[items count]]];
				    	[temp addObjectsFromArray:items];
			    	}
			    	
			    	_availableCourses = [CPArray arrayWithArray:temp];
			    	_currentDataSource = _availableCourses;
			    	// stop the progress indicator
			    	[progressView stopAnimating];
			    	if ([_availableCourses count] == 0) {
				    	// there are no objects, display the empty image
			    	} else {
				    	// display the data
				    	[_listView reloadData];
			    	}
			    },
			    error: function(error) {
			    	alert("Error: " + error.code + " " + error.message);
			    }
			});
		}
	 } else if ([array count] == 0) {
		 // there are no courses in this set, display the empty image
		 alert("empty");
		 [progressView stopAnimating];
	 } else {
		 // this data is good to go
		 _currentDataSource = array;
		 [_listView reloadData];
		 [progressView stopAnimating];
	 }
	 
	}
 
 // list view delegate
 
-(int) numberOfRowsInListView:(SLListView)list {
	return [_currentDataSource count];
}

-(int) listview:(SLListView)list heightForRow:(int)row {
	try {
		if ([[_currentDataSource objectAtIndex:row] isKindOfClass:[MCCourseHeaderObject class]]) {
			return 25.0;
		}
	} catch(exp) {
		return 46.0;
	}
}

-(id) listview:(SLListView)list objectForRow:(int)row {
	var object = [_currentDataSource objectAtIndex:row];
	return object;
}

-(CPView) listview:(SLListView)list viewForRow:(int)row {
	try {
		if ([[_currentDataSource objectAtIndex:row] isKindOfClass:[MCCourseHeaderObject class]]) {
			var viewController = [[MCCourseHeaderViewController alloc] initWithCibName:@"MCCourseHeaderView" bundle:nil];
		}
	} catch(exp) {
		var viewController = [[MCCourseCellViewController alloc] initWithCibName:@"MCCourseCellView" bundle:nil];
	}
	return [viewController view];
}


 
 // filter bar delegate
 
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

- (BOOL)selectionShouldChangeInListview:(id)aListView
{
	return true;
}

- (BOOL)listview:(id)aListView shouldSelectRow:(int)aRow
{
	try {
		if ([[_currentDataSource objectAtIndex:aRow] isKindOfClass:[MCCourseHeaderObject class]]) {
			return false;
		}
	} catch(exp) {
		return true;
	}
}

- (void)listviewSelectionDidChange:(id)aListView
{
	[_delegate courseSelectionHasChanged:[_currentDataSource objectAtIndex:[aListView _clickedRow]]];
}

 @end