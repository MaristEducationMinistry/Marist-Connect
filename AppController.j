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
@import "MCNewsFeedViewController.j"
@import <LPKit/LPSlideView.j>
@import "MCTermsAndConditionsViewController.j"

@import "SLListView.j"
@import "SLListViewCell.j"
@import "MCCourseCellView.j"


@implementation AppController : CPObject
{
	CPWindow theWindow;
	CPWindow tocWindow;
	
	MCLoginViewController _loginViewController;
	MCTitleViewController _titleViewController;
	LPSlideView _slideView;
	MCDashboardViewController _dashboardViewController;
	MCNewsFeedViewController _newsFeedViewController;
	MCTermsAndConditions _termsAndConditionsViewController;
	
	id cookieController;
	
	CPScrollView scrollView;
	SLListView listview;
    CPArray data;
    
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
    [_titleViewController setDelegate:self];
    
    //create the toc page
    tocWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(0.0, 0.0, 550.0, 335.0) styleMask:CPDocModalWindowMask];
    _termsAndConditionsViewController = [[MCTermsAndConditionsViewController alloc] initWithCibName:@"MCTermsAndConditionsViewController" bundle:nil];
    [tocWindow setContentView:[_termsAndConditionsViewController view]];
    
    
    //create the newsfeed
    _newsFeedViewController = [[MCNewsFeedViewController alloc] initWithCibName:@"MCNewsFeedViewController" bundle:nil];
    [[_newsFeedViewController view] setFrame:CGRectMake(0.0, 48.0, frame.size.width, frame.size.height - 48.0)];
    
    
    //create the dashboard
    _dashboardViewController = [[MCDashboardViewController alloc] initWithCibName:@"MCDashboardViewController" bundle:nil];
    [[_dashboardViewController view] setFrame:CGRectMake(0.0, 48.0, frame.size.width, frame.size.height - 48.0)];
    [_dashboardViewController layoutSubviews];
    
    //add dashboard to contentview
    [[theWindow contentView] addSubview:[_dashboardViewController view]];
    
	[[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeUI) name:@"CPWindowDidResizeNotification" object:nil];
	
	// check if the user is logged in and present the relavent view
	cookieController = [LPCookieController sharedCookieController];
	if ([cookieController valueForKey:@"keepLoggedIn"] == "true" && Parse.User.current()) {
		// goto news feed.
		[self userDidLogIn];
	} else {
		// goto the login view
		[self gotoLoginView];
	}
    
    [theWindow orderFront:self];
}

-(int) numberOfRowsInListView:(SLListView)list {
	return [data count];
}

-(int) listview:(SLListView)list heightForRow:(int)row {
	return 45;
}

-(id) listview:(SLListView)list objectForRow:(int)row {
	return [data objectAtIndex:row];
}

-(CPView) listview:(SLListView)list viewForRow:(int)row {
	var view = [[SLListViewCell alloc] init];
	if (row % 2 == 0) {
		//[view setBackgroundColor:[CPColor blueColor]];
	} else {
		//[view setBackgroundColor:[CPColor redColor]];
	}
	
	return view;
}

// delegate callback when the login view completes
- (void)userDidLogIn
{
	[[theWindow contentView] addSubview:[_dashboardViewController view]];
	[[_loginViewController view] removeFromSuperview];
	[self gotoNewsFeed];
	var toc = Parse.Object.extend("TermsAndConditions");
	var tocVerQuery = new Parse.Query(toc);
	tocVerQuery.descending("version");
	tocVerQuery.first( {
		success: function(currentVersion) {
			var userTocVer = Parse.User.current().get("toc");
			if (userTocVer == 0 || userTocVer < currentVersion.get("version")) {
					[_termsAndConditionsViewController setVersion:currentVersion.get("version")];
					[self showTOC];
			} else {
				// remove the login view from the content view
				[[_loginViewController view] removeFromSuperview];
				[[theWindow contentView] addSubview:[_dashboardViewController view]];
				[self gotoNewsFeed]
				// move to the main dashboard
			}
		},
		error: function(ver, error) {
			alert(error.message);
		}
	});
}

- (void)showTOC
{
	var frame = [theWindow frame];
	tocCoverView = [_termsAndConditionsViewController overView:frame];
	[[theWindow contentView] addSubview:tocCoverView];
	[[CPApplication sharedApplication] beginSheet:tocWindow modalForWindow:theWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (void)logOutUser
{
	Parse.User.logOut();
	[self gotoLoginView];
}

-(void) gotoLoginView 
{
	var contentView = [theWindow contentView];
	// remove anything old off the contentView
	var views = [contentView subviews];
	for (var x=0; x<views.length; x++) {
		[[views objectAtIndex:x] removeFromSuperview];
	}
	
	// size the view to the current content view and add it
	[[_loginViewController view] setFrameSize:CGSizeMake([contentView frame].size.width, [contentView frame].size.height)];
    [[_loginViewController view] setCenter:[contentView center]];
    [contentView addSubview: [_loginViewController view]];
}

-(void) gotoNewsFeed 
{
	[_newsFeedViewController resizeUI:[[theWindow contentView] frame]];
	[[theWindow contentView] replaceSubview:[_dashboardViewController view] with:[_newsFeedViewController view]];
	[self ensureTitleBarIsOnScreen];
}

-(void) gotoDashboard 
{
	[[theWindow contentView] replaceSubview:[_newsFeedViewController view] with:[_dashboardViewController view]];
	[self ensureTitleBarIsOnScreen];
}

-(void) ensureTitleBarIsOnScreen 
{
	if (![[_titleViewController view] superview]) {
		var frame = [[theWindow contentView] frame];
		[[_titleViewController view] setFrameSize:CGSizeMake(frame.size.width ,48)];
		[[_titleViewController view] setFrameOrigin:CGPointMake(0.0,0.0)];
		var username = Parse.User.current().get("username");
		[_titleViewController setUsername:username];
		[[theWindow contentView] addSubview:[_titleViewController view]];
	}
}

- (void)resizeUI{
	var frame = [[theWindow contentView] frame]
	[[_titleViewController view] setFrame:CGRectMake(0.0, 0.0, frame.size.width, 48.0)];
	[[_newsFeedViewController view] setFrame:CGRectMake(0.0, 48.0, frame.size.width, frame.size.height - 48.0)];
	[[_newsFeedViewController newsFilterBar] resizeUI:frame];
	[[_dashboardViewController view] setFrame:CGRectMake(0.0, 48.0, frame.size.width, frame.size.height - 48.0)];
	[_dashboardViewController resizeUI:frame];
}

@end