@import <Foundation/Foundation.j>
@import "MCHoveringTextField.j"
@import "LPCardFlipController.j"
@import "MCSharedData.j"

@implementation MCCourseDetailsHeaderViewController : CPViewController
{
	MCCourseHeaderButton enrollmentButton;
	MCCourseConfirmButton enrollConfirmButton;
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
	
	id  _parseObject;
	int _status; 
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
	[enrollmentButton setDelegate:self];
	[[self view] addSubview:enrollmentButton];
	
	/*
enrollConfirmButton = [[MCCourseConfirmButton] initWithFrame:CGRectMake(489.0, 20.0, 98.0, 34.0)];
	[enrollConfirmButton setAutoresizingMask: CPViewNotSizable | CPViewMaxYMargin | CPViewMinXMargin];
	[enrollConfirmButton setFrameOrigin:CGPointMake([[self view] frame].size.width - 20.0 - 98.0, 20.0)];
	[enrollConfirmButton setDelegate:self];
*/
	
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
	var windowView = [[CPView alloc] initWithFrame:CGRectMake(0.0, 0.0, 800.0, 550.0)];
	[windowView setBackgroundColor:[CPColor clearColor]];
	mapSheetWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(0.0, 0.0, 800.0, 550.0) styleMask:CPDocModalWindowMask];
	mapView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 800.0, 600.0)];
	[mapView setBackgroundColor:[CPColor clearColor]]
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
    var closeButton = [[MCMapCloseButton alloc] initWithFrame:CGRectMake(frame.size.width - ((frame.size.width - 800) /2) - 96.0, 502.0, 98.0, 31.0) forTarget:self];
	[mapSheetWindow setContentView:windowView];
	[mapSheetWindow setBackgroundColor:[CPColor clearColor]];
	[[mapSheetWindow contentView] addSubview:mapView];
	[coverView addSubview:closeButton];
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

- (void)setCourseObject:(id)parseObject status:(int)aStatus
{
	_status = aStatus;
	if (aStatus == 0) {
		[enrollmentButton setIsEnrolled:NO];
	} else if (aStatus == 1) {
		[enrollmenrButton setIsEnrolled:YES];
	} else {
		[enrollmentButton setHidden:YES];
	}
	_parseObject = parseObject;
	
}
	
- (void)setCourseName:(CPString)aCourseName
{
	[courseNameLabel setStringValue:aCourseName];
}

- (void)setCourseDateRange:(CPString)aDateRange
{
	[courseDateRangeLabel setStringValue:aDateRange];
}

- (void)unenrollButtonClicked
{
	if (_status == 0) {
		//enroll
		var temp = [[MCSharedData sharedCentre] pClass];
		temp.relation("attendingCourses").add(_parseObject)
		temp.save(null, {
			success: function(user) {
				[enrollmentButton setIsEnrolled:YES];
			},
			error: function(user, error) {
				alert(error.message);
			}
		});
	} else {
		var cardFlipController = [LPCardFlipController sharedController];
		[cardFlipController setDelegate:self]; 
		[cardFlipController setStartCenter:[enrollmentButton center] endCenter:[enrollmentButton center]];
		[cardFlipController flipWithView:enrollmentButton backView:enrollConfirmButton inAxes:"X"];
		setTimeout(function() {[[self view] addSubview:enrollConfirmButton]}, 650);
	}
}

@end

//map closing button
@implementation MCMapCloseButton : CPImageView
{
	CPImage _default;
	CPImage _hover;
	CPImage _click;

	id _target;
}

- (id)initWithFrame:(CGRect)frame forTarget:(id)aTarget
{
	self = [super initWithFrame:frame];
	
	if (self) {
		_target = aTarget;
		_default = [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/map_close_button.png"];
		_hover = [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/map_close_button_hover.png"];
		_click = [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/map_close_button_clicked.png"];
		[self setImage:_default];
		self._DOMElement.addEventListener("click", function() {[self mouseDown];}, false); 
		self._DOMElement.addEventListener("mouseover", function() {[self mouseEntered];}, false); 
		self._DOMElement.addEventListener("mouseout", function() {[self mouseExited];}, false); 
	}
	
	return self;
}

- (void)mouseDown
{
	[self setImage:_click];
	[_target closeMap];
}

- (void)mouseEntered
{
	[self setImage:_hover];
}

- (void)mouseExited
{
	[self setImage:_default];
}

@end

//course enrollment button
@implementation MCCourseHeaderButton : CPImageView
{
	CPImage _enrolledImage;
	CPImage _enrollImage;
	CPImage _unenrollImage;
	CPImage _enrollImage_down;
	CPImage _unenrollImage_down;
	CPImage _enrollImage_hover;
	
	BOOL _isEnrolled;
	id _delegate;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	if (self) {
		_isEnrolled = false;
		_enrolledImage = [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/enrolled_button.png"];
		_enrollImage = [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/enrol_button.png"];
		_unenrollImage = [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/un_enrol_button.png"]
		_enrollImage_hover = [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/enrol_button_hover.png"];
		_enrollImage_down = [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/enrol_button_clicked.png"];
		[self setImage:_enrollImage];
	}
	
	return self;
}

- (void)setDelegate:(id)aDelegate
{
	_delegate = aDelegate;
}

- (void)setIsEnrolled:(BOOL)aState
{
	_isEnrolled = aState;
	if (aState) {
		[self setImage:_enrolledImage];
	} else {
		[self setImage:_enrollImage];
	}
}

- (void)mouseDown:(CPEvent)aEvent
{
	if (_isEnrolled) {
		if ([self image] == _unenrollImage) {
			[self setImage:_unenrollImage_down];
			[_delegate unenrollButtonClicked];
		}
	} else {
		[self setImage:_enrollImage_down];
		[_delegate unenrollButtonClicked];
	}
}

- (void)mouseUp:(CPEvent)aEvent
{
	if (_isEnrolled) {
		if ([self image] == _unenrollImage_down) {
			[self setImage:_unenrollImage];
		}
	} else {
		[self setImage:_enrollImage_hover];
	}
}

- (void)mouseEntered:(CPEvent)aEvent
{
	if (_isEnrolled) {
	window.mouseHoverInt = setInterval(function() {
		if (_isEnrolled) {
			[self setImage:_unenrollImage];
		}
		window.clearInterval(window.mouseHoverInt);
	}, 500);
	} else {
		[self setImage:_enrollImage_hover];
	}
}

- (void)mouseExited:(CPEvent)aEvent
{
	try {window.clearInterval(window.mouseHoverInt);} catch(exp) {var x =0}
	if (_isEnrolled) {
		[self setImage:_enrolledImage];
	} else {
		[self setImage:_enrollImage];
	}
}

@end

//course enrollment confirmation button
@implementation MCCourseConfirmButton : CPImageView
{
	BOOL _isEnrolled;
	id _delegate;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	if (self) {
		
	}
	
	return self;
}

- (void)setDelegate:(id)aDelegate
{
	_delegate = aDelegate;
}

- (void)mouseDown:(CPEvent)aEvent
{
	
}

- (void)mouseUp:(CPEvent)aEvent
{
	
}

- (void)mouseEntered:(CPEvent)aEvent
{
	
}

- (void)mouseExited:(CPEvent)aEvent
{
	
}

@end