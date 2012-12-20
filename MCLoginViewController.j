
@import <Foundation/Foundation.j>
@import "MCHoveringTextField.j"
@import "MCBackgroundView.j"


@implementation MCLoginViewController : CPViewController
{
	@outlet CPTextField usernameField;
	@outlet CPTextField passwordField;
	@outlet CPButton rememberButton;
	@outlet CPImageView bgImage;
    @outlet MCHoveringTextField forgotLink;
    @outlet MCBackgroundView background;
	
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
	//[background drawBackground];
	
	//var image = [[CPImage alloc] initWithContentsOfFile:@"deep-textured-backround.png"];
    //[bgImage setBackgroundColor:[CPColor colorWithPatternImage:image]];
}

@end