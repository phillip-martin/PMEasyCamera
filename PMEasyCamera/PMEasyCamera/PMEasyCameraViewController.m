#import "PMEasyCameraViewController.h"
#import "PMSquareCameraView.h"
#import "PMCameraModel.h"

@interface PMEasyCameraViewController () <UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UITextViewDelegate, UIAlertViewDelegate>

@property (nonatomic) PMSquareCameraView *squareCameraView;
@property (nonatomic) PMCameraModel *cameraModel;

@end

@implementation PMEasyCameraViewController

BOOL isUsingFrontFacingCamera;

- (instancetype)init {
    self = [super init];
    if(self) {
        self.squareCameraView = [[PMSquareCameraView alloc] initWithFrame:self.view.frame];
        self.view = self.squareCameraView;
        self.cameraModel = [[PMCameraModel alloc] init];
        [self.squareCameraView setCaptureVideoPreviewLayerSession:self.cameraModel.session];
    }
    return self;
}


- (void)loadView {
    [super loadView];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (UIImage *)squareCroppedImageWithImage:(UIImage*)image {
    double refWidth = CGImageGetWidth(image.CGImage);
    double refHeight = CGImageGetHeight(image.CGImage);
    double x = (refWidth - image.size.width) / 2.0;
    double y = (refHeight - image.size.width) / 2.0;
    CGRect rect = CGRectMake(x, y, image.size.width, image.size.width);
    if (image.scale > 1.0f) {
        rect = CGRectMake(rect.origin.x * image.scale,
                          rect.origin.y * image.scale,
                          rect.size.width * image.scale,
                          rect.size.height * image.scale);
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

@end
