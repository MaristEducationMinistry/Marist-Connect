

@implementation MCLoginViewController : CPViewController
{
	@outlet CPTextField usernameField;
	@outlet CPTextField passwordField;
	@outlet CPButton rememberButton;
	
	id _delegate;
}

- (void)setDelegate:(id)aDelegate
{
	_delegate = aDelegate;
}

- (IBAction)performLogin:(id)aSender
{
	
}

- (IBAction)toggleRememberMeState:(id)aSender
{
	
}

@end