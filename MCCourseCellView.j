/*
 * MCCourseCellView.j
 * Marist Connect
 *
 * Created by Sheldon Levet on December 26, 2012.
 * Copyright 2012, Marist Education Ministry All rights reserved.
 */
 
@import <Foundation/Foundation.j>
@import "SLListViewCell.j"
 
@implementation MCCourseCellView : SLListViewCell
{
	@outlet CPTextField courseNameLabel;
    @outlet CPTextField courseDateLabel;
    @outlet CPImageView courseCellArrow;
}
 
- (void)awakeFromCib
{
	[courseCellArrow setImage:[CPImage initWithContentsOfFile:@"Image\ Resources/course_cell_arrow.png"]];
}
 
@end