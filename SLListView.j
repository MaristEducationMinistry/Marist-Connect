/*
 * SLListView.j
 * Marist Connect
 *
 * Created by Steffan Levet on December 23, 2012.
 * Copyright 2012, Marist Education Ministry All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "SLListViewCell.j"
@import "MCCourseCellView.j"
@import "MCCourseHeaderView.j"





var SLListViewDataSource_numberOfRowsInListView_        = 1 << 0,
    SLListViewDataSource_listview_heightOfRow_          = 1 << 1,
    SLListViewDataSource_listview_objectForRow_         = 1 << 2,
    SLListViewDataSource_listview_viewForRow_           = 1 << 3;
    
var SLListViewDelegate_selectionShouldChangeInListview_ = 1 << 0,
	SLListViewDelegate_listview_shouldSelectRow_        = 1 << 1,
	SLListViewDelegate_listviewSelectionDidChange_      = 1 << 2;


@implementation SLListView : CPView {
	id                  _dataSource;
    CPInteger           _implementedDataSourceMethods;

    id                  _delegate;
    CPInteger           _implementedDelegateMethods;
    
    int            		_numberOfRows;
    CPMutableArray      _cachedViews;
    
    int           		_clickedRow;
    CPIndexSet          _selectedRowIndexes;
    
    BOOL                _allowsMultipleSelection;
    BOOL                _allowsEmptySelection;
    
    CPColor 			_highlightColor;
    CPArray 			_gradientHighlightColors;
    CPColor 			_dividerColor;

}


-(void) setDataSource:(id)aDataSource {
	if (_dataSource === aDataSource)
        return;

    _dataSource = aDataSource;
    _implementedDataSourceMethods = 0;

    if (!_dataSource)
        return;


    if ([_dataSource respondsToSelector:@selector(numberOfRowsInListView:)])
        _implementedDataSourceMethods |= SLListViewDataSource_numberOfRowsInListView_;

    if ([_dataSource respondsToSelector:@selector(listview:heightOfRow:)])
        _implementedDataSourceMethods |= SLListViewDataSource_listview_heightOfRow_;

    if ([_dataSource respondsToSelector:@selector(listview:objectForRow:)])
        _implementedDataSourceMethods |= SLListViewDataSource_listview_objectForRow_;

    if ([_dataSource respondsToSelector:@selector(listview:viewForRow:)])
        _implementedDataSourceMethods |= SLListViewDataSource_listview_viewForRow_;

    [self reloadData];

}

-(id) dataSource {
	return _dataSource;
}

-(void) setDelegate:(id)aDelegate {
	if (_delegate === aDelegate)
        return;

    _delegate = aDelegate;
    _implementedDelegateMethods = 0;

    if (!_delegate)
        return;


    if ([_delegate respondsToSelector:@selector(selectionShouldChangeInListview:)])
        _implementedDelegateMethods |= SLListViewDelegate_selectionShouldChangeInListview_;
        
    if ([_delegate respondsToSelector:@selector(listview:shouldSelectRow:)])
        _implementedDelegateMethods |= SLListViewDelegate_listview_shouldSelectRow_;
        
    if ([_delegate respondsToSelector:@selector(listviewSelectionDidChange:)])
        _implementedDelegateMethods |= SLListViewDelegate_listviewSelectionDidChange_;
}

-(id) delegate {
	return _delegate;
}

-(void) setHighlightColor:(CPColor)aColor {
	_highlightColor = aColor;
}

-(CPColor) highlightColor {
	return _highlightColor;
}

-(void) setGradientHighlightColors:(CPArray)colors {
	if ([colors count] != 2) {
		window.console.log("SLListView setGradientHighlightColors requires array of length 2");
		return;
	}
	
	_gradientHighlightColors = colors;
}

-(CPArray) gradientHighlightColors {
	return _gradientHighlightColors;
}

-(void) setDividerColor:(CPColor)color {
	_dividerColor = color;
}

-(CPColor) dividerColor {
	return _dividerColor;
}

-(void) reloadData {
	
	// remove the old data and reset
	
	if (_cachedViews != nil) {
		for (var x = 0; x != [_cachedViews count]; x++) {
			[[_cachedViews objectAtIndex:x] removeFromSuperview];
		}
	}
	
	_cachedViews = [CPMutableArray array];
	_numberOfRows = 0;
	_selectedRowIndexes = [CPIndexSet indexSet];
	_clickedRow = -1;
	
	// get the new number of rows
	_numberOfRows = [_dataSource numberOfRowsInListView:self];
	
	var nextYPosition = 0;
	var width = [self frame].size.width;
	
	if (_numberOfRows != 0 || _numberOfRows != nil) {
		for (var i = 0; i != _numberOfRows; i++) {
		var heightOfRow = [_dataSource listview:self heightForRow:i];
		var view = [_dataSource listview:self viewForRow:i];
		var data = [_dataSource listview:self objectForRow:i];
		
		// set the data
		[view setRepresentedObject:data];
		[view setListView:self];
		[_cachedViews addObject:view];
		
		[view setFrame:CGRectMake(0, nextYPosition, width, heightOfRow)];
		[view setAutoresizingMask:CPViewWidthSizable];
		[view setSelected:NO];
		
		[self addSubview:view];
		[view setNeedsDisplay:YES];
		nextYPosition += heightOfRow;
		}
	}
		
	var width = [[self superview] frame].size.width;
	[self setFrameSize: CGSizeMake(width, nextYPosition)];
}

-(void) rowRecievedEvent:(SLListViewCell)aCell {
	// get the row of the click
	var newClickedRow = [_cachedViews indexOfObject:aCell];	
	if (_clickedRow == newClickedRow) {return}
	
	// check if the selction should change
	var shouldChange = YES;
	shouldChange = [_delegate selectionShouldChangeInListview:self];
	if (!shouldChange) {return;}
	
	// check if this row should be selected
	var shouldSelectThisRow = YES;
	shouldSelectThisRow = [_delegate listview:self shouldSelectRow:newClickedRow];
	if (!shouldSelectThisRow) {return;}
	
	// looks like we can do it
	if (_clickedRow != -1) {
		var currentCell = [_cachedViews objectAtIndex:_clickedRow];
		[currentCell setSelected:NO];
	}
	_clickedRow = newClickedRow;
	[aCell setSelected:YES];
	[_delegate listviewSelectionDidChange:self];
}


@end
