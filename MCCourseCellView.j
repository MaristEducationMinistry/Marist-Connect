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
    CPImageView courseCellArrow;
}

-(void) setSelected:(BOOL)selected {
	[super setSelected:selected];
	if (selected) {
		if (!courseCellArrow) {
			courseCellArrow = [[CPImageView alloc] initWithFrame:CGRectMake(301.0, 9.0, 15.0, 21.0)];
			[self addSubview:courseCellArrow];
		}
		var image = [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/course_cell_arrow.png"];
		[courseCellArrow setImage:image];
		[courseNameLabel setTextColor:[CPColor whiteColor]];
	} else {
		[courseCellArrow setImage:nil];
		[courseNameLabel setTextColor:[CPColor blackColor]];
	}
}

-(void) setRepresentedObject:(id)aRepresentedObject {
	[super setRepresentedObject:aRepresentedObject];
	//[courseTypeLabel setStringValue:[aRepresentedObject text]];
	//[courseCountLabel setStringValue:[aRepresentedObject count]];
}

@end