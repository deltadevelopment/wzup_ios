//
//  MediaHelper.h
//  wzup
//
//  Created by Simen Lie on 18/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#define CAPTURE_FRAMES_PER_SECOND		20
@interface MediaHelper : NSObject{
    AVCaptureStillImageOutput * stillImageOutput;
    AVCaptureVideoDataOutput * videoImageOutput;
    UIImage *imgTaken;
    AVCaptureSession *session;
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    bool frontFacing;
    
    //Video
    AVCaptureSession *CaptureSession;
    AVCaptureMovieFileOutput *MovieFileOutput;
    AVCaptureDeviceInput *VideoInputDevice;
    
}
@property (retain) AVCaptureVideoPreviewLayer *PreviewLayer;
- (void)StartStopRecording;
-(void)initaliseVideo;
- (void)CameraToggleButtonPressed:(bool)isFrontCamera;
-(void)setView:(UIView *) videoView;
@end