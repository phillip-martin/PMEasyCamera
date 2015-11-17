#import "MainViewController.h"
#import "MainView.h"
#import "UIView+ASYPresenterSupport.h"
#import "PMEasyCamera/PMEasyCamera.h"


@interface MainViewController () <MainViewObserver>

@property (nonatomic) MainView *mainView;

@end

@implementation MainViewController

- (instancetype)init {
    self = [super init];
    _mainView = [[MainView alloc] initWithFrame:self.view.frame];
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
    //[self pushViewController:easyCameraViewController animated:YES completion:NULL];
}

@end
