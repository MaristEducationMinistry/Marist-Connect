/*
 * MCCourseSelectionViewController.j
 * Marist Connect
 *
 * Created by Steffan Levet on December 24, 2012.
 * Copyright 2012, Marist Education Ministry All rights reserved.
 */
 
 @import <Foundation/Foundation.j>
 
 @implementation MCCourseSelectionViewController : CPViewController {
	 @outlet MCFilterView filterView;
	 @outlet CPScrollView scrollView;
	 
	 @outlet EKActivityIndicatorView progressView;
	 @outlet CPImageView emptyImage;
	 
	 SLListView _listView;
	 
	 CPArray _availableCourses;
	 CPArray _currentCourses;
	 CPArray _pastCourses;
	 
	 CPArray _currentDataSource;
	 
	 Object _user;
	 CPString _userClassname;
 }
 
 -(id) initWithUser:(id)aUser ofClass:(CPString)classname {
 	window.console.log("in");
	 self = [super initWithCibName:@"MCCourseSelectionViewController" bundle:nil];
	 window.console.log("out");
	 if (self) {
	 	window.console.log("in again");
		 //_user = aUser;
		 _userClassname = classname;
	 }
	 return self;
 }
 
 -(void) awakeFromCib {
	 
	 // set up the filter bar and list view
	 [filterView setTheme:MCFilterViewThemeDark];
	 [filterView setAnchor:MCFilterViewAnchorCentre];
	 [filterView setDataSource:self];
	 [filterView setDelegate:self];
	 
	 var image = [[CPImage alloc] initWithContentsOfFile:@"Image Resources/window-noise.png"];
    [scrollView setBackgroundColor:[CPColor colorWithPatternImage:image]];
    
	 _listView = [[SLListView alloc] initWithFrame:CGRectMakeZero()];
	 [_listView setDataSource:self];
	 [_listView setDelegate:self];
	 [scrollView setDocumentView:_listView];
	 // set the empty image
	 
	 // set up the progress indicator
	 
 }
 
 -(void) setCurrentDataSource:(CPArray) array {
	 
	 // first empty the list view and reload the data
	 _currentDataSource = [CPArray array];
	 [_listView reloadData];
	 // make sure the progress indicator and empty image are hidden
	 
	 
	 // check the condition of the new data and handle it apropiatly
	 if (array == nil) {
		 // this set of courses currently hasn't been fetched
		 
		 // start the progress indicator
		 
		 // extend the object
		 var Course = Parse.Object.extend("Course");
		 var HistoricCourse = Parse.Object.extend("HistoricCourse");
		 var CourseType = Parse.Object.extend("CourseType");
		 
		 if ([array isEqualTo: _availableCourses]) {
		 
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
				    	var items = [dictOfItems objectForKey:[allKeys objectForKey:i]];
				    	[temp addObject:[allKeys objectAtIndex:i]];
				    	[temp addObjectsFromArray:items];
			    	}
			    	
			    	_availableCourses = [CPArray arrayWithArray:temp];
			    	// stop the progress indicator
			    	
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
		 
	 } else {
		 // this data is good to go
		 _currentDataSource = array;
		 [_listView reloadData];
	 }
 }
 
 // list view delegate
 
 -(int) numberOfRowsInListView:(SLListView)list {
	return [_currentDataSource count];
}

-(int) listview:(SLListView)list heightForRow:(int)row {
	return 20;
}

-(id) listview:(SLListView)list objectForRow:(int)row {
	return [_currentDataSource objectAtIndex:row];
}

-(CPView) listview:(SLListView)list viewForRow:(int)row {
	var view = [[SLListViewCell alloc] initWithFrame:CGRectMakeZero()];
	if (row % 2 == 0) {
		[view setBackgroundColor:[CPColor blueColor]];
		[view setTempColor:[CPColor blueColor]];
	} else {
		[view setBackgroundColor:[CPColor redColor]];
		[view setTempColor:[CPColor redColor]];
	}
	
	return view;
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
		[self setCurrentDataSource:_availableCourses];
		
	} else if ([identifier isEqualToString: @"Completed"]) {
		[self setCurrentDataSource:_currentCourses];
		
	} else {
		[self setCurrentDataSource:_pastCourses];
		
	}
}

 @end