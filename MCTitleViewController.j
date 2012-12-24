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
	@outlet CPButton logoutButton;
	@outlet MCHoveringTextField signOutLabel;
	@outlet MCHoveringTextField usernameLabel; 
}

- (void)awakeFromCib
{
	[logoutButton setTitle:@"Logout"];
	[signOutLabel setDefaultColour:[CPColor lightGrayColor]];
	[signOutLabel setSecondaryColour:[CPColor whiteColor]];
	[usernameLabel setDefaultColour:[CPColor lightGrayColor]];
	[usernameLabel setSecondaryColour:[CPColor whiteColor]];
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