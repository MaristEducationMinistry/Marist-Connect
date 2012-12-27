
@interface MCTitleViewController : NSViewController
{
    IBOutlet NSButton* changeViewButton;
    IBOutlet MCHoveringTextField* signOutLabel;
    IBOutlet MCHoveringTextField* usernameLabel;
    IBOutlet NSImageView* mainTitle;
}
- (IBAction)toggleCurrentView:(id)aSender;
@end
@interface MCTitleGradientView : NSView
{

}

@end