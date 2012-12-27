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
}
 
- (void)drawRect:(CGRect)aRect
{
    var path = [CPBezierPath bezierPath];
    var frame = [courseCountLabel frame];
	var rect = CGRectMake([self frame].size.width - 36.0 - frame.size.width,5.0,frame.size.width + 16.0, frame.size.height + 2.0);
	[path appendBezierPathWithRoundedRect:[self bounds] xRadius:10.0 yRadius:10.0];
	[[CPColor colorWithHexString:@"c2c2c2"] setFill];
	[path fill];
}
 
@end