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


@implementation AppController : CPObject
{
    CPWindow    theWindow; //this "outlet" is connected automatically by the Cib
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    Parse.initialize("y7TFd6IFYR5ddsOs7xpCdoyVrKSfrSaFGqrekXYE", "uWuhcx75kue25Vm7C9kLIMo4ChJfLbsGwBQe7YQI");
    theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask];
    var titleViewController = [[MCTitleViewController alloc] initWithCibName:@"MCTitleViewController" bundle:nil];
    var view = [theWindow frame];
    [[titleViewController view] setFrame:CGRectMake(0.0,0.0,view.size.width,70.0)];
    [[theWindow contentView] addSubview:[titleViewController view]];
    var view = [[titleViewController view] frame];
    window.console.log(view.size.width);
    var loginViewController = [[MCLoginViewController alloc] initWithCibName:@"MCLoginViewController" bundle:nil];
    [[theWindow contentView] addSubview:[loginViewController view]];
    [loginViewController setDelegate:self];
    [theWindow setDelegate:self];
    [theWindow orderFront:self];
}

- (void)loginDidSucced:(id)aUser
{
	alert("You have been logged in: " + aUser.get("username"));
}

- (void)awakeFromCib
{
    //[theWindow setFullPlatformWindow:YES];
    //[theWindow setFullBridge:YES];
}

-(BOOL)windowShouldClose:(id)window
{
	alert("don't even try it");
	return false
}

@end
