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
@import "MCDashboardViewController.j"
@import <LPKit/LPSlideView.j>


@implementation AppController : CPObject
{
	CPWindow theWindow;
	MCLoginViewController _loginViewController;
	MCTitleViewController _titleViewController;
	LPSlideView _slideView;
	MCDashboardViewController _dashboardViewController;
	
	
	id cookieController;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	Parse.initialize("LVCVYWC2FxxlHG0xL0EVE7Fl8pDgKLNUkamti609", "IeoxnvafHMXEQpbogzrBvWtL0s4eZ9GqZ1qMUitJ");
	
	theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];

     // create the login view controller
    _loginViewController = [[MCLogInViewController alloc] initWithCibName:@"View" bundle:nil];
    [_loginViewController setDelegate:self];
        
	// create the title view controller
	_titleViewController = [[MCTitleViewController alloc] initWithCibName:@"MCTitleViewController" bundle:nil];
    var frame = [contentView frame];
    [[_titleViewController view] setFrameSize:CGSizeMake(frame.size.width ,48)];
    [[_titleViewController view] setFrameOrigin:CGPointMake(0.0,0.0)];
    
    //create the slide view
    _slideView = [[LPSlideView alloc] initWithFrame:CGRectMake(0.0, 48.0, frame.size.width, frame.size.height - 48.0) direction:LPSlideViewVerticalDirection duration:0.7];
    [_slideView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable | CPViewMinYMargin];
    
    //create other views for slider
    _dashboardViewController = [[MCDashboardViewController alloc] initWithCibName:@"MCDashboardViewController" bundle:nil];
    [_slideView addSubview:[_dashboardViewController view]];
    //
    [_slideView slideToView:[_dashboardViewController view] direction:nil];
    //
    
	[[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeUI) name:@"CPWindowDidResizeNotification" object:nil];
	
	// check if the user is logged in and present the relavent view
	cookieController = [LPCookieController sharedCookieController];
	if ([cookieController valueForKey:@"keepLoggedIn"] == "true" && Parse.User.current()) {
		// goto news feed.
		[self gotoNewsFeed];
	} else {
		// goto the login view
		[self gotoLoginView];
	}
	
    [theWindow orderFront:self];
}

// delegate callback when the login view completes
- (void)userDidLogIn
{
	// remove the login view from the content view
	[[_loginViewController view] removeFromSuperview];
	
	// move to the main dashboard
}

-(void) gotoLoginView {
	var contentView = [theWindow contentView];
	// remove anything old off the contentView
	var views = [contentView subviews];
	for (var x=0; x<subviews.length; x++) {
		[[views objectAtIndex:x] removeFromSuperview];
	}
	
	// size the view to the current content view and add it
	[[_loginViewController view] setFrameSize:CGSizeMake([contentView frame].size.width, [contentView frame].size.height)];
    [[_loginViewController view] setCenter:[contentView center]];
    [contentView addSubview: [_loginViewController view]];
}

-(void) gotoNewsFeed {
	[self ensureTitleBarIsOnScreen];
}

-(void) gotoDashboard {
	[self ensureTitleBarIsOnScreen];
}

-(void) ensureTitleBarIsOnScreen {
	if (![[_titleViewController view] superview]) {
		var frame = [[theWindow contentView] frame];
		[[_titleViewController view] setFrameSize:CGSizeMake(frame.size.width ,48)];
		[[_titleViewController view] setFrameOrigin:CGPointMake(0.0,0.0)];
		[[theWindow contentView] addSubview:[_titleViewController view]];
	}
	if (![_slideView superview]) {
		var frame = [[theWindow contentView] frame];
		[_slideView setFrame:CGRectMake(0.0, 48.0, frame.size.width, frame.size.heigth - 48.0)];
		[[theWindow contentView] addSubview:_slideView];
	}
}

- (void)resizeUI{}

@end