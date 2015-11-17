#import "PMEasyCameraViewController.h"
#import "PMSquareCameraPresenter.h"
#import "UIView+ASYPresenterSupport.h"

@interface PMEasyCameraViewController () <PMSquareCameraViewObserver, PMCameraModelObserver>

@property (nonatomic) PMCameraModel *cameraModel;

@end

@implementation PMEasyCameraViewController

BOOL isUsingFrontFacingCamera;

- (instancetype)init {
    self = [super init];
    if(self) {
        PMSquareCameraView *squareCameraView = [[PMSquareCameraView alloc] initWithFrame:self.view.frame];
        [squareCameraView escAddObserver:self];
        self.view = squareCameraView;
        self.cameraModel = [[PMCameraModel alloc] init];
        [self.cameraModel escAddObserver:self];
        [PMSquareCameraPresenter bindWithView:squareCameraView model:self.cameraModel];
    }
    return self;
}


- (void)loadView {
    [super loadView];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)cameraStateChanged {
    if(self.cameraModel.cameraState == PMCameraStateWillCapture) {
        //camera is ready to capture image
    } else if(self.cameraModel.cameraState == PMCameraStateIsCapturing) {
        //camera is currently capturing the image
    } else if(self.cameraModel.cameraState == PMCameraStateDidCapture) {
        //camera has selected an image
    }
}

@end
