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


@implementation AppController : CPObject
{
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	Parse.initialize("LVCVYWC2FxxlHG0xL0EVE7Fl8pDgKLNUkamti609", "IeoxnvafHMXEQpbogzrBvWtL0s4eZ9GqZ1qMUitJ");
   	var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];
        
    var loginViewController = [[MCLoginViewController alloc] initWithCibName:@"MCLoginViewController" bundle:nil];
    [[loginViewController view] setCenter:[contentView center]];
    
    var courseViewController = [[MCCourseViewController alloc] initWithCibName:@"MCCourseViewController" bundle:nil];
    [[courseViewController view] setCenter:[contentView center]];
    
    var titleViewController = [[MCTitleViewController alloc] initWithCibName:@"MCTitleViewController" bundle:nil];
    var frame = [contentView frame];
    [[titleViewController view] setFrameSize:CGSizeMake(frame.size.width ,70)];
    [[titleViewController view] setFrameOrigin:CGPointMake(0.0,0.0)];

    [contentView addSubview:[courseViewController view]];
    [contentView addSubview:[titleViewController view]];

    [theWindow orderFront:self];
}

@end