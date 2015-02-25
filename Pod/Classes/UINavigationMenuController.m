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
@property (nonatomic) UICollectionViewController *collectionViewController;

/**
 <#description#>
 
 @see <#selector#>
 @warning <#description#>
 */
@property (nonatomic) id<UINavigationMenuControllerDataSource> menuManager;

@end

@implementation UINavigationMenuController

#pragma mark - NSObject UIKit Additions

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - Initialization

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self checkIfViewControllerShouldShowMenu:rootViewController];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self checkIfViewControllerShouldShowMenu:self.topViewController];
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
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

#pragma mark - Stack management

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    
    [super setViewControllers:viewControllers animated:animated];
    
    [self checkIfViewControllerShouldShowMenu:[viewControllers lastObject]];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [super pushViewController:viewController animated:animated];
    
    [self checkIfViewControllerShouldShowMenu:viewController];
    
}

#pragma mark - IBAction

- (IBAction)didTapMenuButton:(id)sender {
    
    UIButton *menuButton = sender;
    
    // Show the menu
    if (!menuButton.selected) {
        
        self.collectionViewController.view.frame = self.view.bounds;
        
        [self.collectionViewController willMoveToParentViewController:self];
        [self.view insertSubview:self.collectionViewController.view belowSubview:self.navigationBar];
        [self.collectionViewController didMoveToParentViewController:self];
        
    }
    
    // Hide the menu
    else {
        
        [self.collectionViewController.view removeFromSuperview];
        
    }
    
    menuButton.selected = !menuButton.selected;
    
}

#pragma mark - Helpers

- (void)checkIfViewControllerShouldShowMenu:(UIViewController *)viewController {
    
    if ([viewController conformsToProtocol:@protocol(UINavigationMenuControllerDelegate)] &&
        [viewController respondsToSelector:@selector(dataSourceClassForNavigationMenuController:)])
    {
        
        id<UINavigationMenuControllerDelegate> dataSourceProvider = (id<UINavigationMenuControllerDelegate>)viewController;
        
        Class menuManagerClass = [dataSourceProvider dataSourceClassForNavigationMenuController:self];
        
        self.menuManager = [menuManagerClass new];
        
        // Menu button on the navigation bar
        
        UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuButton addTarget:self action:@selector(didTapMenuButton:) forControlEvents:UIControlEventTouchUpInside];
        [menuButton setTitle:viewController.title forState:UIControlStateNormal];
        [menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [menuButton sizeToFit];
        
        // Navigation items are per view controllers on the stack, so add the button to the navigation item of top view controller
        
        viewController.navigationItem.titleView = menuButton;
        
    }
    
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
    
    NSAssert([self.menuManager respondsToSelector:@selector(navigationMenuController:titleForMenuItemAtIndex:)],
             @"Either `menuControllerDataSource` is not provided or it does not implement `-navigationMenuController:titleForMenuItemAtIndex:`!");
    
    titleLabel.text = [self.menuManager navigationMenuController:self titleForMenuItemAtIndex:indexPath.item];
    
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSAssert([self.menuManager respondsToSelector:@selector(numberOfMenuItemsInNavigationMenuController:)],
             @"Either `menuControllerDataSource` is not provided or it does not implement `-numberOfMenuItemsInNavigationMenuController:`!");
    
    return [self.menuManager numberOfMenuItemsInNavigationMenuController:self];
    
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSAssert([self.menuManager respondsToSelector:@selector(navigationMenuController:viewControllerForMenuItemAtIndex:)],
             @"Either `menuControllerDataSource` is not provided or it does not implement `-navigationMenuController:viewControllerForMenuItemAtIndex:`!");
    
    UIViewController *viewController = [self.menuManager navigationMenuController:self viewControllerForMenuItemAtIndex:indexPath.item];
    
    NSMutableArray *mutableViewControllers = [self.viewControllers mutableCopy];
    [mutableViewControllers replaceObjectAtIndex:mutableViewControllers.count - 1 withObject:viewController];
    
    [self setViewControllers:mutableViewControllers animated:NO];
    
    [self.collectionViewController.view removeFromSuperview];
    
}

#pragma mark - Collection view delegate flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(collectionView.frame) - 32.0, 72.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10.0, 0.0, 0.0, 0.0);
}

@end
