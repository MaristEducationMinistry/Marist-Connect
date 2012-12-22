@import <Foundation/Foundation.j>

@implementation MCFilterBarButton : CPControl
{
	CPString _text @accessors;
	CPString _theme @accessors;
	int _state @accessors;
}

- (id)initWithText:(CPString)buttonText Color:(CPString)themeColor
{
	[self init];
	
	if (self) {
		_state = 0;
	}
	
	return self;
}

- (void)sizeToFit
{
	var size = [_text sizeWithFont:[CPFont systemFontOfSize:[CPFont systemFontSize]]];
	[self setFrame:CGRectMake(size.width + 8, size.height + 8)];
}

- (void)mouseDown:(CPEvent)anEvent
{
	[self.target performSelector:self.action];
}

- (void)drawRect:(CPRect)aRect
{
	if (_theme == "black") {
		
	} else {
		
	}
}

- (void)setState:(int)aState
{
	_state = aState;
}