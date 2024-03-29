/*
 * MCFilterView.j
 * Marist Connect
 *
 * Created by Sheldon Levet on December 23, 2012.
 * Copyright 2012, Marist Education Ministry All rights reserved.
 */

@import <Foundation/Foundation.j>

//set enums
MCFilterViewThemeDark  = 0;
MCFilterViewThemeLight = 1;

MCFilterViewAnchorLeft   = 0;
MCFilterViewAnchorCentre = 1;
MCFilterViewAnchorRight  = 2;

var MCFilterBarDataSource_numberOfButtonsInFilterBar_         = 1 << 0,
	MCFilterBarDataSource_filterBar_titleForIndex_            = 1 << 1,
	MCFilterBarDataSource_filterBar_identifierForIndex_       = 1 << 2;
	
var MCFilterBarDelegate_filterBar_itemSelectedWithIdentifier_ = 1 << 0;

@implementation MCFilterView : CPView
{
	CPMutableArray _buttons @accessors;
	CPSize _size;
	
	MCFilterBarTheme _theme;
	MCFilterBarAnchor _anchor;
	
	id _dataSource;
	CPInteger _implementedDataSourceMethods;
	
	id _delegate;
	CPInteger _implementedDelegateMethods;
	
	id currentButton;
}

- (id)initWithWidth:(int)width Buttons:(CPMutableArray)buttons Theme:(CPString)theme Anchor:(CPString)anchor
{
	self = [super initWithFrame:CGRectMake(0.0, 0.0, width, 25.0)];
	
	if (self)
	{
		_theme = theme;
		_anchor = anchor;
	}
	
	return self;
}

- (void)setAnchor:(MCFilterViewAnchor)anAnchor
{
	_anchor = anAnchor;
}

- (void)setTheme:(MCFilterViewTheme)aTheme
{
	_theme = aTheme;
	[self setNeedsDisplay:YES];
}

- (void)setWidth:(float)aWidth
{
	[self setFrameSize:CGSizeMake(aWidth, [self frame].size.height)];
}

- (void)filterButtonWasClicked:(id)aFilterButton
{
	[currentButton setState:0];
	[currentButton setNeedsDisplay:YES];
	currentButton = aFilterButton;
	[_delegate filterBar:self itemSelectedWithIdentifier:[aFilterButton identifier]];
}

- (void)resizeUI:(id)frame
{
	[self setFrameSize:CGSizeMake(frame.size.width, 25.0)];
	[self reloadData];
}

- (void)reloadData {
	// reset our internal store
	_buttons = [[CPMutableArray alloc] init];
	
	var views = [self subviews];
	if (views) {
		for (var x=0;x<[views count];x++) {
			[[views objectAtIndex:x] removeFromSuperview];
		}
	}
	
	// find out how many buttons we are going to display
	var numberOfButtons = 0;
	if ((_implementedDataSourceMethods & MCFilterBarDataSource_numberOfButtonsInFilterBar_)) {
		numberOfButtons = [_dataSource numberOfButtonsInFilterBar:self];
	}
	
	// iterate through and create each of the buttons
	var absWidth = -10;
	for (var i = 0; i != numberOfButtons; i++) {
		text = [_dataSource filterBar:self titleForIndex:i];
		identifier = [_dataSource filterBar:self identifierForIndex:i];
		var button = [[MCFilterViewButton alloc] initWithTheme:_theme title:text identifier:identifier];
		[button awakeFromCib];
		[button setTarget:self];
		[_buttons addObject:button];
		absWidth += [button frame].size.width + 10;
	}
	
	//calculate start offset
	var xStr = 0;
	if (_anchor == MCFilterViewAnchorLeft) {
		xStr = 20.0;
	} else if (_anchor == MCFilterViewAnchorRight) {
		xStr = [self frame].size.width - 20.0 - absWidth;
	} else {
		xStr = (([self frame].size.width - absWidth) / 2);
	}
	
	//iterate through and set anchors based on anchor
	for (var i = 0; i != numberOfButtons; i++) {
		var button = [_buttons objectAtIndex:i];
		[button setFrameOrigin:CGPointMake(xStr ,4.0)];
		[self addSubview:[_buttons objectAtIndex:i]];
		xStr += [button frame].size.width + 10;
	}
	
	[[_buttons objectAtIndex:0] setState:1];
	[_delegate filterBar:self itemSelectedWithIdentifier:[[_buttons objectAtIndex:0] identifier]];
	currentButton = [_buttons objectAtIndex:0];
}

-(void) setDataSource:(id)aDataSource {
	if (aDataSource == _dataSource) {
		return;
	}
	_dataSource = aDataSource;
	_implementedDataSourceMethods = 0;
	
	if (!_dataSource) {
		return;
	}
	
	if ([_dataSource respondsToSelector:@selector(numberOfButtonsInFilterBar:)]) {
		_implementedDataSourceMethods |= MCFilterBarDataSource_numberOfButtonsInFilterBar_;
	}
	if ([_dataSource respondsToSelector:@selector(filterBar:titleForIndex:)]) {
		_implementedDataSourceMethods |= MCFilterBarDataSource_filterBar_titleForIndex_;
	}
	if ([_dataSource respondsToSelector:@selector(filterBar:identifierForIndex:)]) {
		_implementedDataSourceMethods |= MCFilterBarDataSource_filterBar_identifierForIndex_;
	}
}

-(void) setDelegate:(id)aDelegate {
	if (aDelegate == _delegate) {
		return;
	}
	
	_delegate = aDelegate;
	_implementedDelegateMethods = 0;
	
	if (!_delegate) {
		return;
	}
	
	if ([_delegate respondsToSelector:@selector(filterBar:itemSelectedWithIdentifier:)]) {
		_implementedDelegateMethods |= MCFilterBarDelegate_filterBar_itemSelectedWithIdentifier_;
	}
	
}

- (void)drawRect:(CPRect)aRect
{
	if (_theme == MCFilterViewThemeDark) {
		var path = [CPBezierPath bezierPathWithRect:[self bounds]];
		var fillColor = [CPColor colorWithPatternImage: [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/filter_bar_background.png"]];
		[fillColor setFill];
		[path fill];
	} else {
		var path = [CPBezierPath bezierPathWithRect:[self bounds]];
		var fillColor = [CPColor whiteColor];
		[fillColor setFill];
		[path fill];
	}
}

@end


//inner button class
@implementation MCFilterViewButton : CPView
{
	CPTextField _textField;
	CPString _title;
	MCFilterBarTheme _theme;
	int _state;
	id _target;
	CPString _identifier;
	BOOL _isMouseInside;
}

- (id)initWithTheme:(MCFilterViewTheme)theme title:(CPString)title identifier:(CPString)identifier{
	self = [super init];
	
	if (self) {
		_identifier = identifier;
		_state = 0;
		_isMouseInside = false;
		_theme = theme;
		_title = title;
	}
	
	return self;
}

- (void)setTarget:(id)aTarget
{
	_target = aTarget;
}

-(int) state {
	return _state;
}

-(void) setState:(int)aState {
	if (_state == aState) {return}
	_state = aState;
	if (_state == 1) {
		// set the text colour
		if (_theme == MCFilterViewThemeDark) {
			[_textField setTextColor:[CPColor whiteColor]];
		} else {
			[_textField setTextColor:[CPColor blackColor]];
		}
	} else {
		// set the text colour
		if (_theme == MCFilterViewThemeDark) {
			[_textField setTextColor:[CPColor blackColor]];
		} else {
			[_textField setTextColor:[CPColor grayColor]];
		}
	}
}

-(void) setTitle:(CPString)aString {
	_title = aString;
	[_textField setStringValue:_title];
}

-(CPString) title {
	return _title;
}

-(void) awakeFromCib {
	_textField = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
	[_textField setFrameSize:CGSizeMake(20.0,17.0)];
	[_textField setStringValue:_title];
	[_textField setFont:[CPFont boldFontWithName:@"Lucida Grande" size:11.0]];
	[_textField setLineBreakMode:CPLineBreakByTruncatingTail];
	if (_theme == MCFilterViewThemeDark) {
		[_textField setTextColor:[CPColor blackColor]];
	} else {
		[_textField setTextColor:[CPColor grayColor]];
	}
	[self addSubview:_textField];
	[self sizeToFit];
	self._DOMElement.addEventListener("click", function() {[self mouseDown];}, false); 
	self._DOMElement.addEventListener("mouseover", function() {[self mouseEntered];}, false); 
	self._DOMElement.addEventListener("mouseout", function() {[self mouseExited];}, false); 
}

-(void) sizeToFit {
	[_textField sizeToFit];
	var width = [_textField frame].size.width + 16;
	width += (8 - width % 8);
	[self setFrameSize:CGSizeMake(width, 17)];
	var strX = (width - [_textField frame].size.width) / 2.0;
	var strY = (15 - [_textField frame].size.height) / 2.0;
	[_textField setFrameOrigin:CGPointMake(strX ,strY)];
}

- (CPString)identifier
{
	return _identifier;
}

- (void)mouseDown
{
	// switch the state and call the target-action
	if (_state == 0) {[self setState:1];}
	[self setNeedsDisplay:YES];
	[_target filterButtonWasClicked:self];
}

- (void)mouseEntered
{
	_isMouseInside = true;
	[self setNeedsDisplay:YES];
}

- (void)mouseExited
{
	_isMouseInside = false;
	[self setNeedsDisplay:YES];
}

/*
-(void) mouseDown:(CPEvent)anEvent 
{
	window.console.log("2");
	// switch the state and call the target-action
	if (_state == 0) {[self setState:1];}
	[self setNeedsDisplay:YES];
	[_target filterButtonWasClicked:self];
}

- (void)mouseEntered:(CPEvent)anEvent
{
	window.console.log("0");
	_isMouseInside = true;
	[self setNeedsDisplay:YES];
}

- (void)mouseExited:(CPEvent)anEvent
{
	window.console.log("1");
	_isMouseInside = false;
	[self setNeedsDisplay:YES];
}
*/

-(void) drawRect:(CPRect)aRect {
	if (_theme == MCFilterViewThemeDark) {
		if (_state == 1) {
			//alert("making clicked");
			var leftPath = [CPBezierPath bezierPathWithRect:CGRectMake(0.0,0.0,8.0,17.0)];
			var fillColor = [CPColor colorWithPatternImage: [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/filterbutton_left_dark.png" size:CGSizeMake(8.0,17.0)]];
			[fillColor setFill];
			[leftPath fill];
			
			var midWidth = [self frame].size.width - 16;
			var midPath = [CPBezierPath bezierPathWithRect:CGRectMake(8.0,0.0,midWidth,17.0)];
			var fillColor = [CPColor colorWithPatternImage: [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/filterbutton_centre_dark.png" size:CGSizeMake(1.0,17.0)]];
			[fillColor setFill];
			[midPath fill];
			
			var rightPath = [CPBezierPath bezierPathWithRect:CGRectMake(midWidth + 8.0,0.0,8.0,17.0)];
			var fillColor = [CPColor colorWithPatternImage: [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/filterbutton_right_dark.png" size:CGSizeMake(8.0,17.0)]];
			[fillColor setFill];
			[rightPath fill];
		} else {
			if (_isMouseInside) {
				var path = [CPBezierPath bezierPath];
				[path appendBezierPathWithRoundedRect:[self bounds] xRadius:8.5 yRadius:8.5];
				[[CPColor colorWithCalibratedRed:0.6 green:0.6 blue:0.6 alpha:1.0] setFill];
				[path fill];
			}
		}
	} else {
		if (_state == 1) {
			var leftPath = [CPBezierPath bezierPathWithRect:CGRectMake(0.0,0.0,8.0,17.0)];
			var fillColor = [CPColor colorWithPatternImage: [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/filterbutton_left_light.png" size:CGSizeMake(8.0,17.0)]];
			[fillColor setFill];
			[leftPath fill];
			
			var midWidth = [self frame].size.width - 16;
			var midPath = [CPBezierPath bezierPathWithRect:CGRectMake(8.0,0.0,midWidth,17.0)];
			var fillColor = [CPColor colorWithPatternImage: [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/filterbutton_centre_light.png" size:CGSizeMake(1.0,17.0)]];
			[fillColor setFill];
			[midPath fill];
			
			var rightPath = [CPBezierPath bezierPathWithRect:CGRectMake(midWidth + 8.0,0.0,8.0,17.0)];
			var fillColor = [CPColor colorWithPatternImage: [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/filterbutton_right_light.png" size:CGSizeMake(8.0,17.0)]];
			[fillColor setFill];
			[rightPath fill];
		} else {
			if (_isMouseInside) {
				var path = [CPBezierPath bezierPath];
				[path appendBezierPathWithRoundedRect:[self bounds] xRadius:8.5 yRadius:8.5];
				[[CPColor colorWithCalibratedRed:0.9 green:0.9 blue:0.9 alpha:0.8] setFill];
				[path fill];
			}
		}
	}
}

@end