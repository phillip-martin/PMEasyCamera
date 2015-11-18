#import "PMDemoViewController.h"
#import "PMDemoView.h"
#import "UIView+ASYPresenterSupport.h"
#import <PMEasyCamera/PMEasyCamera.h>


@interface PMDemoViewController () <PMDemoViewObserver>

@property (nonatomic) PMDemoView *mainView;

@end

@implementation PMDemoViewController

- (instancetype)init {
    self = [super init];
    _mainView = [[PMDemoView alloc] initWithFrame:self.view.frame];
    [_mainView escAddObserver:self];
    return self;
}

- (void)loadView {
    [super loadView];
    self.view = self.mainView;
}

- (void)mainViewCameraButtonClicked {
    PMEasyCameraViewController *easyCameraViewController = [[PMEasyCameraViewController alloc] init];
    [self.navigationController pushViewController:easyCameraViewController animated:YES];
}

@end
