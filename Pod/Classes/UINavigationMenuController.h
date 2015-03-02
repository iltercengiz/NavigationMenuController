//
//  UINavigationMenuController.h
//  Pods
//
//  Created by Ilter Cengiz on 23/02/15.
//
//

#import <UIKit/UIKit.h>

@class UINavigationMenuManager;
@protocol UINavigationMenuControllerDelegate;

@interface UINavigationMenuController : UINavigationController

/**
 Sets the given title to the menu button.
 
 @param `menuTitle` Title to be set
 */
- (void)setMenuTitle:(NSString *)menuTitle;

@end

@protocol UINavigationMenuControllerDelegate <NSObject>

/**
 View controllers that should have navigation menu enabled must conform to `UINavigationMenuControllerDelegate` protocol, implement this method, and return a valid menu manager class, in this case a subclass of `UINavigationMenuManager`.
 This method is used to ask for the class of the menu manager that will be used as data source of the navigation menu controller.
 Classes returned with this menu must have overridden the public methods available in `UINavigationMenuManager`.
 Navigation menu is not enabled for the view controllers in stack which don't conform to `UINavigationMenuControllerDelegate` protocol and implement this method. In this case, behind the scenes navigation controller works like it should.
 
 @param navigationMenuController Navigation menu controller object that asks for the menu manager class
 
 @return Custom menu manager class
 
 @warning View controllers that are presented for the menu items should return a valid class
 */
- (Class)dataSourceClassForNavigationMenuController:(UINavigationMenuController *)navigationMenuController;

@end
