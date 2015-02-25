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
 <#description#>
 
 @see <#selector#>
 @warning <#description#>
 */
@property (weak, nonatomic) id<UINavigationMenuControllerDelegate> menuControllerDelegate;

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
- (Class)dataSourceClassForNavigationMenuController:(UINavigationMenuController *)navigationMenuController;

@end
