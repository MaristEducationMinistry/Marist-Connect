
@interface MCLoginViewController : NSViewController
{
    IBOutlet NSTextField* usernameField;
    IBOutlet NSTextField* passwordField;
    IBOutlet NSButton* rememberButton;
    IBOutlet MCHoveringTextField* forgotLink;
    IBOutlet MCBackgroundView* background;
    IBOutlet NSImageView* loginFormBG;
    IBOutlet MCLoginGoButton* loginButton;
    IBOutlet NSImageView* loginHeaderImage;
    IBOutlet MCHoveringTextField* privacyPolicyLink;
    IBOutlet MCHoveringTextField* helpLink;
    IBOutlet NSImageView* spinner;
}
- (IBAction)performLogin:(id)aSender;
- (IBAction)toggleRememberMeState:(id)aSender;
@end
@interface MCLoginGoButton : NSButton
{

}

@end