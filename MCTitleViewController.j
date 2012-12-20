
@import <Foundation/Foundation.j>

@implementation MCTitleViewController : CPViewController
{
	@outlet CPButton logoutButton;
}

- (void)awakeFromCib
{
	[logoutButton setTitle:@"Logout"];
}

@end