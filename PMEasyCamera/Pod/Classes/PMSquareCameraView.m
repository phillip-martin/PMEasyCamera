#import "PMSquareCameraView.h"

@interface PMSquareCameraView() <ESCObservableInternal>

@property (nonatomic) UIView *frameForCapture;
@property (nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic) UIImageView *capturedImageView;
@property (nonatomic) UIView *controlsView;
@property (nonatomic) UIButton *captureButton;
@property (nonatomic) UIButton *cancelButton;

@end

@implementation PMSquareCameraView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self escRegisterObserverProtocol:@protocol(PMSquareCameraViewObserver)];
        _frameForCapture = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    self.frame.size.width,
                                                                    self.frame.size.width)];
        [self addSubview:self.frameForCapture];
        _capturedImageView = [[UIImageView alloc] initWithFrame:self.frameForCapture.frame];
        self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] init];
        self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.captureVideoPreviewLayer.bounds = self.frameForCapture.bounds;
        self.captureVideoPreviewLayer.position = CGPointMake(CGRectGetMidX(self.frameForCapture.bounds),
                                                             CGRectGetMidY(self.frameForCapture.bounds));
        [self.frameForCapture.layer addSublayer:self.captureVideoPreviewLayer];
        self.capturedImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.capturedImageView];
        _controlsView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  self.frameForCapture.frame.size.height,
                                                                  self.frame.size.width,
                                                                  self.frame.size.height - self.frameForCapture.frame.size.height)];
        [self addSubview:self.controlsView];
        self.captureButton = [[UIButton alloc] init];
        [self.captureButton addTarget:self action:@selector(captureButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.captureButton setTitle:@"capture" forState:UIControlStateNormal];
        self.captureButton.backgroundColor = [UIColor blackColor];
        [self.captureButton sizeToFit];
        self.captureButton.center = CGPointMake(self.controlsView.frame.size.width  / 2,
                                                self.controlsView.frame.size.height / 2);
        self.cancelButton = [[UIButton alloc] init];
        [self.cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
        self.cancelButton.backgroundColor = [UIColor redColor];
        [self.cancelButton sizeToFit];
        self.cancelButton.center = self.captureButton.center;
        [self.controlsView addSubview:self.cancelButton];
        [self.controlsView addSubview:self.captureButton];
    }
    return self;
}

- (void)captureButtonPressed {
    [self.escNotifier captureButtonPressed];
}

- (void)cancelButtonPressed {
    [self.escNotifier cancelButtonPressed];
}

- (void)setCaptureVideoPreviewLayerSession:(AVCaptureSession*)session {
    self.captureVideoPreviewLayer.session = session;
}

- (void)setCapturedImage:(UIImage*)image {
    self.capturedImageView.image = image;
}

- (void)nullifyCapturedImage {
    self.capturedImageView.image = NULL;
}

- (void)configureDidCaptureMode {
    [self.capturedImageView setHidden:NO];
    [self.cancelButton setHidden:NO];
    [self.frameForCapture setHidden:YES];
    [self.captureButton setHidden:YES];
}

- (void)configureWillCaptureMode {
    [self.capturedImageView setHidden:YES];
    [self.cancelButton setHidden:YES];
    [self.frameForCapture setHidden:NO];
    [self.captureButton setHidden:NO];
}

@end
