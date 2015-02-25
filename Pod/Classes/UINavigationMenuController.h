//
//  UINavigationMenuController.h
//  Pods
//
//  Created by Ilter Cengiz on 23/02/15.
//
//

#import <UIKit/UIKit.h>

@protocol UINavigationMenuControllerDataSource;
@protocol UINavigationMenuControllerDelegate;

@interface UINavigationMenuController : UINavigationController

/**
 <#description#>
 
 @see <#selector#>
 @warning <#description#>
 */
@property (weak, nonatomic) id<UINavigationMenuControllerDataSource> menuControllerDataSource;

/**
 <#description#>
 
 @see <#selector#>
 @warning <#description#>
 */
@property (weak, nonatomic) id<UINavigationMenuControllerDelegate> menuControllerDelegate;

@end

@protocol UINavigationMenuControllerDataSource <NSObject>

@required

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

@protocol UINavigationMenuControllerDelegate <NSObject>

@optional

/**
 <#description#>
 
 @param <#parameter#> <#description#>
 
 @return <#description#>
 
 @see <#selector#>
 @warning <#description#>
 */
- (void)navigationMenuController:(UINavigationMenuController *)navigationMenuController didSelectMenuItemAtIndex:(NSInteger)index;

@end
