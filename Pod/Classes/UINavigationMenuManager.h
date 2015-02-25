//
//  UINavigationMenuManager.h
//  Pods
//
//  Created by Ilter Cengiz on 25/02/15.
//
//

#import <Foundation/Foundation.h>

#import "UINavigationMenuController.h"

@interface UINavigationMenuManager : NSObject

/**
 Returns a view controller for the given index that will be presented by the navigation menu controller.
 
 @param navigationMenuController Navigation menu controller object that asks for the view controller
 @param index Index of the view controller in question
 
 @return A view controller to be presented
 
 @warning Subclasses must override this method, otherwise an assertion will throw an exception
 */
- (UIViewController *)navigationMenuController:(UINavigationMenuController *)navigationMenuController viewControllerForMenuItemAtIndex:(NSInteger)index;

/**
 Returns a title for the menu item for the given index that will be shown in the appropriate entry in the menu.
 
 @param navigationMenuController Navigation menu controller object that asks for the title
 @param index Index of the menu item whom title is asked for
 
 @return A title for the menu item
 
 @warning Subclasses must override this method, otherwise an assertion will throw an exception
 */
- (NSString *)navigationMenuController:(UINavigationMenuController *)navigationMenuController titleForMenuItemAtIndex:(NSInteger)index;

/**
 Returns the number of menu items that will be available in the menu.
 
 @param navigationMenuController Navigation menu controller object that asks how many items should be available in the menu
 
 @return Number of menu items
 
 @warning Subclasses must override this method, otherwise an assertion will throw an exception
 */
- (NSInteger)numberOfMenuItemsInNavigationMenuController:(UINavigationMenuController *)navigationMenuController;

@end
