/*
 * MCTableView.j
 * Marist Connect
 *
 * Created by Steffan Levet on December 20, 2012.
 * Copyright 2012, Marist Education Ministry All rights reserved.
 */

@import <Foundation/CPObject.j>

@implementation MCTableView : CPView


- (CPView)_newDataViewForRow:(CPInteger)aRow tableColumn:(CPTableColumn)aTableColumn
{
    if ((_implementedDelegateMethods & CPTableViewDelegate_tableView_dataViewForTableColumn_row_))
    {
        var dataView = [_delegate tableView:self dataViewForTableColumn:aTableColumn row:aRow];
        [aTableColumn setDataView:dataView forRow:aRow];
    }

    return [aTableColumn _newDataViewForRow:aRow];
}

@end