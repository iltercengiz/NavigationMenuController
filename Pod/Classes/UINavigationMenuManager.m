//
//  UINavigationMenuManager.m
//  Pods
//
//  Created by Ilter Cengiz on 25/02/15.
//
//

#import "UINavigationMenuManager.h"

@implementation UINavigationMenuManager

- (UIViewController *)navigationMenuController:(UINavigationMenuController *)navigationMenuController viewControllerForMenuItemAtIndex:(NSInteger)index {
    NSAssert(NO, @"-navigationMenuController:viewControllerForMenuItemAtIndex: must be overridden in subclass");
    return nil;
}

- (NSString *)navigationMenuController:(UINavigationMenuController *)navigationMenuController titleForMenuItemAtIndex:(NSInteger)index {
    NSAssert(NO, @"-navigationMenuController:titleForMenuItemAtIndex: must be overridden in subclass");
    return nil;
}

- (NSInteger)numberOfMenuItemsInNavigationMenuController:(UINavigationMenuController *)navigationMenuController {
    NSAssert(NO, @"-numberOfMenuItemsInNavigationMenuController: must be overridden in subclass");
    return 0;
}

@end
