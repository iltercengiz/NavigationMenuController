//
//  UINavigationMenuController.m
//  Pods
//
//  Created by Ilter Cengiz on 23/02/15.
//
//

#import "UINavigationMenuController.h"

@interface UINavigationMenuController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/**
 <#description#>
 
 @see <#selector#>
 @warning <#description#>
 */
@property (nonatomic) UIViewController *contentViewController;

/**
 <#description#>
 
 @see <#selector#>
 @warning <#description#>
 */
@property (nonatomic) UIViewController *currentViewController;

/**
 <#description#>
 
 @see <#selector#>
 @warning <#description#>
 */
@property (nonatomic) UIButton *menuButton;

/**
 <#description#>
 
 @see <#selector#>
 @warning <#description#>
 */
@property (nonatomic) UICollectionViewController *collectionViewController;

@end

@implementation UINavigationMenuController

#pragma mark - NSObject UIKit Additions

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    NSAssert(self.topViewController == nil, @"Either programmatically or from Interface Builder, root view controller of this class should not be set!");
    
    self.contentViewController = [UIViewController new];
    self.contentViewController.view.backgroundColor = [UIColor lightGrayColor];
    
    [self setViewControllers:@[self.contentViewController]];
    
}

#pragma mark - Initialization

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super init];
    if (self) {
        NSLog(@"Either programmatically or from Interface Builder, root view controller of this class should not be set!");
        // Override this method to prevent setting the root view controller
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Menu button on the navigation bar
    
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.menuButton addTarget:self action:@selector(didTapMenuButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuButton setTitle:@"Title" forState:UIControlStateNormal];
    [self.menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.menuButton sizeToFit];
    
    // Navigation items are per view controllers on the stack, so add the button to the navigation item of top view controller
    
    [self.contentViewController.navigationItem setTitleView:self.menuButton];
    
    // Create and configure the collection view controller that will be used as menu
    
    self.collectionViewController = [[UICollectionViewController alloc] initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
    self.collectionViewController.collectionView.dataSource = self;
    self.collectionViewController.collectionView.delegate = self;
    
    self.collectionViewController.collectionView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.collectionViewController.collectionView.contentInset = UIEdgeInsetsMake(64.0, 0.0, 0.0, 0.0);
    
    [self.collectionViewController.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MenuItemCollectionViewCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (IBAction)didTapMenuButton:(id)sender {
    
    // Show the menu
    if (self.menuButton.selected) {
        
        self.collectionViewController.view.frame = self.view.bounds;
        
        [self.collectionViewController willMoveToParentViewController:self.contentViewController];
        [self.contentViewController.view addSubview:self.collectionViewController.view];
        [self.collectionViewController didMoveToParentViewController:self.contentViewController];
        
    }
    
    // Hide the menu
    else {
        
        [self.collectionViewController.view removeFromSuperview];
        
    }
    
    self.menuButton.selected = !self.menuButton.selected;
    
}

#pragma mark - Collection view data source

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MenuItemCollectionViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithWhite:(CGFloat)(arc4random() % 255)/255.0 alpha:1.0];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    
    if (titleLabel == nil) {
        
        titleLabel = [UILabel new];
        
        titleLabel.numberOfLines = 0;
        titleLabel.tag = 1;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [cell addSubview:titleLabel];
        
        NSDictionary *views = @{@"titleLabel": titleLabel};
        
        NSMutableArray *constraints = [NSMutableArray array];
        
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[titleLabel]-0-|" options:0 metrics:nil views:views]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[titleLabel]-0-|" options:0 metrics:nil views:views]];
        
        [cell addConstraints:constraints];
        
    }
    
    NSAssert([self.menuControllerDataSource respondsToSelector:@selector(navigationMenuController:titleForMenuItemAtIndex:)],
             @"Either `menuControllerDataSource` is not provided or it does not implement `-navigationMenuController:titleForMenuItemAtIndex:`!");
    
    titleLabel.text = [self.menuControllerDataSource navigationMenuController:self titleForMenuItemAtIndex:indexPath.item];
    
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSAssert([self.menuControllerDataSource respondsToSelector:@selector(numberOfMenuItemsInNavigationMenuController:)],
             @"Either `menuControllerDataSource` is not provided or it does not implement `-numberOfMenuItemsInNavigationMenuController:`!");
    
    return [self.menuControllerDataSource numberOfMenuItemsInNavigationMenuController:self];
    
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSAssert([self.menuControllerDataSource respondsToSelector:@selector(navigationMenuController:viewControllerForMenuItemAtIndex:)],
             @"Either `menuControllerDataSource` is not provided or it does not implement `-navigationMenuController:viewControllerForMenuItemAtIndex:`!");
    
    // Remove the current view controller from the view hierarchy, if there's any
    if (self.currentViewController) {
        [self.currentViewController.view removeFromSuperview];
    }
    
    // Get the view controller from the data source
    self.currentViewController = [self.menuControllerDataSource navigationMenuController:self viewControllerForMenuItemAtIndex:indexPath.item];
    
    // Add it as a child view controller
    self.currentViewController.view.frame = self.view.bounds;
    
    [self.currentViewController willMoveToParentViewController:self.contentViewController];
    [self.contentViewController.view addSubview:self.currentViewController.view];
    [self.currentViewController didMoveToParentViewController:self.contentViewController];
    
    // Inform the delegate
    if ([self.menuControllerDelegate respondsToSelector:@selector(navigationMenuController:didSelectMenuItemAtIndex:)]) {
        [self.menuControllerDelegate navigationMenuController:self didSelectMenuItemAtIndex:indexPath.item];
    }
    
}

#pragma mark - Collection view delegate flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(collectionView.frame) - 32.0, 72.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10.0, 0.0, 0.0, 0.0);
}

@end
