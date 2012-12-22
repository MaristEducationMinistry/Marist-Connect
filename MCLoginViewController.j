
@import <Foundation/Foundation.j>
@import "MCHoveringTextField.j"
@import "MCBackgroundView.j"


@implementation MCLoginViewController : CPViewController
{
	@outlet CPTextField usernameField;
	@outlet CPTextField passwordField;
	@outlet CPButton rememberButton;
    @outlet MCHoveringTextField forgotLink;
    @outlet MCBackgroundView background;
    @outlet CPImageView loginFormBG;
    @outlet MCLoginGoButton loginButton;
    @outlet CPImageView loginHeaderImage;
    @outlet MCHoveringTextField privacyPolicyLink;
    @outlet MCHoveringTextField forgotLink;
    @outlet MCHoveringTextField helpLink;
    @outlet CPImageView spinner;
	
	id _delegate;
}

- (void)setDelegate:(id)aDelegate
{
	_delegate = aDelegate;
}

- (IBAction)performLogin:(id)aSender
{	
	[loginButton setHidden:YES];
	[spinner setHidden:NO];
	if ([usernameField stringValue] != @"" && [passwordField stringValue] != @"") {
		[loginButton setHidden:NO];
		[spinner setHidden:YES];
	} else {
		[loginButton setHidden:NO];
		[spinner setHidden:YES];
	}
}

- (IBAction)toggleRememberMeState:(id)aSender
{
	
}

- (void)awakeFromCib
{
	[forgotLink setDefaultColour:[CPColor lightGrayColor]];
	[forgotLink setSecondaryColour:[CPColor whiteColor]];
	[helpLink setDefaultColour:[CPColor lightGrayColor]];
	[helpLink setSecondaryColour:[CPColor whiteColor]];
	[privacyPolicyLink setDefaultColour:[CPColor lightGrayColor]];
	[privacyPolicyLink setSecondaryColour:[CPColor whiteColor]];
	[loginFormBG setImage:[[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/loginView_background_image.png"]];
	[loginButton setImage:[[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/login_go_arrow.png"]];
	[loginHeaderImage setImage:[[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/mary_image_loginView.png"]];
	[privacyPolicyLink setURL:@"http://portal.youngmarists.org.nz/Privacy/privacyPolicy.pdf"];
	[spinner setImage:[[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/spinner.gif"]];
	[spinner setHidden:YES];
}

@end

@implementation MCLoginGoButton : CPButton
{
	CPImage _defaultImage @accessors;
	CPImage _hoverImage @accessors;
	CPImage _clickedImage @accessors;
	SEL action;
	id target;
}

- (void)awakeFromCib
{
	_defaultImage = [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/login_go_arrow.png"];
	_hoverImage = [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/login_go_arrow_hover.png"];
	_clickedImage = [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/login_go_arrow_clicked.png"];
	[self setAlternateImage:_clickedImage];
	[self setImage:_defaultImage];
}

- (void)mouseEntered:(CPEvent)anEvent
{
	[self setImage:_hoverImage];
}

- (void)mouseExited:(CPEvent)anEvent
{
	[self setImage:_defaultImage];
}

- (void)mouseUp:(CPEvent)anEvent
{
	[self setImage:_hoverImage];
}

@end