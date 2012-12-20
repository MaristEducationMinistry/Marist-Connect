
@interface MCCourseViewController : NSViewController
{
    IBOutlet NSTableView* courseTableView;
}

@end
@interface MCCourseTableRowView : NSView
{
    IBOutlet NSTextField* nameField;
}

@end