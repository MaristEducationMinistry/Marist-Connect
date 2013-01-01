@import <Foundation/Foundation.j>
@import "EKActivityIndicatorView.j"

@implementation MCTermsAndConditionsViewController : CPViewController
{
	@outlet CPTextField dateField;
	@outlet CPTextField termsField;
	@outlet CPButton termsSelectionButton;
	@outlet EKActivityIndicatorView progressView;
	
	CPView tocCoverView;
	int = _currentTOCVersion;
}

- (CPView)overView:(CGRect)aFrame
{
	tocCoverView = [[CPView alloc] initWithFrame:CGRectMake(0.0, 0.0, aFrame.size.width, aFrame.size.height)];
	[tocCoverView setBackgroundColor:[CPColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
	return tocCoverView;
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
			user.set("toc", 1);
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
			[aSender setTitle:@"LogOut"];
		}
	} else if ([aSender title] == @"LogOut") {
		[[CPApplication sharedApplication] endSheet:[[self view] window]];
		
	} else if ([aSender title] == @"Finish") {
		setTimeout(function() {[tocCoverView removeFromSuperview]}, 300);
		[[CPApplication sharedApplication] endSheet:[[self view] window]];
	}
}

- (void)setVersion:(int)aVersion
{
	_currentTOCVersion = aVersion;
}

@end