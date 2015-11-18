#import "PMCameraModel.h"

@interface PMCameraModel() <ESCObservableInternal>

@end

@implementation PMCameraModel

- (instancetype)init {
    self = [super init];
    if(self) {
        [self escRegisterObserverProtocol:@protocol(PMCameraModelObserver)];
        self.session = [[AVCaptureSession alloc] init];
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
        if (!self.input) {
            NSLog(@"ERROR: trying to open camera: %@", error);
        } else {
            [self.session addInput:self.input];
        }
        self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
        [self.stillImageOutput setOutputSettings:outputSettings];
        [self.session addOutput:self.stillImageOutput];
        [self.session startRunning];
        self.cameraState = PMCameraStateWillCapture;
    }
    return self;
}

- (void)cancelCapturedImage {
    self.capturedImage = NULL;
    self.cameraState = PMCameraStateWillCapture;
    [self.escNotifier cameraStateChanged];
}

- (void)captureCurrentImage {
    if(self.cameraState == PMCameraStateWillCapture) {
        self.cameraState = PMCameraStateIsCapturing;
        [self.escNotifier cameraStateChanged];
        AVCaptureConnection *videoConnection = nil;
        for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
            for (AVCaptureInputPort *port in [connection inputPorts]) {
                if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                    videoConnection = connection;
                    break;
                }
            }
            if (videoConnection) { break; }
        }
        [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
            CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
            if (exifAttachments) {
                // Do something with the attachments.
                NSLog(@"attachements: %@", exifAttachments);
            }
            else
                NSLog(@"no attachments");
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            self.capturedImage = [self squareCroppedImageWithImage:image];
            self.cameraState = PMCameraStateDidCapture;
            [self.escNotifier cameraStateChanged];
        }];
    }
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
