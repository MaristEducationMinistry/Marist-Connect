/*
 * MCBackgroundView.j
 * Marist Connect
 *
 * Created by Steffan Levet on December 17, 2012.
 * Copyright 2012, Marist Education Ministry All rights reserved.
 */

@import <Foundation/CPObject.j>

@implementation MCBackgroundView : CPView

- (void) drawRect:(CPRect)aRect {
	var path = [CPBezierPath bezierPathWithRect:[self bounds]];
	[[CPColor colorWithPatternImage:[CPImage imageNamed:@"deep-textured-backround"]] setFill];
	[path fill];
}

@end