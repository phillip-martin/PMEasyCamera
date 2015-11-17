#import "PMEasyCameraViewController.h"

@interface PMEasyCameraViewController () <UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UITextViewDelegate, UIAlertViewDelegate>

@property (nonatomic) UIView *frameForCapture;
@property (nonatomic) UIImageView *capturedImageView;
@property (nonatomic) UIView *componentView;
@property (nonatomic) UIButton *captureButton;
@property (nonatomic) AVCaptureDevicePosition position;
@property (nonatomic) AVCaptureDeviceInput *videoInputSwitched;
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic) AVCaptureDevice *frontCamera;
@property (nonatomic) AVCaptureDevice *backCamera;

@end

@implementation PMEasyCameraViewController

BOOL isUsingFrontFacingCamera;

- (instancetype)init {
    self = [super init];
    if(self) {
        _frameForCapture = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    self.view.frame.size.width,
                                                                    self.view.frame.size.width)];
        _capturedImageView = [[UIImageView alloc] initWithFrame:self.frameForCapture.frame];
        self.capturedImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:self.capturedImageView];
        [self.view addSubview:self.frameForCapture];
        
        _componentView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  self.frameForCapture.frame.size.height,
                                                                  self.view.frame.size.width,
                                                                  self.view.frame.size.height - self.frameForCapture.frame.size.height)];
        _captureButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.componentView.backgroundColor = [UIColor blueColor];
        [self.captureButton setTitle:@"capture" forState:UIControlStateNormal];
        [self.captureButton sizeToFit];
        self.captureButton.backgroundColor = [UIColor blackColor];
        [self.captureButton addTarget:self action:@selector(capturePhoto) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.componentView];
        self.captureButton.center = [self.componentView convertPoint:self.componentView.center
                                                            fromView:self.componentView.superview];
        [self.componentView addSubview:self.captureButton];
    }
    return self;
}


- (void)loadView {
    [super loadView];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupAVCapture];
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetHigh;
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    captureVideoPreviewLayer.bounds = self.frameForCapture.bounds;
    captureVideoPreviewLayer.position = CGPointMake(CGRectGetMidX(self.frameForCapture.bounds),
                                                    CGRectGetMidY(self.frameForCapture.bounds));
    [self.frameForCapture.layer addSublayer:captureVideoPreviewLayer];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        // Handle the error appropriately.
        NSLog(@"ERROR: trying to open camera: %@", error);
    } else {
        [session addInput:input];
    }
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    [session addOutput:self.stillImageOutput];
    [session startRunning];
}


- (void)setupAVCapture {
    NSError *error = nil;
    AVCaptureSession *session = [AVCaptureSession new];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        [session setSessionPreset:AVCaptureSessionPresetPhoto];
    else
        [session setSessionPreset:AVCaptureSessionPresetPhoto];
    // Select a video device, make an input
    AVCaptureDevice *device = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    isUsingFrontFacingCamera = NO;
    if ([session canAddInput:deviceInput])
        [session addInput:deviceInput];
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

- (void)capturePhoto{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
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
        UIImage *newImage = [self squareCroppedImageWithImage:image];

        self.capturedImageView.image = newImage;
        [self.view bringSubviewToFront:self.capturedImageView];
     }];
}


- (void)switchCameraTapped {
    [self.session beginConfiguration];
    //  Remove current input
    AVCaptureInput *currentCameraInput = [self.session.inputs objectAtIndex:0];
    [self.session removeInput:currentCameraInput];
    [self.session commitConfiguration];
    [self.session startRunning];
    
}

- (void)captureVideo:(id)sender {
}

- (void)post:(id)sender {
}

- (void)imagePicker:(id)sender {
}


- (void)cancelImagePost:(id)sender {
    self.capturedImageView.image = nil;
    _frameForCapture.hidden = NO;
}

#pragma mark ImagePicker

//Setup ImagePickerController Methods

- (void)__choosePhotoFromLibrary
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        picker.delegate = self;
        
        [self presentViewController:picker
                           animated:YES
                         completion:nil];
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES
                               completion:nil];
    
    //    UIImage *img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //    [self.imgPost setImage:img];
}





@end
