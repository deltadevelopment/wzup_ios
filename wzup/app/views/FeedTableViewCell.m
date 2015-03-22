//
//  Feed2TableViewCell.m
//  wzup
//
//  Created by Simen Lie on 26.02.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "FeedTableViewCell.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIHelper.h"
@implementation FeedTableViewCell{
    MPMoviePlayerController *player;
    UIImage *thumbnail;
    SEL videoDonePlaying;
    NSObject *view;
  
}

-(UIImage*)getThumbnail{
    return thumbnail;
}

- (void)awakeFromNib {
    // Initialization code
    [self attachUiToCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)attachUiToCell{
    NSLog(@"cropping");
    self.editStatusTextField.borderStyle = UITextBorderStyleNone;
    [self.editStatusTextField setBackgroundColor:[UIColor clearColor]];
    self.editStatusTextField.hidden = YES;
    self.tickImage.hidden = YES;
    self.tickImage.alpha = 0.0;
    self.captionTick.hidden = YES;
    self.captionTick.alpha = 0.0;
   self.uploadImageIndicatorLabel.hidden = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
   self.availabilityPicture.backgroundColor = [UIColor colorWithRed:0.18 green:0.8 blue:0.443 alpha:1];
    self.availabilityPicture.layer.cornerRadius = 7;
    self.availabilityPicture.clipsToBounds = YES;
    self.profilePicture.layer.cornerRadius = 15;
    self.profilePicture.clipsToBounds = YES;
    self.bottomBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9f];
    
    
    
    //UIImage * image = [UIImage imageNamed:@"testBilde.jpg"];
    //image = [self imageByScalingAndCroppingForSize:size img:image];
    //[self.statusImage setBackgroundColor:[UIColor colorWithPatternImage:image]];
    
}

-(void)showVideoIcon{
    self.captionTick.hidden = NO;
    self.captionTick.alpha = 0.5;
    self.captionTick.image = [UIImage imageNamed:@"play-black.png"];
}

-(void)hideVideoIcon{
    self.captionTick.hidden = YES;
    self.captionTick.alpha = 0.0;
}

-(void)getVideo:(NSData *)data{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"MyFile.mov"];
    [data writeToFile:appFile atomically:YES];
    NSURL *movieUrl = [NSURL fileURLWithPath:appFile];
    
    //NSString *dataString = [[NSString alloc] initWithData:[status getMedia] encoding:NSUTF8StringEncoding];
    NSLog(@"video: %@",@"mdia is downloaded");
    //NSURL *url = [NSURL URLWithString:dataString];
    player = [[MPMoviePlayerController alloc] initWithContentURL:movieUrl];
    [UIHelper initialize];
    player.view.frame = [UIHelper getFrame];
    //NSLog(@"video: %@",[status getMediaUrl]);
    player.movieSourceType = MPMovieSourceTypeFile;
     player.controlStyle = MPMovieControlStyleNone;
    player.backgroundView.backgroundColor = [UIColor clearColor];
    for(UIView *aSubView in player.view.subviews) {
        aSubView.backgroundColor = [UIColor clearColor];
    }
    
    
   
    
    AVAsset *asset = [AVAsset assetWithURL:movieUrl];
    
    //  Get thumbnail at the very start of the video
    CMTime thumbnailTime = [asset duration];
    thumbnailTime.value = 0;
    
    //  Get image from the video at the given time
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:thumbnailTime actualTime:NULL error:NULL];
   thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    [self.statusImage setBackgroundColor:[UIColor colorWithPatternImage:thumbnail]];
    
   
   
    
}

- (void) hidecontrol {
    [[NSNotificationCenter defaultCenter] removeObserver:self     name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:player];
    [player setControlStyle:MPMovieControlStyleFullscreen];
    
}

- (IBAction)playVideo {
    if(player != nil){
       if(!isPlaying){
           [[NSNotificationCenter defaultCenter] addObserver:self
                                                    selector:@selector(moviePlayBackDidFinish:)
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:player];
            isPlaying = YES;
            //[self.statusImage addSubview:player.view];
            [self.statusImage insertSubview:player.view belowSubview:self.bottomBar];
            [player play];
        }
    }
}

-(void)stopVideo{
    if(player != nil){
        if(isPlaying){
            isPlaying = NO;
            [player stop];
            [player.view removeFromSuperview];
        }
    }
    
}
-(void)setVideoDoneCallback:(NSObject *) callbackView withSuccess:(SEL) success{
    view = callbackView;
    videoDonePlaying = success;
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    isPlaying = NO;
    [player stop];
    [player.view removeFromSuperview];
    [view performSelector:videoDonePlaying withObject:nil];
    
}

-(UIView*)getTopBar{
    return self.topBar;
}

-(void)stopImageLoading{
    [_imageLoadingIndicator stopAnimating];
    _imageLoadingIndicator.hidden = YES;
    
}


-(void)setAvailability:(NSInteger) available{
    //NSLog(@"%i", (int)av);
    if(available == 0){
        //available
        [self.availabilityPicture setBackgroundColor:[UIColor colorWithRed:0.18 green:0.8 blue:0.443 alpha:1]];
    }
    else if(available == 1){
        //Busy
        [self.availabilityPicture setBackgroundColor:[UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1] ];
    }
    else if(available == 2){
        [self.availabilityPicture setBackgroundColor:[UIColor colorWithRed:0.741 green:0.765 blue:0.78 alpha:1]];
        //SNOOZE
    }
    
}





@end
