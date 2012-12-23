
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
	
	CPColor _tempColor;
}

-(void) setSelected:(BOOL)selected {
	if (_selected == selected) {return;}
	_selected = selected;
	if (_selected) {
		_tempColor = [self backgroundColor];
		[self setBackgroundColor:[CPColor blackColor]];
	} else {
		[self setBackgroundColor:_tempColor];
	}
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
	[self setSelected:YES];
}

-(void) setTempColor:(CPColor)color {
	_tempColor = color;
}

@end