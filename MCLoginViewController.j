

@implementation MCLoginViewController : CPViewController
{
	@outlet CPTextField usernameField;
	@outlet CPTextField passwordField;
	@outlet CPButton rememberButton;
	
	BOOL _keepLoggedIn;
	id _delegate;
}

- (void)setDelegate:(id)aDelegate
{
	_delegate = aDelegate;
}

- (IBAction)performLogin:(id)aSender
{
	Parse.User.logIn([usernameField stringValue], [passwordField stringValue], {
		success: function(user) {
			if ([_delegate respondsToSelector:@selector(loginDidSucced:)]) {
				[_delegate loginDidSucced:user];
			}
		},
		error: function(user, error) {
			
		}
	});
}

- (IBAction)toggleRememberMeState:(id)aSender
{
	if ([aSender state] == 0) {
		_keepLoggedIn = false;
	} else if ([aSender state] == 1) {
		_keepLoggedIn = true;
	}
}
@end