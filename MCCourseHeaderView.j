/*
 * MCCourseHeaderView.j
 * Marist Connect
 *
 * Created by Sheldon Levet on December 26, 2012.
 * Copyright 2012, Marist Education Ministry All rights reserved.
 */
 
@import <Foundation/Foundation.j>
@import "SLListViewCell.j"
 
@implementation MCCourseHeaderView : SLListViewCell
{
    @outlet CPTextField courseTypeLabel;
    @outlet CPTextField courseCountLabel;
    
    id _data;
    BOOL _isSelected;
}
 
- (void)drawRect:(CGRect)aRect
{
	//draw gradient
	var rect = [self frame];
	var startPoint = CGPointMake(0, 0); 
	var endPoint = CGPointMake(0, rect.size.height); 
	var startColor = [CPColor colorWithHexString:@"FFFFFF"]; 
	var endColor = [CPColor colorWithHexString:@"F0F0F0"]; 
	var currentContext = [[CPGraphicsContext currentContext] graphicsPort]; 
	var fStyle = currentContext.createLinearGradient(startPoint.x, startPoint.y, endPoint.x, endPoint.y); 
	fStyle.addColorStop(0.0, "rgba("+ROUND(255*[startColor components][0])+", "+ROUND(255*[startColor components][1])+", "+ROUND(255*[startColor components][2])+", "+[startColor components][3]+")"); 
	fStyle.addColorStop(1.0, "rgba("+ROUND(255*[endColor components][0])+", "+ROUND(255*[endColor components][1])+", "+ROUND(255*[endColor components][2])+", "+[endColor components][3]+")");
	currentContext.fillStyle = fStyle; currentContext.fillRect(0, 0, rect.size.width, rect.size.height); 

	//draw count backer
	[super drawRect:aRect];
    var path = [CPBezierPath bezierPath];
    var frame = [courseCountLabel frame];
	var rect = CGRectMake([self frame].size.width - 34.0 - frame.size.width,4.0,frame.size.width + 16.0, frame.size.height);
	[path appendBezierPathWithRoundedRect:rect xRadius:frame.size.height/2 yRadius:frame.size.height/2];
	[[CPColor colorWithHexString:@"c2c2c2"] setFill];
	[path fill];
}

-(void) setSelected:(BOOL)selected {
	[super setSelected:selected];
}

-(void) setRepresentedObject:(id)aRepresentedObject {
	[super setRepresentedObject:aRepresentedObject];
	//[courseTypeLabel setStringValue:[aRepresentedObject text]];
	//[courseCountLabel setStringValue:[aRepresentedObject count]];
}
 
@end

@implementation MCCourseHeaderObject : CPObject 
{
	CPString _text;
	int _count;
}

- (CPString)text
{
	return _text;
}

- (int)count
{
	return _count;
}

@end