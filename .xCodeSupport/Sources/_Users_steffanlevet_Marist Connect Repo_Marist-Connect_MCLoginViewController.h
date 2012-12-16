
@interface MCLoginViewController : NSViewController
{
    IBOutlet NSTextField* usernameField;
    IBOutlet NSTextField* passwordField;
    IBOutlet NSButton* rememberButton;
}
- (IBAction)performLogin:(id)aSender;
- (IBAction)toggleRememberMeState:(id)aSender;
@end