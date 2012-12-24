
@interface MCLogInViewController : NSViewController
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
    IBOutlet NSImageView* spinner2;
    IBOutlet NSImageView* forgotFormBG;
    IBOutlet NSTextField* emailField;
    IBOutlet NSView* loginView;
    IBOutlet NSView* forgotView;
    IBOutlet MCLoginGoButton* forgotButton;
}
- (IBAction)returnToLogin:(id)aSender;
- (IBAction)performReset:(id)aSender;
- (IBAction)performLogin:(id)aSender;
- (IBAction)toggleRememberMeState:(id)aSender;
@end
@interface MCLoginGoButton : NSButton
{

}

@end