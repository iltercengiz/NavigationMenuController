//
//  UINavigationMenuController.m
//  Pods
//
//  Created by Ilter Cengiz on 23/02/15.
//
//

#import "UINavigationMenuController.h"
#import "UINavigationMenuManager.h"

#import <LiveFrost/LiveFrost.h>

@interface UINavigationMenuController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate>

/**
 Collection view that is used for menu presentation.
 */
@property (nonatomic) UICollectionView *collectionView;

/**
 Navigation menu manager object used as a data source.
 Created in `checkIfViewControllerShouldShowMenu:` method if current view controller supports navigation menu.
 
 @see `checkIfViewControllerShouldShowMenu:`
 */
@property (nonatomic) UINavigationMenuManager *navigationMenuManager;

/**
 Size of every menu item.
 Calculated once and same for every item.
 */
@property (nonatomic) CGSize menuItemSize;

/**
 This is used to blur the background content while showing the menu.
 */
@property (nonatomic) LFGlassView *blurView;

/**
 These are used to hold references to bar buttons to hide/show them when showing/dismissing the menu.
 */
@property (nonatomic) NSArray *leftBarButtonItems;
@property (nonatomic) NSArray *rightBarButtonItems;

@property (weak, nonatomic) NSLayoutConstraint *constraintCollectionViewTopToTop;
@property (weak, nonatomic) NSLayoutConstraint *constraintCollectionViewBottomToBottom;

@end

@implementation UINavigationMenuController

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
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), 0.0)
                                             collectionViewLayout:[UICollectionViewFlowLayout new]];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(64.0, 0.0, 0.0, 0.0);
    self.collectionView.hidden = YES;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MenuItemCollectionViewCell"];
    [self.view insertSubview:self.collectionView belowSubview:self.navigationBar];
    
    self.blurView = [[LFGlassView alloc] initWithFrame:self.view.bounds];
    self.blurView.alpha = 0.0;
    self.blurView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view insertSubview:self.blurView belowSubview:self.collectionView];
    
    NSDictionary *views = @{@"collectionView": self.collectionView, @"blurView": self.blurView};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|" options:0 metrics:nil views:views]];
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:-CGRectGetHeight(self.view.frame)];
    [self.view addConstraint:constraint];
    self.constraintCollectionViewTopToTop = constraint;
    
    constraint = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-CGRectGetHeight(self.view.frame)];
    [self.view addConstraint:constraint];
    self.constraintCollectionViewBottomToBottom = constraint;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[blurView]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[blurView]-0-|" options:0 metrics:nil views:views]];
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

#pragma mark - Public methods

- (void)setMenuTitle:(NSString *)menuTitle {
    UIButton *menuButton = (UIButton *)self.topViewController.navigationItem.titleView;
    [menuButton setTitle:menuTitle forState:UIControlStateNormal];
}

#pragma mark - IBAction

- (IBAction)didTapMenuButton:(id)sender {
    UIButton *menuButton = sender;
    if (!menuButton.selected) {
        [self showMenu];
    } else {
        [self dismissMenu];
    }
    menuButton.selected = !menuButton.selected;
}

#pragma mark - Getter

- (CGSize)menuItemSize {
    if (CGSizeEqualToSize(_menuItemSize, CGSizeZero)) {
        NSInteger numberOfItems = [self.navigationMenuManager numberOfMenuItemsInNavigationMenuController:self];
        CGFloat spaces = 10 * (numberOfItems + 1);
        CGFloat totalHeight = CGRectGetHeight(self.collectionView.frame) - CGRectGetHeight(self.navigationBar.frame) - 20.0; // 20.0 for status bar
        CGFloat height = (totalHeight - spaces) / numberOfItems;
        _menuItemSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame) - 32.0, height);
    }
    return _menuItemSize;
}

#pragma mark - Helpers

/**
 Checks if the given view controller should have navigation menu or not.
 Control is made by checking if `viewController` conforms to `UINavigationMenuControllerDelegate` protocol and implements `-dataSourceClassForNavigationMenuController:` method.
 This method is called from several methods overridden from `UINavigationController` to catch every view controller that is added to the navigation stack.
 
 @param viewController View controller object that is newly added to the navigation stack
 
 @see `-initWithRootViewController:`
 @see `-initWithCoder:`
 @see `-setViewControllers:animated:`
 @see `-pushViewController:animated:`
 */
- (void)checkIfViewControllerShouldShowMenu:(UIViewController *)viewController {
    if ([viewController conformsToProtocol:@protocol(UINavigationMenuControllerDelegate)] &&
        [viewController respondsToSelector:@selector(dataSourceClassForNavigationMenuController:)]) {
        id<UINavigationMenuControllerDelegate> dataSourceProvider = (id<UINavigationMenuControllerDelegate>)viewController;
        Class navigationMenuManagerClass = [dataSourceProvider dataSourceClassForNavigationMenuController:self];
        NSAssert([navigationMenuManagerClass isSubclassOfClass:[UINavigationMenuManager class]],
                 @"Provided menu manager must be a subclass of UINavigationMenuManager");
        self.navigationMenuManager = [navigationMenuManagerClass new];
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

/**
 Shows the menu with an animation
 
 @see `-didTapMenuButton:`
 */
- (void)showMenu {
    self.collectionView.hidden = NO;
    self.constraintCollectionViewTopToTop.constant = 0.0;
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    self.constraintCollectionViewBottomToBottom.constant = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        self.blurView.alpha = 1.0;
    }];
    
    self.leftBarButtonItems = self.topViewController.navigationItem.leftBarButtonItems;
    self.rightBarButtonItems = self.topViewController.navigationItem.rightBarButtonItems;
    
    [self.topViewController.navigationItem setLeftBarButtonItems:nil animated:YES];
    [self.topViewController.navigationItem setRightBarButtonItems:nil animated:YES];
    [self.topViewController.navigationItem setHidesBackButton:YES animated:YES];
}

/**
 Dismisses the open menu with an animation
 
 @see `-didTapMenuButton:`
 @see `collectionView:didSelectItemAtIndexPath:`
 */
- (void)dismissMenu {
    self.constraintCollectionViewBottomToBottom.constant = -CGRectGetHeight(self.view.frame);
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        self.blurView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.collectionView.hidden = YES;
        self.constraintCollectionViewTopToTop.constant = -CGRectGetHeight(self.view.frame);
    }];
    
    self.leftBarButtonItems = nil;
    self.rightBarButtonItems = nil;
    
    [self.topViewController.navigationItem setLeftBarButtonItems:self.leftBarButtonItems animated:YES];
    [self.topViewController.navigationItem setRightBarButtonItems:self.rightBarButtonItems animated:YES];
    [self.topViewController.navigationItem setHidesBackButton:NO animated:YES];
}

#pragma mark - Collection view data source

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MenuItemCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
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
    NSAssert([self.navigationMenuManager respondsToSelector:@selector(navigationMenuController:titleForMenuItemAtIndex:)],
             @"Either `navigationMenuManager` is not provided or it does not implement `-navigationMenuController:titleForMenuItemAtIndex:`!");
    titleLabel.text = [self.navigationMenuManager navigationMenuController:self titleForMenuItemAtIndex:indexPath.item];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSAssert([self.navigationMenuManager respondsToSelector:@selector(numberOfMenuItemsInNavigationMenuController:)],
             @"Either `navigationMenuManager` is not provided or it does not implement `-numberOfMenuItemsInNavigationMenuController:`!");
    return [self.navigationMenuManager numberOfMenuItemsInNavigationMenuController:self];
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert([self.navigationMenuManager respondsToSelector:@selector(navigationMenuController:viewControllerForMenuItemAtIndex:)],
             @"Either `navigationMenuManager` is not provided or it does not implement `-navigationMenuController:viewControllerForMenuItemAtIndex:`!");
    UIViewController *viewController = [self.navigationMenuManager navigationMenuController:self viewControllerForMenuItemAtIndex:indexPath.item];
    viewController.title = [self.navigationMenuManager navigationMenuController:self titleForMenuItemAtIndex:indexPath.item];
    NSMutableArray *mutableViewControllers = [self.viewControllers mutableCopy];
    [mutableViewControllers replaceObjectAtIndex:mutableViewControllers.count - 1 withObject:viewController];
    [self setViewControllers:mutableViewControllers animated:NO];
    [self dismissMenu];
}

#pragma mark - Collection view delegate flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.menuItemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10.0, 0.0, 0.0, 0.0);
}

@end
