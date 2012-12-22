/*
 * MCFilterView.j
 * Marist Connect
 *
 * Created by Steffan Levet on December 22, 2012.
 * Copyright 2012, Marist Education Ministry All rights reserved.
 */


@import <Foundation/Foundation.j>

/*
MCFilterBarThemeDark  = 0;
MCFilterBarThemeLight = 1;

MCFilterBarAnchorLeft   = 0;
MCFilterBarAnchorCentre = 1;
MCFilterBarAnchorRight  = 2;

var MCFilterBarDataSource_numberOfButtonsInFilterBar_         = 1 << 0,
	MCFilterBarDataSource_filterBar_titleForIndex_            = 1 << 1,
	MCFilterBarDataSource_filterBar_identifierForIndex_       = 1 << 2;
	
var MCFilterBarDelegate_filterBar_itemSelectedWithIdentifier_ = 1 << 0;
*/

@implementation MCFilterView : CPView
{
	/*
CPMutableArray _buttons;
	
	MCFilterBarTheme _theme;
	MCFilterBarAnchor _anchor;
	
	id _dataSource;
	CPInteger _implementedDataSourceMethods;
	
	id _delegate;
	CPInteger _implementedDelegateMethods;
*/
}

/*
- (id)initWithFrame:(CGRect)frame theme:(MCFilterBarTheme)theme anchor:(MCFilterBarAnchor)anchor {
	self = [super initWithFrame:frame];
	
	if (self) {
		_theme = theme;
		_anchor = anchor;
	}
	
	return self;
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

- (void) drawRect:(CPRect)aRect {
	//draw background
	var path = [CPBezierPath bezierPathWithRect:[self bounds]];
	if (_theme == MCFilterBarThemeDark) {
		var image = [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/filter_bar_background.png"];
		[[CPColor colorWithPatternImage:image] setFill];
	} else {
		[[CPColor whiteColor] setFill];
	}
	[path fill];
}

- (void)reloadData {

	// remove the old views
	var views = [self subviews];
	for (CPView view in views) {
		[view removeFromSuperViewWithoutSetNeedsDisplay];
	}
	
	// reset our internal store
	_buttons = [CPMutableArray array];
	
	// find out how many buttons we are going to display
	CPInteger numberOfButtons = 0;
	if ((_implementedDataSourceMethods & MCFilterBarDataSource_numberOfButtonsInFilterBar_)) {
		numberOfButtons = [_dataSource numberOfButtonsInFilterBar:self];
	}
	
	// iterate through and create each of the buttons
	for (int i = 0; i != numberOfButtons; i++) {
		
	}
	
}
*/

@end

@implementation MCFilterViewButton : CPControl
{
	CPTextField _textField;
	CPString _title;
	MCFilterBarTheme _theme;
	int _state;
	
}

- (id)initWithTheme:(MCFilterBarTheme)theme {
	self = [super init];
	
	if (self) {
	window.console.log("2");
		_state = CPOffState;
		window.console.log("2");
		_theme = theme
		window.console.log("2");
	}
	
	return self;
}

-(int) state {
	return _state;
}

-(void) setState:(int)aState {
	_state = anState;
}

-(void) setTitle:(CPString)aString {
	_title = aString;
	[_textField setStringValue:_title];
}

-CPString) title {
	return _title;
}

-(void) awakeFromCib {
	_textField = [CPTextField labelWithTitle:_title];
	[_textField setDrawsBackground:NO];
	[_textField setTextColor:[CPColor blackColor]];
	[self addSubView:_textField];
	[self sizeToFit];
}

-(void) sizeToFit {
	[_textField sizeToFit];
	[self setFrame:CGRectMake([[[_textField frame] size] width] + 16, 17)];
	[_textField center];
}

-(void) mouseDown:(CPEvent)anEvent {
	// switch the state and call the target-action
	if (_state == CPOnState) {
		_state = CPOffState;
		// set the text colour
		if (_theme == CPFilterBarThemeDark) {
			[_textField setTextColor:[CPColor blackColor]];
		} else {
			[_textField setTextColor:[CPColor grayColor]];
		}
	} else {
		_state = CPOnState;
		// set the text colour
		if (_theme == CPFilterBarThemeDark) {
			[_textField setTextColor:[CPColor whiteColor]];
		} else {
			[_textField setTextColor:[CPColor blackColor]];
		}
	}
	[self setNeedsDisplay:YES];
	[[self target] performSelector:[self action]];
}

-(void) drawRect:(CPRect)aRect {
	
	if (_state == CPOnState) {
		// we need to draw the background
		CPImage image;
				
		if (_theme == CPFilterBarThemeDark) {
			image = [CPThreePartImage initWithImageSlices: [CPArray arrayWithObjects: 
			[[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/filterbutton_left_dark.png"],
			[[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/filterbutton_centre_dark.png"],
			[[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/filterbutton_right_dark.png"]]];
		} else {
			image = [CPThreePartImage initWithImageSlices: [CPArray arrayWithObjects: 
			[[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/filterbutton_left_light.png"],
			[[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/filterbutton_centre_light.png"],
			[[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/filterbutton_right_light.png"]]];
		}
		CPColor fillColor = [CPColor colorWithPatternImage:image];
		[fillColor setFill];
		[[CPBezierPath bezierPathWithRect:[self bounds]] fill];
	}
}

@end