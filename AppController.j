/*
 * AppController.j
 * Marist Connect
 *
 * Created by You on December 16, 2012.
 * Copyright 2012, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "MCLoginViewController.j"
@import "MCTitleViewController.j"
@import "MCCourseViewController.j"
@import "MCFilterViewButton.j"

@implementation AppController : CPObject
{
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	[[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeUI) name:@"CPWindowDidResizeNotification" object:nil];

	Parse.initialize("LVCVYWC2FxxlHG0xL0EVE7Fl8pDgKLNUkamti609", "IeoxnvafHMXEQpbogzrBvWtL0s4eZ9GqZ1qMUitJ");
   	var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];
        
    /*
var button = [[MCFilterViewButton alloc] init];
    window.console.log("1");
    [button setTitle:@"test"];
    window.console.log("1");
    [contentView addSubview:button];
    window.console.log("1");
    [theWindow orderFront:self];
*/
}

-(void) awakeFromCib {
	
}

- (void)resizeUI{}

@end