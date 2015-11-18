#import <Foundation/Foundation.h>
#import "PMCameraModel.h"
#import "PMSquareCameraView.h"

@interface PMSquareCameraPresenter : NSObject

+ (void)bindWithView:(PMSquareCameraView *)view model:(PMCameraModel *)model;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;

@end
