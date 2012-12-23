/*
 * MCLoginViewController.j
 * Marist Connect
 *
 * Created by Sheldon Levet on December 22, 2012.
 * Copyright 2012, Marist Education Ministry All rights reserved.
 */

@import <Foundation/Foundation.j>
@import "MCHoveringTextField.j"
@import "MCBackgroundView.j"
@import "MCFilterView.j"


@implementation MCLoginViewController : CPViewController
{
	//declaration of public variables
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
    
    @outlet MCFilterView filterView; 
	
	id _delegate;
}

- (void)setDelegate:(id)aDelegate
{
	_delegate = aDelegate;
}

//login event
- (IBAction)performLogin:(id)aSender
{	
	[loginButton setHidden:YES];
	[spinner setHidden:NO];															   //change images to spinning gif
	if ([usernameField stringValue] != @"" && [passwordField stringValue] != @"") {    //check that details are entered
		Parse.User.logIn([usernameField stringValue], [passwordField stringValue], {   //begin parse call for login
			success: function(user) {												   //success block
				[loginButton setHidden:NO];
				[spinner setHidden:YES];
				[_delegate userDidLogIn];
			},
			error: function(user, error) {											   //error block
				alert(error.message);
				[loginButton setHidden:NO];
				[spinner setHidden:YES];
			}
		});
	} else {
		[loginButton setHidden:NO];													  //present message for no details added
		[spinner setHidden:YES];
	}
}

- (IBAction)toggleRememberMeState:(id)aSender
{
	
}

- (void)awakeFromCib
{
	//setup links
	[forgotLink setDefaultColour:[CPColor lightGrayColor]];
	[forgotLink setSecondaryColour:[CPColor whiteColor]];
	[helpLink setDefaultColour:[CPColor lightGrayColor]];
	[helpLink setSecondaryColour:[CPColor whiteColor]];
	[privacyPolicyLink setDefaultColour:[CPColor lightGrayColor]];
	[privacyPolicyLink setSecondaryColour:[CPColor whiteColor]];
	
	//set images
	[loginFormBG setImage:[[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/loginView_background_image.png"]];
	[loginButton setImage:[[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/login_go_arrow.png"]];
	[loginHeaderImage setImage:[[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/mary_image_loginView.png"]];
	[privacyPolicyLink setURL:@"http://portal.youngmarists.org.nz/Privacy/privacyPolicy.pdf"];
	[spinner setImage:[[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/spinner.gif"]];
	[spinner setHidden:YES];
}

@end


//login button subclass to handle hovering
@implementation MCLoginGoButton : CPButton
{
	//decleration of public variables
	CPImage _defaultImage @accessors;
	CPImage _hoverImage @accessors;
	CPImage _clickedImage @accessors;
	SEL action;
	id target;
}

- (void)awakeFromCib
{
	//set images
	_defaultImage = [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/login_go_arrow.png"];
	_hoverImage = [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/login_go_arrow_hovering.png"];
	_clickedImage = [[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/login_go_arrow_clicked.png"];
	[self setAlternateImage:_clickedImage];
	[self setImage:_defaultImage];
}

- (void)mouseEntered:(CPEvent)anEvent	//mouse entered event
{
	[self setImage:_hoverImage];
}

- (void)mouseExited:(CPEvent)anEvent	//mouse exit event
{
	[self setImage:_defaultImage];
}

- (void)mouseUp:(CPEvent)anEvent	//mouse key up event
{
	[self setImage:_hoverImage];
}

@end