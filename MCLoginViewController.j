
@import <Foundation/Foundation.j>
@import "MCHoveringTextField.j"


@implementation MCLoginViewController : CPViewController
{
	@outlet CPTextField usernameField;
	@outlet CPTextField passwordField;
	@outlet CPButton rememberButton;
    @outlet MCHoveringTextField forgotLink;
	
	id _delegate;
}

- (void)setDelegate:(id)aDelegate
{
	_delegate = aDelegate;
}

- (IBAction)performLogin:(id)aSender
{
	alert('yay');
}

- (IBAction)toggleRememberMeState:(id)aSender
{
	
}

- (void)awakeFromCib
{
	[forgotLink setDefaultColour:[CPColor blackColor]];
	[forgotLink setSecondaryColour:[CPColor redColor]];
}

@end