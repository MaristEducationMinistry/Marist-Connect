/*
 * MCHoveringTextField.j
 * Marist Connect
 *
 * Created by Steffan Levet on December 16, 2012.
 * Copyright 2012, Marist Education Ministry All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "MCLoginViewController.j"


@implementation MCHoveringTextField : CPTextField
{
	CPColor defaultColour;
	CPColor secondaryColour;
	CPString url;
	id _target;
	SEL _selector;
}

// They have clicked us, send out a response
- (void)mouseDown:(CPEvent)anEvent
{
	if (url) {
		window.open(url, "_blank");
	} else if (_target && _selector) {
		[_target showForgotPassword];
	}
}

- (void)setAction:(SEL)aSelector forTarget:(id)aTarget
{
	_target = aTarget;
	_selector = aSelector;
}
 
// when the mouse enters we want to change the colour of the text
- (void)mouseEntered:(CPEvent)anEvent
{
  [self setTextColor:secondaryColour];
}

// The mouse has moved out so we want to change the colour back now
- (void)mouseExited:(CPEvent)anEvent
{
	[self setTextColor:defaultColour];
}

- (void)setDefaultColour:(CPColor)aColour
{
	defaultColour = aColour;
	[self setTextColor:defaultColour];
}

- (void)setSecondaryColour:(CPColor)aColour
{
	secondaryColour = aColour;
}

- (void)setURL:(CPString)aUrl
{
	url = [[CPString alloc] init];
	url = aUrl;
}

@end