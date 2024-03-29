/*
 * SLListViewCell.j
 * Marist Connect
 *
 * Created by Steffan Levet on December 23, 2012.
 * Copyright 2012, Marist Education Ministry All rights reserved.
 */

@import <Foundation/CPObject.j>

@implementation SLListViewCell : CPView {
	
	BOOL _selected;
	id _representedObject;
	CPView _listView;
	
}

-(void) setSelected:(BOOL)selected {
	[self setNeedsDisplay:YES];
	if (_selected == selected) {return;}
	_selected = selected;
}


-(BOOL) isSelected {
	return _selected;
}

-(void) setRepresentedObject:(id)aRepresentedObject {
	_representedObject = aRepresentedObject;
}

-(id) representedObject {
	return _representedObject;
}

-(void) setListView:(CPView)aView {
	_listView = aView;
}

-(CPView) listView {
	return _listView;
}

-(void) mouseDown:(CPEvent)aEvent {
	[[self listView] rowRecievedEvent:self];
}

-(void) drawRect:(CGRect)dirtyRect {
	// if this cell is selected we need to draw the highlight color
	if (_selected) {
		// the gradient colors take priority
		var gradientColors = [_listView gradientHighlightColors];
		if (gradientColors) {
			// we have a set of gradient colors, draw
			var startPoint = CGPointMake(0, [self frame].size.height); // the bottom
			var endPoint = CGPointMake(0, 0); 
			
			var startColor = [gradientColors objectAtIndex:0];
			var endColor = [gradientColors objectAtIndex:1];
			
			var currentContext = [[CPGraphicsContext currentContext] graphicsPort]; 
			var fStyle = currentContext.createLinearGradient(startPoint.x, startPoint.y, endPoint.x, endPoint.y); 
			
			fStyle.addColorStop(0.0, "rgba("+ROUND(255*[startColor components][0])+", "+ROUND(255*[startColor components][1])+", "+ROUND(255*[startColor components][2])+", "+[startColor components][3]+")"); 
			fStyle.addColorStop(1.0, "rgba("+ROUND(255*[endColor components][0])+", "+ROUND(255*[endColor components][1])+", "+ROUND(255*[endColor components][2])+", "+[endColor components][3]+")");
			
			currentContext.fillStyle = fStyle; currentContext.fillRect(0, 0, [self frame].size.width, [self frame].size.height); 
	
		} else {
			// attempt to draw a single color background
			var highlightColor = [_listView highlightColor];
			if (highlightColor) {
				window.console.log([self frame]);
				var size = [self frame].size;
				var path = [CPBezierPath bezierPathWithRect:CGRectMake(0.0, 0.0, size.width, size.height)];
				[highlightColor setFill];
				[path fill];
			}
		}
	}
	
	// attempt to draw a divider
	var dividerColor = [_listView dividerColor];
	if (dividerColor) {
		var bp = [[CPBezierPath alloc] init];
		[bp setLineWidth:1.0];
		[dividerColor setStroke];
		var yPos = [self frame].size.height;
		[CPBezierPath strokeLineFromPoint:CGPointMake(0.0,yPos) toPoint:CGPointMake([self frame].size.width, yPos)];

	}
}

@end