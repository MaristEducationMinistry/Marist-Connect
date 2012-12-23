/*
 * SLListView.j
 * Marist Connect
 *
 * Created by Steffan Levet on December 23, 2012.
 * Copyright 2012, Marist Education Ministry All rights reserved.
 */

@import <Foundation/CPObject.j>
//@import "SLListViewCell.j"

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
    
    CPInteger           _clickedRow;
    CPIndexSet          _selectedRowIndexes;
    
    BOOL                _allowsMultipleSelection;
    BOOL                _allowsEmptySelection;

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

-(void) reloadData {
	
	// remove the old data and reset
	
	
	_cachedViews = [CPMutableArray array];
	_numberOfRows = 0;
	_selectedRowIndexes = [CPIndexSet indexSet];
	_clickedRow = -1;
	
	// get the new number of rows
	_numberOfRows = [_dataSource numberOfRowsInListView:self];
	
	var nextYPosition = 0;
	var width = [self frame].size.width;
	
	for (var i = 0; i != _numberOfRows; i++) {
		var heightOfRow = [_dataSource listview:self heightForRow:i];
		var view = [_dataSource listview:self viewForRow:i];
		var data = [_dataSource listview:self objectForRow:i];
		
		// set the data
		[view setRepresentedObject:data];
		[_cachedViews addObject:view];
		
		[view setFrame:CGRectMake(0, nextYPosition, width, heightOfRow)];
		[view setAutoresizingMask:CPViewWidthSizable];
		[view setSelected:NO];
		window.console.log(view);
		[self addSubview:view];
		[view setNeedsDisplay:YES];
		nextYPosition += heightOfRow;
		window.console.log(nextYPosition);
	}
	
	var width = [[self superview] frame].size.width;
	[self setFrameSize: CGSizeMake(width, nextYPosition)];
}

-(void) rowRecievedEvent:(SLListViewCell)aCell {
	
}



@end
