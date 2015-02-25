//
//  NavigationMenuManager.m
//  NavigationMenuController
//
//  Created by Ilter Cengiz on 25/02/15.
//  Copyright (c) 2015 Ilter Cengiz. All rights reserved.
//

#import "NavigationMenuManager.h"

@implementation NavigationMenuManager

#pragma mark - Overrides

- (UIViewController *)navigationMenuController:(UINavigationMenuController *)navigationMenuController viewControllerForMenuItemAtIndex:(NSInteger)index {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MenuItemViewController"];
    vc.title = [NSString stringWithFormat:@"Menu Item %li", index + 1];
    
    UILabel *label = (UILabel *)[vc.view viewWithTag:1];
    label.text = [NSString stringWithFormat:@"Menu Item %li", index + 1];
    
    return vc;
    
}

- (NSString *)navigationMenuController:(UINavigationMenuController *)navigationMenuController titleForMenuItemAtIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"Menu Item %li", index + 1];
}

- (NSInteger)numberOfMenuItemsInNavigationMenuController:(UINavigationMenuController *)navigationMenuController {
    return 6;
}

@end
