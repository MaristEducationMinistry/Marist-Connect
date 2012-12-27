/*
 * MCTitleViewController.j
 * Marist Connect
 *
 * Created by Sheldon Levet on December 22, 2012.
 * Copyright 2012, Marist Education Ministry All rights reserved.
 */

@import <Foundation/Foundation.j>
@import "MCHoveringTextField.j"

@implementation MCTitleViewController : CPViewController
{
	@outlet CPButton changeViewButton;
	@outlet MCHoveringTextField signOutLabel;
	@outlet MCHoveringTextField usernameLabel; 
	@outlet CPImageView mainTitle;
	
	BOOL _isNewsFeed;
	
	id _delegate;
}

- (void)setDelegate:(id)aDelegate
{
	_delegate = aDelegate;
}

- (IBAction)toggleCurrentView:(id)aSender
{
	if (_isNewsFeed) {
		_isNewsFeed = false;
		[_delegate gotoDashboard];
	} else {
		_isNewsFeed = true;
		[_delegate gotoNewsFeed];
	}
}

- (void)userShouldLogout
{
	[_delegate logOutUser];
}

- (void)awakeFromCib
{
	_isNewsFeed = true;
	[signOutLabel setDefaultColour:[CPColor whiteColor]];
	[signOutLabel setSecondaryColour:[CPColor blackColor]];
	[signOutLabel setAction:@selector(userShouldLogout) forTarget:self];
	[usernameLabel setDefaultColour:[CPColor whiteColor]];
	[usernameLabel setSecondaryColour:[CPColor blackColor]];
	[usernameLabel setStringValue:Parse.User.current().get("username")];
	[mainTitle setImage:[[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/marist_connect_main_icon.png"]];
	[changeViewButton setImage:[[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/change_view_image.png"]];
}
@end

//gradient view subclass
@implementation MCTitleGradientView : CPView
- (void)drawRect:(CGRect)rect {
	//gradient
	var startPoint = CGPointMake(0, 0); 
	var endPoint = CGPointMake(0, rect.size.height); 
	var startColor = [CPColor colorWithHexString:@"dfd8d8"]; 
	var endColor = [CPColor colorWithHexString:@"747474"]; 
	var currentContext = [[CPGraphicsContext currentContext] graphicsPort]; 
	var fStyle = currentContext.createLinearGradient(startPoint.x, startPoint.y, endPoint.x, endPoint.y); 
	fStyle.addColorStop(0.0, "rgba("+ROUND(255*[startColor components][0])+", "+ROUND(255*[startColor components][1])+", "+ROUND(255*[startColor components][2])+", "+[startColor components][3]+")"); 
	fStyle.addColorStop(1.0, "rgba("+ROUND(255*[endColor components][0])+", "+ROUND(255*[endColor components][1])+", "+ROUND(255*[endColor components][2])+", "+[endColor components][3]+")");
	currentContext.fillStyle = fStyle; currentContext.fillRect(0, 0, rect.size.width, rect.size.height); 
	
	//line
	var bp = [[CPBezierPath alloc] init];
	[bp setLineWidth:1.0];
	[[CPColor blackColor] setStroke];
	[CPBezierPath strokeLineFromPoint:CGPointMake(0.0,48.0) toPoint:CGPointMake(rect.size.width, 48.0)];
}
@end