#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <UIKit/UIKit.h>
#import "ESCObservable.h"

typedef NS_ENUM(NSInteger, PMCameraState) {
    PMCameraStateWillCapture,
    PMCameraStateIsCapturing,
    PMCameraStateDidCapture,
};

@protocol PMCameraModelObserver <NSObject>

- (void)cameraStateChanged;

@end

@interface PMCameraModel : NSObject <ESCObservable>

@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureDevice *device;
@property (nonatomic) AVCaptureDeviceInput *input;
@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic) AVCaptureDevice *frontCamera;
@property (nonatomic) AVCaptureDevice *backCamera;
@property (nonatomic) UIImage *capturedImage;
@property PMCameraState cameraState;

- (void)cancelCapturedImage;

- (void)captureCurrentImage;

@end
