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
	var image = [[CPImage alloc] initWithContentsOfFile:@"deep-textured-backround.png"];
	[[CPColor colorWithPatternImage:image] setFill];
	[path fill];
	//[super drawRect:aRect];
}

/*
- (void)drawBackground
{
	var image = [[CPImage alloc] initWithContentsOfFile:@"deep-textured-backround.png"];
	[self setBackgroundColor:[CPColor colorWithPatternImage:image]];
}
*/

@end