/*
 * MCLoginViewController.j
 * Marist Connect
 *
 * Created by Sheldon Levet on December 22, 2012.
 * Copyright 2012, Marist Education Ministry All rights reserved.
 */

@import <Foundation/Foundation.j>
@import <LPKit/LPCookieController.j>
@import "MCHoveringTextField.j"
@import "MCBackgroundView.j"
@import "EKShakeAnimation.j"
@import "LPCardFlipController.j"


@implementation MCLogInViewController : CPViewController
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
    @outlet CPImageView spinner2;
    
    @outlet CPImageView forgotFormBG;
    @outlet CPTextField emailField;
    @outlet CPView loginView;
    @outlet CPView forgotView;
    @outlet MCLoginGoButton forgotButton;
    
    id cookieController;
    
	id _delegate;
}

- (void)setDelegate:(id)aDelegate
{
	_delegate = aDelegate;
}

- (IBAction)returnToLogin:(id)aSender
{
	var cardFlipController = [LPCardFlipController sharedController];
    [cardFlipController setDelegate:self]; 
    [cardFlipController setStartCenter:[forgotView center] endCenter:[forgotView center]];
    [cardFlipController flipWithView:forgotView backView:loginView];
    setTimeout(function() {[[self view] addSubview:loginView]}, 650);
}

//forgot event
- (IBAction)performReset:(id)aSender
{
	[forgotButton setHidden:YES];
	[spinner2 setHidden:NO];
	if ([emailField stringValue] != @"") {
		Parse.User.requestPasswordReset([emailField stringValue], {
			success: function() {
		    	[self returnToLogin:nil];
		    },
		    error: function(error) {
		    	var animation = [[EKShakeAnimation alloc] initWithView:forgotView];
		    	setTimeout(function() {[emailField setStringValue:@""];}, 175);
		    	[forgotButton setHidden:NO];													  //present message for no details added
		    	[spinner2 setHidden:YES];
		    	//alert("Error: " + error.code + " " + error.message);
		    }
		});
	} else {
		var animation = [[EKShakeAnimation alloc] initWithView:forgotView];
		[forgotButton setHidden:NO];													  //present message for no details added
		[spinner2 setHidden:YES];
	}
	
}


//login event
- (IBAction)performLogin:(id)aSender
{	
	[loginButton setHidden:YES];
	[spinner setHidden:NO];															   //change images to spinning gif
	if ([usernameField stringValue] != @"" && [passwordField stringValue] != @"") {    //check that details are entered
		Parse.User.logIn([usernameField stringValue], [passwordField stringValue], {   //begin parse call for login
			success: function(user) {
				if ([rememberButton state] == 1) {
					[cookieController setValue:@"true" forKey:@"keepLoggedIn" expirationDate:[[CPDate alloc] initWithTimeIntervalSinceNow:1845504000]];
				} else {
					[cookieController setValue:@"false" forKey:@"keepLoggedIn" expirationDate:[[CPDate alloc] initWithTimeIntervalSinceNow:1845504000]];
				}												 
				[loginButton setHidden:NO];
				[spinner setHidden:YES];
				[_delegate userDidLogIn];
			},
			error: function(user, error) {	
				var animation = [[EKShakeAnimation alloc] initWithView:loginView];
				setTimeout(function() {[usernameField setStringValue:@""]; [passwordField setStringValue:@""];}, 175);										   //error block
				//alert(error.message);
				[loginButton setHidden:NO];
				[spinner setHidden:YES];
			}
		});
	} else {
		var animation = [[EKShakeAnimation alloc] initWithView:loginView];
		[loginButton setHidden:NO];													  //present message for no details added
		[spinner setHidden:YES];
	}
}

- (void)showForgotPassword
{
	var cardFlipController = [LPCardFlipController sharedController];
    [cardFlipController setDelegate:self];
 	[forgotView setHidden:NO];
    [cardFlipController setStartCenter:[loginView center] endCenter:[loginView center]];
    [cardFlipController flipWithView:loginView backView:forgotView];
    setTimeout(function() {[[self view] addSubview:forgotView]}, 650);
}

- (IBAction)toggleRememberMeState:(id)aSender
{
	alert([aSender state]);
}

- (void)awakeFromCib
{
	//setup cookie
	cookieController = [LPCookieController sharedCookieController];
	
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
	
	[forgotFormBG setImage:[[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/forgot_id_background_image.png"]];
	//[loginButton setImage:[[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/login_go_arrow.png"]];
	[forgotView setHidden:YES];
	
	[privacyPolicyLink setURL:@"http://portal.youngmarists.org.nz/Privacy/privacyPolicy.pdf"];
	[forgotLink setAction:@selector(showForgotPassword) forTarget:self];
	[spinner setImage:[[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/spinner.gif"]];
	[spinner setHidden:YES];
	[spinner2 setImage:[[CPImage alloc] initWithContentsOfFile:@"Image\ Resources/spinner.gif"]];
	[spinner2 setHidden:YES];
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