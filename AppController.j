/*
 * AppController.j
 * Marist Connect
 *
 * Created by You on December 16, 2012.
 * Copyright 2012, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "MCLoginViewController.j"


@implementation AppController : CPObject
{
    CPWindow    theWindow; //this "outlet" is connected automatically by the Cib
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    Parse.initialize("t1ZBJuNf6SMU3G18PWYFQJJkiaMGWAsLjcLdf6TS", "HpUfMdpaYxFhobzyXgjqw5gxvXenXA06Xb4AGTSf");
    var loginViewController = [[MCLoginViewController alloc] initWithCibName:@"MCLoginViewController" bundle:nil];
    [theWindow setContentView:[loginViewController view]];
    [loginViewController setDelegate:self];
}

- (void)awakeFromCib
{
    // This is called when the cib is done loading.
    // You can implement this method on any object instantiated from a Cib.
    // It's a useful hook for setting up current UI values, and other things.

    // In this case, we want the window from Cib to become our full browser window
    [theWindow setFullPlatformWindow:YES];
    
    
    // comments from above v2 and v4
    
    // this is a change on the new branch
}

@end
