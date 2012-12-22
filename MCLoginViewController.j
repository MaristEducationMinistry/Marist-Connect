
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
    @outlet CPButton loginButton;
    @outlet CPImageView loginHeaderImage;
    @outlet MCHoveringTextField privacyPolicyLink;
    @outlet MCHoveringTextField forgotLink;
    @outlet MCHoveringTextField helpLink;
	
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
}

@end