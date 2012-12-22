
@import <Foundation/Foundation.j>

//MCFilterBarThemeDark  = 0;
//MCFilterBarThemeLight = 1;

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