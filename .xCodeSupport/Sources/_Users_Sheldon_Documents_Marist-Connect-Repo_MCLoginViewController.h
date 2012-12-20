
@interface MCLoginViewController : NSViewController
{
    IBOutlet NSTextField* usernameField;
    IBOutlet NSTextField* passwordField;
    IBOutlet NSButton* rememberButton;
    IBOutlet NSImageView* bgImage;
    IBOutlet MCHoveringTextField* forgotLink;
    IBOutlet MCBackgroundView* background;
}
- (IBAction)performLogin:(id)aSender;
- (IBAction)toggleRememberMeState:(id)aSender;
@end