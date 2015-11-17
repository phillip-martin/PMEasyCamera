#import "PMSquareCameraPresenter.h"
#import "UIView+ASYPresenterSupport.h"

@interface PMSquareCameraPresenter() <PMCameraModelObserver, PMSquareCameraViewObserver>

@property (nonatomic, weak) PMSquareCameraView *view;
@property (nonatomic) PMCameraModel *model;

@end

@implementation PMSquareCameraPresenter

+ (void)bindWithView:(PMSquareCameraView *)view model:(PMCameraModel *)model {
    PMSquareCameraPresenter *presenter = [[PMSquareCameraPresenter alloc] initWithView:view model:model];
    [view retainPresenter:presenter];
}

- (instancetype)initWithView:(PMSquareCameraView *)view model:(PMCameraModel *)model {
    self = [super init];
    _view = view;
    _model = model;
    [view escAddObserver:self];
    [model escAddObserver:self];
    [view setCaptureVideoPreviewLayerSession:model.session];
    return self;
}

- (void)captureButtonPressed {
    [self.model captureCurrentImage];
}

- (void)cancelButtonPressed {
    [self.model cancelCapturedImage];
}

- (void)cameraStateChanged {
    if(self.model.cameraState == PMCameraStateWillCapture) {
        [self.view configureWillCaptureMode];
    } else if(self.model.cameraState == PMCameraStateIsCapturing) {
        
    } else if(self.model.cameraState == PMCameraStateDidCapture) {
        [self.view setCapturedImage:self.model.capturedImage];
        [self.view configureDidCaptureMode];
    }
}

@end
