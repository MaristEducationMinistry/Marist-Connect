@import <Foundation/Foundation.j>

@implementation MCCourseViewController : CPViewController
{
	@outlet CPTableView courseTableView;
	
	CPMutableArray courseNameArray @accessors;
}

- (void)awakeFromCib
{
	var dataView = [[MCCourseTableRowView alloc] init];
	var column = [[CPTableColumn alloc] initWithIdentifier:@"name"];
	[[column headerView] setStringValue:@"name"]
	[column setDataView:dataView];
	[courseTableView addTableColumn:column];
	courseNameArray = [[CPMutableArray alloc] init];
	[courseTableView setDelegate:self];
	[courseTableView setDataSource:self];
	
	window.console.log(courseTableView);
	var course = Parse.Object.extend('Course');
	var query = new Parse.Query(course);
	query.find( {
		success: function(results) {
			for (var i=0;i<results.length;i++) {
				[courseNameArray addObject:results[i]];
			}
			window.console.log(courseNameArray);
			[courseTableView reloadData];
		},
		error: function(results, error)
		{
			alert(error.message);
		}
	});
}

- (int)numberOfRowsInTableView:(CPTableView)aTableView
{
	return [courseNameArray count];
}

- (id)tableView:(CPTableView)aTableView objectValueForTableColumn:(CPTableColumn)aColumn row:(int)aRowIndex
{
	//window.console.log([courseNameArray objectForIndex:aRowIndex]);
	//alert([aColumn identifier]);
	return [courseNameArray objectAtIndex:aRowIndex].get('name');
}

- (BOOL)tableView:(CPTableView)tableView isGroupRow:(int)row
{
	return false;
}

- (float)tableView:(CPTableView)tableView heightOfRow:(int)row
{
	return 67.0;
}

@end

@implementation MCCourseTableRowView : CPView
{
	@outlet CPTextField nameField;
	CPString nameText;
}

- (id)initWithCoder:(CPCoder)aCoder
{
	self = [super initWithCoder:aCoder];
	window.console.log('coder');
	if (self) {
		nameText = [aCoder decodeObjectForKey:@"name"];
	}
	
	return self
}

- (void)awakeFromCib
{
	alert('awake');
	//[nameField setStringValue:nameText];
	var label = [[CPTextField alloc] initWithFrame:CGRectMake(0.0,0.0,100.0,67.0)];
	[label setStringValue:@"hello"];
	[self addSubview:label];
	alert([self subviews]);
}

/*
-(void) drawRect:(CGRect)aRect {
	var path = [CPBezierPath bezierPathWithRect:[self bounds]];
	[[CPColor redColor] setFill];
	[path fill];
}
*/

-(void) setObjectValue:(id)aObject {
	window.console.log('getting object: '+aObject);
	[nameField setStringValue:aObject];
	nameText = aObject;
}

-(void) mouseDown:(CPEvent)aEvent {
	[super mouseDown:aEvent];
	alert('done');
}
@end