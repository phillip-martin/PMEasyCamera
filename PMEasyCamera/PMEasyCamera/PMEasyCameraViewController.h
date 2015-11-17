#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>

@interface PMEasyCameraViewController : UIViewController

- (void)capturePhoto;
- (void)cancelImagePost;
- (void)switchCameraTapped;
- (void)captureVideo;
- (void)post;
- (void)imagePicker;

@end
