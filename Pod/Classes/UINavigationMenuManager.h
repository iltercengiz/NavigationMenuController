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
 <#description#>
 
 @param <#parameter#> <#description#>
 
 @return <#description#>
 
 @see <#selector#>
 @warning <#description#>
 */
- (UIViewController *)navigationMenuController:(UINavigationMenuController *)navigationMenuController viewControllerForMenuItemAtIndex:(NSInteger)index;

/**
 <#description#>
 
 @param <#parameter#> <#description#>
 
 @return <#description#>
 
 @see <#selector#>
 @warning <#description#>
 */
- (NSString *)navigationMenuController:(UINavigationMenuController *)navigationMenuController titleForMenuItemAtIndex:(NSInteger)index;

/**
 <#description#>
 
 @param <#parameter#> <#description#>
 
 @return <#description#>
 
 @see <#selector#>
 @warning <#description#>
 */
- (NSInteger)numberOfMenuItemsInNavigationMenuController:(UINavigationMenuController *)navigationMenuController;

@end
