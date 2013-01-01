@import <Foundation/Foundation.j>
@import "EKActivityIndicatorView.j"

@implementation MCTermsAndConditionsViewController : CPViewController
{
	@outlet CPTextField titleField;
	@outlet CPTextField termsField;
	@outlet CPButton termsSelectionButton;
	@outlet EKActivityIndicatorView progressView;
	@outlet CPButton nextButton;
	@outlet CPButton backButton;
	
	CPView tocCoverView;
	int _currentTOCVersion;
	id _aVersion;
	
	id _target;
}

- (CPView)overView:(CGRect)aFrame
{
	tocCoverView = [[CPView alloc] initWithFrame:CGRectMake(0.0, 0.0, aFrame.size.width, aFrame.size.height)];
	[tocCoverView setBackgroundColor:[CPColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
	return tocCoverView;
}

- (IBAction)backButton:(id)aSender
{
	[backButton setHidden:YES];
	[termsSelectionButton setHidden:NO];
	[nextButton setTitle:@"Next"];
	[termsSelectionButton setState:0];
	[termsField setStringValue:_aVersion.get("terms")];
	if (Parse.User.current().get("toc") == 0) {
		[titleField setStringValue:@"Marist Connect Terms and Conditions"];
	} else {
		[titleField setStringValue:@"Marist Connect Terms and Conditions have changed"];
	}
}

- (IBAction)nextButton:(id)aSender
{
	if ([aSender title] == @"Next") {
		if ([termsSelectionButton state] == 1)
		{
			[progressView startAnimating];
			[aSender setEnabled:NO];
			[termsField setEnabled:NO];
			[termsSelectionButton setEnabled:NO];
			var user = Parse.User.current();
			user.set("toc", _currentTOCVersion);
			user.save(null, {
				success: function(user) {
					[aSender setTitle:@"Finish"];
					[progressView stopAnimating];
					[aSender setEnabled:YES];
					[termsSelectionButton setHidden:YES];
					[termsField setStringValue:@"Your profile has been updated \n\n\n Press Finish to continue to Marist Connect"];
				},
				error: function(user, error) {
					alert(error.message);
					[progressView stopAnimating];
					[aSender setEnabled:YES];
				}
			});
		} else {
			[termsField setStringValue:@"You must accept the conditions to use Marist Connect \n\n\n Press LogOut to leave, or Back to read the Terms and Conditions"];
			[backButton setHidden:NO];
			[termsSelectionButton setHidden:YES];
			[aSender setTitle:@"LogOut"];
		}
	} else if ([aSender title] == @"LogOut") {
		[[CPApplication sharedApplication] endSheet:[[self view] window]];
		[_target logOutUser];
	} else if ([aSender title] == @"Finish") {
		setTimeout(function() {[tocCoverView removeFromSuperview]}, 300);
		[[CPApplication sharedApplication] endSheet:[[self view] window]];
	}
}

- (void)setVersion:(id)aVersion target:(id)aTarget
{
	_aVersion = aVersion;
	[backButton setHidden:YES];
	[termsSelectionButton setHidden:NO];
	[nextButton setTitle:@"Next"];
	[termsSelectionButton setState:0];
	_target = aTarget;
	_currentTOCVersion = aVersion.get("version");
	[termsField setStringValue:aVersion.get("terms")];
	if (Parse.User.current().get("toc") == 0) {
		[titleField setStringValue:@"Marist Connect Terms and Conditions"];
	} else {
		[titleField setStringValue:@"Marist Connect Terms and Conditions have changed"];
	}
}

@end