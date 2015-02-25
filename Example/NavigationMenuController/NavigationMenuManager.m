//
//  NavigationMenuManager.m
//  NavigationMenuController
//
//  Created by Ilter Cengiz on 25/02/15.
//  Copyright (c) 2015 Ilter Cengiz. All rights reserved.
//

#import "NavigationMenuManager.h"

@interface NavigationMenuManager ()

@property (nonatomic) UIStoryboard *storyboard;

@end

@implementation NavigationMenuManager

#pragma mark - Getter

- (UIStoryboard *)storyboard {
    if (!_storyboard) {
        _storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
    return _storyboard;
}

#pragma mark - Navigation menu controller data source

- (UIViewController *)navigationMenuController:(UINavigationMenuController *)navigationMenuController viewControllerForMenuItemAtIndex:(NSInteger)index {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuItemViewController"];
    UILabel *label = (UILabel *)[vc.view viewWithTag:1];
    label.text = [NSString stringWithFormat:@"View Controller %li", index + 1];
    return vc;
}

- (NSString *)navigationMenuController:(UINavigationMenuController *)navigationMenuController titleForMenuItemAtIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"Title %li", index + 1];
}

- (NSInteger)numberOfMenuItemsInNavigationMenuController:(UINavigationMenuController *)navigationMenuController {
    return 6;
}

@end
