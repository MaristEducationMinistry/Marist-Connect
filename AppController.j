/*
 * AppController.j
 * Marist Connect
 *
 * Created by Sheldon Levet on December 16, 2012.
 * Copyright 2012, Marist Education Ministry All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "MCLoginViewController.j"
@import "MCTitleViewController.j"
@import "MCCourseViewController.j"
@import "MCFilterView.j"


@implementation AppController : CPObject
{
	CPWindow theWindow;
	MCLoginViewController _loginViewController;
	MCTitleViewController _titleViewController;
	
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	[[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeUI) name:@"CPWindowDidResizeNotification" object:nil];

	Parse.initialize("LVCVYWC2FxxlHG0xL0EVE7Fl8pDgKLNUkamti609", "IeoxnvafHMXEQpbogzrBvWtL0s4eZ9GqZ1qMUitJ");
   	theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];
        
    _loginViewController = [[MCLoginViewController alloc] initWithCibName:@"MCLoginViewController" bundle:nil];
    [_loginViewController setDelegate:self];
    [[_loginViewController view] setFrameSize:CGSizeMake([contentView frame].size.width, [contentView frame].size.height)];
    [[_loginViewController view] setCenter:[contentView center]];
    
    //filter bar testing
    
    
    //var courseViewController = [[MCCourseViewController alloc] initWithCibName:@"MCCourseViewController" bundle:nil];
    //[[courseViewController view] setCenter:[contentView center]];
    
    var _titleViewController = [[MCTitleViewController alloc] initWithCibName:@"MCTitleViewController" bundle:nil];
    var frame = [contentView frame];
    [[_titleViewController view] setFrameSize:CGSizeMake(frame.size.width ,48)];
    [[_titleViewController view] setFrameOrigin:CGPointMake(0.0,0.0)];

    [contentView addSubview:[_loginViewController view]];
   // [contentView addSubview:_filterBar];

    [theWindow orderFront:self];
}

- (void)userDidLogIn
{
	[[_loginViewController view] removeFromSuperview];
	[[theWindow contentView] addSubview:[_titleViewController view]];
}

- (void)resizeUI{}

@end