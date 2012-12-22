@import <Foundation/Foundation.j>

@implementation MCFilterView : CPView
{
	CPMutableArray _buttons @accessors;
	CPString _theme @accessors;
	CPSize _size @accessors;
	CPString _anchor @accessors;
}

- (id)initWithSize:(CPSize)viewSize Buttons:(CPMutableArray)buttons Theme:(CPString)theme Anchor:(CPString)anchor
{
	self = [super init];
	
	if (self)
	{
		[self setFrame:CGRectMake(viewSize.width, viewSize.height)];
		
		
	}
	
	return self;
}

- (void)reloadFilterBar
{
	var views = [self subviews];
	for (CPView view in views) {
		[view removeFromSuperViewWithoutSetNeedsDisplay];
	}
	for (var x=0;x<[delegate numberOfButtonsInFilterBar];x++) {
		[_buttons addObject:[[MCFilterBarButton alloc] initWithText:[delegate getTextForButton:x] Color:_theme]];
		[[_buttons objectAtIndex:x] sizeToFit];
		
	}
}

- (void) drawRect:(CPRect)aRect {
	//draw background
	var path = [CPBezierPath bezierPathWithRect:[self bounds]];
	if (_theme == "black") {
		var image = [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/deep-textured-backround.png"];
		[[CPColor colorWithPatternImage:image] setFill];
	} else {
		[[CPColor whiteColor] setFill];
	}
	[path fill];
}