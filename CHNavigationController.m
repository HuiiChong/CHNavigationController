//
//  CHNavigationController.m
//  AviationNews
//
//  Created by apple on 17/1/23.
//  Copyright © 2017年 庄春辉. All rights reserved.
//

#import "CHNavigationController.h"
#import "UIViewController+Navigation.h"
#import "CHNavigationConfig.h"
#import "CHPushAnimatedTransitioning.h"

// 停止手势时判断是否需要push的临界值.
const CGFloat CHPushBorderlineDelta = 0.45;

@interface CHWrapNavigationController : UINavigationController

@end

@implementation CHWrapNavigationController

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return [self.navigationController popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    return [self.navigationController popToRootViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    CHNavigationController *navigationController = viewController.ch_navigationController;
    NSInteger index = [navigationController.ch_viewControllers indexOfObject:viewController];
    return [self.navigationController popToViewController:navigationController.viewControllers[index] animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.ch_navigationController = (CHNavigationController *)self.navigationController;
    //修复can t add self as subview bug
    if(animated){
        if(viewController.ch_navigationController.isAnimating){
            return;
        }
        viewController.ch_navigationController.isAnimating = YES;
    }
    if(viewController.ch_isDefaultStatusBar){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    UIImage *backButtonImage = viewController.ch_navigationController.backButtonImage;
    if (!backButtonImage) {
        backButtonImage = [UIImage imageNamed:@"navbar_back_black"];
    }
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(tapBackButton)];
    [self.navigationController pushViewController:[CHWrapViewController wrapWithViewController:viewController] animated:animated];
}

- (void)tapBackButton
{
    CHNavigationController *_navigationController = (CHNavigationController *)self.navigationController;
    NSArray *_controllers = _navigationController.ch_viewControllers;
    UIViewController *_controller = _controllers[_controllers.count-1];
    if(![_controller didPopClick]){
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [self.navigationController dismissViewControllerAnimated:flag completion:completion];
    self.viewControllers.firstObject.ch_navigationController = nil;
}

@end

///
#pragma mark
#pragma mark wrapViewController

static NSValue *ch_tabBarRectValue;

@implementation CHWrapViewController

+ (CHWrapViewController *)wrapWithViewController:(UIViewController *)viewController
{
    CHWrapNavigationController *wrapNavController = [[CHWrapNavigationController alloc] init];
    wrapNavController.view.backgroundColor = [UIColor whiteColor];
    wrapNavController.viewControllers = @[viewController];
    
    CHWrapViewController *wrapViewController = [[CHWrapViewController alloc] init];
    wrapViewController.view.backgroundColor = [UIColor whiteColor];
    [wrapViewController.view addSubview:wrapNavController.view];
    [wrapViewController addChildViewController:wrapNavController];
    
    return wrapViewController;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(self.tabBarController && !ch_tabBarRectValue) {
        ch_tabBarRectValue = [NSValue valueWithCGRect:self.tabBarController.tabBar.frame];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.tabBarController && [self rootViewController].hidesBottomBarWhenPushed) {
        self.tabBarController.tabBar.frame = CGRectZero;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.translucent = YES;
    if(self.tabBarController && !self.tabBarController.tabBar.hidden && ch_tabBarRectValue) {
        self.tabBarController.tabBar.frame = ch_tabBarRectValue.CGRectValue;
    }
}

- (BOOL)ch_fullScreenEnabled
{
    return [self rootViewController].ch_fullScreenEnabled;
}

- (BOOL)ch_leftGestureEnabled
{
    return [self rootViewController].ch_leftGestureEnabled;
}

- (BOOL)hidesBottomBarWhenPushed
{
    return [self rootViewController].hidesBottomBarWhenPushed;
}

- (UITabBarItem *)tabBarItem
{
    return [self rootViewController].tabBarItem;
}

- (NSString *)title
{
    return [self rootViewController].title;
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return [self rootViewController];
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return [self rootViewController];
}

- (UIViewController *)rootViewController
{
    CHWrapNavigationController *wrapNavController = self.childViewControllers.firstObject;
    return wrapNavController.viewControllers.firstObject;
}

- (BOOL)didPopClick
{
    return [[self rootViewController] didPopClick];
}

@end

///

@interface CHNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
{
    UIImage                                 *_snapImage;
    BOOL                                    _isLeftPush;
    CHPushAnimatedTransitioning             *_transitioning;
    UIPercentDrivenInteractiveTransition    *_interactivePopTransition;
}

@end

@implementation CHNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super init];
    if(self){
        rootViewController.ch_navigationController = self;
        self.viewControllers = @[[CHWrapViewController wrapWithViewController:rootViewController]];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.viewControllers.firstObject.ch_navigationController = self;
        self.viewControllers = @[[CHWrapViewController wrapWithViewController:self.viewControllers.firstObject]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBarHidden:YES];
    self.delegate = self;
    
    //  这句很核心 稍后讲解
//    id target = self.interactivePopGestureRecognizer.delegate;
    //  这句很核心 稍后讲解
//    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    //  获取添加系统边缘触发手势的View
//    UIView *targetView = self.interactivePopGestureRecognizer.view;
    
    // 创建pan手势 作用范围是全屏
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleControllerPop:)];
    panGesture.delegate = self;
    [self.interactivePopGestureRecognizer.view addGestureRecognizer:panGesture];
    
    // 关闭边缘触发手势 防止和原有边缘手势冲突
    [self.interactivePopGestureRecognizer setEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark method

- (NSArray *)ch_viewControllers
{
    NSMutableArray *viewControllers = @[].mutableCopy;
    for (CHWrapViewController *wrapViewController in self.viewControllers) {
        [viewControllers addObject:wrapViewController.rootViewController];
    }
    return viewControllers.copy;
}

- (void)insertViewController:(UIViewController *)viewController index:(NSInteger)index
{
    if(index<self.viewControllers.count){
        NSMutableArray *_controllers = @[].mutableCopy;
        [_controllers addObjectsFromArray:self.viewControllers];
        [_controllers insertObject:[CHWrapViewController wrapWithViewController:viewController] atIndex:index];
        self.viewControllers = _controllers;
    }
}

- (void)removeViewController:(NSInteger)index
{
    NSMutableArray *_controllers = @[].mutableCopy;
    [_controllers addObjectsFromArray:self.viewControllers];
    [_controllers removeObjectAtIndex:index];
    self.viewControllers = _controllers;
}

- (CHPushAnimatedTransitioning *)_getTransitioning
{
    if(!_transitioning){
        _transitioning = [CHPushAnimatedTransitioning new];
    }
    return _transitioning;
}

#pragma mark
#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.isAnimating = NO;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (_isLeftPush && operation == UINavigationControllerOperationPush) {
        [self _getTransitioning].snapImage = _snapImage;
        return _transitioning;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if (_isLeftPush && [animationController isKindOfClass:[CHPushAnimatedTransitioning class]]) {
        return _interactivePopTransition;
    }
    return nil;
}

#pragma mark
#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if(_interactivePopTransition||_isLeftPush){
        return NO;
    }
    //根据左滑和右滑判断
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    UIViewController *_controller = self.ch_viewControllers[self.ch_viewControllers.count-1];
    if(!_controller.ch_gestureEnabled){
        return NO;
    }
    if(_controller.ch_leftGestureEnabled){
        //左滑打开
        if(translation.x <= 0){
            //左滑
            UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
            _snapImage = [CHNavigationConfig snapShotWithView:rootVc.view];
            [gestureRecognizer removeTarget:self.interactivePopGestureRecognizer.delegate action:action];
            return YES;
        }else {
            [gestureRecognizer addTarget:self.interactivePopGestureRecognizer.delegate action:action];
        }
    }else{
        //左滑关闭
        // 解决右滑和UITableView左滑删除的冲突
        if(translation.x <= 0){
            return NO;
        }else{
            [gestureRecognizer addTarget:self.interactivePopGestureRecognizer.delegate action:action];
        }
    }
    
    // 正在做过渡动画的时候禁止pop.
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    //  防止导航控制器只有一个rootViewcontroller时触发手势
    return self.childViewControllers.count == 1 ? NO : YES;
}

- (void)handleControllerPop:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:recognizer.view];
    CGFloat progress = translation.x / recognizer.view.bounds.size.width;
    CGPoint speed = [recognizer velocityInView:recognizer.view];
    if(recognizer.state == UIGestureRecognizerStateBegan){
        _isLeftPush = speed.x < 0 ? YES : NO;
        if(!_isLeftPush){
            return;
        }
        
        progress = -progress;
        progress = MIN(1.0, MAX(0.0, progress));
        
        if ([self.nav_delegate respondsToSelector:@selector(didLeftPush)]) {
            _interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
            _interactivePopTransition.completionCurve = UIViewAnimationCurveEaseOut;
            [self.nav_delegate didLeftPush];
            [_interactivePopTransition updateInteractiveTransition:0];
        }
    }else if(recognizer.state == UIGestureRecognizerStateChanged){
        if (_isLeftPush) {
            progress = -progress;
            progress = MIN(1.0, MAX(0.0, progress));
            
            [_interactivePopTransition updateInteractiveTransition:progress];
        }
    }else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled||recognizer.state==UIGestureRecognizerStateFailed){
        if (_isLeftPush) {
            progress = -progress;
            progress = MIN(1.0, MAX(0.0, progress));
            
            if(progress==1.0){
                [_interactivePopTransition finishInteractiveTransition];
            }else if (progress > CHPushBorderlineDelta) {
                [_interactivePopTransition finishInteractiveTransition];
            }else {
                if(fabs(speed.x)>400&&fabs(translation.x)>70){
                    [_interactivePopTransition finishInteractiveTransition];
                }else{
                    [_interactivePopTransition cancelInteractiveTransition];
                }
            }
            self.isAnimating = NO;
            _interactivePopTransition = nil;
            _isLeftPush = NO;
        }
    }
}

@end
