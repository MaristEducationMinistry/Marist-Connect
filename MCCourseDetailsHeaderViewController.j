@import <Foundation/Foundation.j>
@import "MCHoveringTextField.j"

@implementation MCCourseDetailsHeaderViewController : CPViewController
{
	MCCourseHeaderButton enrollmentButton;
	@outlet CPTextField courseNameLabel;
	@outlet CPTextField courseDateRangeLabel;
	
	//hovering labels
	@outlet MCHoveringTextField viewMapLabel;
	@outlet MCHoveringTextField travelDetailsLabel;
	@outlet MCHoveringTextField teacherAbsencesLabel;
	@outlet CPTextField seperatorLeft;
	@outlet CPTextField seperatorRight;
	
	//map elements
	CPWindow mapSheetWindow;
	CPView mapView;
	CPView coverView;
}

- (void)awakeFromCib
{	
	[viewMapLabel setDefaultColour:[CPColor whiteColor]];
	[viewMapLabel setSecondaryColour:[CPColor blackColor]];
	[viewMapLabel setAction:@selector(viewMap) forTarget:self];
	
	[travelDetailsLabel setDefaultColour:[CPColor whiteColor]];
	[travelDetailsLabel setSecondaryColour:[CPColor blackColor]];
	[travelDetailsLabel setAction:@selector(viewTravelDetails) forTarget:self];
	
	[teacherAbsencesLabel setDefaultColour:[CPColor whiteColor]];
	[teacherAbsencesLabel setSecondaryColour:[CPColor blackColor]];
	[teacherAbsencesLabel setAction:@selector(viewTeacherAbsences) forTarget:self];

	enrollmentButton = [[MCCourseHeaderButton alloc] initWithFrame:CGRectMake(489.0, 20.0, 98.0, 34.0)];
	[enrollmentButton setAutoresizingMask: CPViewNotSizable | CPViewMaxYMargin | CPViewMinXMargin];
	[enrollmentButton setFrameOrigin:CGPointMake([[self view] frame].size.width - 20.0 - 98.0, 20.0)];
	[[self view] addSubview:enrollmentButton];
	
	[[self view] setBackgroundColor:[CPColor colorWithPatternImage: [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/debut_dark.png"]]];
	[[self view] setAutoresizingMask: CPViewMaxYMargin];
}

//label methods
- (void)viewMap
{
	var contentView = [[[[self view] superview] superview] superview];
	var frame = [contentView frame];
	coverView = [[CPView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
	[coverView setBackgroundColor:[CPColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
	var windowView = [[CPView alloc] initWithFrame:CGRectMake(0.0, 0.0, 800.0, 600.0)];
	[windowView setBackgroundColor:[CPColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1]];
	mapSheetWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(0.0, 0.0, 800.0, 600.0) styleMask:CPDocModalWindowMask];
	mapView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 788.0, 588.0)];
    var mapOptions = {
    	center: new google.maps.LatLng(-34.397, 150.644),
        zoom: 16,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    var map = new google.maps.Map(mapView._DOMElement, mapOptions);
    geocoder = new google.maps.Geocoder();
    var address = "87 Meeanee Road, Taradale, Napier, New Zealand";
    geocoder.geocode( { 'address': address}, function(results, status) {
    	if (status == google.maps.GeocoderStatus.OK) {
        	//In this case it creates a marker, but you can get the lat and lng from the location.LatLng
        	map.setCenter(results[0].geometry.location);
        	var marker = new google.maps.Marker({
            	map: map, 
            	position: results[0].geometry.location
            });
        } else {
        	alert("Geocode was not successful for the following reason: " + status);
        }
    });
    var closeButton = [[MCMapCloseButton alloc] initWithFrame:CGRectMake(776.0, 576.0, 24.0, 24.0) forTarget:self];
	[mapSheetWindow setContentView:windowView];
	[[mapSheetWindow contentView] addSubview:mapView];
	[[mapSheetWindow contentView] addSubview:closeButton];
	[contentView addSubview:coverView];
	[[CPApplication sharedApplication] beginSheet:mapSheetWindow modalForWindow:[contentView window] modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (void)closeMap
{
	setTimeout(function() {[coverView removeFromSuperview];}, 300);
	[[CPApplication sharedApplication] endSheet:mapSheetWindow];
}

- (void)viewTravelDetails
{

}

- (void)viewTeacherAbsences
{

}
	
- (void)setCourseName:(CPString)aCourseName
{
	[courseNameLabel setStringValue:aCourseName];
}

- (void)setCourseDateRange:(CPString)aDateRange
{
	[courseDateRangeLabel setStringValue:aDateRange];
}

@end

@implementation MCMapCloseButton : CPImageView
{
	id _target;
}

- (id)initWithFrame:(CGRect)frame forTarget:(id)aTarget
{
	self = [super initWithFrame:frame];
	
	if (self) {
		_target = aTarget;
		var image = [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/sheet_close_button.png"];
		[self setImage:image];
	}
	
	return self;
}

- (void)mouseDown:(CPEvent)aEvent
{
	[_target closeMap];
}

@end

@implementation MCCourseHeaderButton : CPImageView
{
	CPImage _enrolledImage;
	CPImage _enrollImage;
	CPImage _unenrollImage;
	CPImage _enrollImage_down;
	CPImage _unenrollImage_down;
	CPImage _enrollImage_hover;
	
	BOOL _isEnrolled;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	if (self) {
		_isEnrolled = true;
		_enrolledImage = [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/enrolled_button.png"];
		_enrollImage = [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/enrol_button.png"];
		_unenrollImage = [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/un_enrol_button.png"]
		[self setImage:_enrolledImage];
	}
	
	return self;
}

- (void)setIsEnrolled:(BOOL)aState
{
	if (aState) {
		[self setImage:_enrolledImage];
	} else {
		[self setImage:_enrollImage];
	}
}

- (void)mouseDown:(CPEvent)aEvent
{
	if (_isEnrolled) {
		[self setImage:_unenrollImage_down];
	} else {
		[self setImage:_enrollImage_down];
	}
}

- (void)mouseUp:(CPEvent)aEvent
{
	if (_isEnrolled) {
		[self setImage:_unenrollImage];
	} else {
		[self setImage:_enrollImage];
	}
}

- (void)mouseEntered:(CPEvent)aEvent
{
	if (_isEnrolled) {
		[self setImage:_unenrollImage];
	} else {
		[self setImage:_enrollImage_hover];
	}
}

- (void)mouseExited:(CPEvent)aEvent
{
	if (_isEnrolled) {
		[self setImage:_enrolledImage];
	} else {
		[self setImage:_enrollImage_hover];
	}
}

@end