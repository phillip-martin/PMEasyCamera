#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <ESCObservable/ESCObservable.h>

@protocol PMSquareCameraViewObserver <NSObject>

- (void)captureButtonPressed;

- (void)cancelButtonPressed;

@end

@interface PMSquareCameraView : UIView <ESCObservable>

- (void)setCaptureVideoPreviewLayerSession:(AVCaptureSession*)session;

- (void)setCapturedImage:(UIImage*)image;

- (void)nullifyCapturedImage;

- (void)configureDidCaptureMode;

- (void)configureWillCaptureMode;

@end
