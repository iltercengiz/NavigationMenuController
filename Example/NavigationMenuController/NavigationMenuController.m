//
//  NavigationMenuController.m
//  NavigationMenuController
//
//  Created by Ilter Cengiz on 25/02/15.
//  Copyright (c) 2015 Ilter Cengiz. All rights reserved.
//

#import "NavigationMenuController.h"

@interface NavigationMenuController () <UINavigationMenuControllerDataSource, UINavigationMenuControllerDelegate>

@end

@implementation NavigationMenuController

#pragma mark - View life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.menuControllerDataSource = self;
    self.menuControllerDelegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
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

#pragma mark - Navigation menu controller delegate

- (void)navigationMenuController:(UINavigationMenuController *)navigationMenuController didSelectMenuItemAtIndex:(NSInteger)index {
    NSLog(@"-navigationMenuController:didSelectMenuItemAtIndex: %li", index);
}

@end
