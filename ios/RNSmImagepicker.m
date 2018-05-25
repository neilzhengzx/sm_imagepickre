
#import "RNSmImagepicker.h"
#import "CACameraController.h"
#import "CAMultiAlbumViewController.h"
#import "CACropImageController.h"

@implementation RNSmImagepicker

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()
      
RCT_EXPORT_METHOD(imageFromCamera:(NSDictionary *)params callback:(RCTResponseSenderBlock)callback)
{
  //imageFromCamera 实现, 需要回传结果用callback(@[XXX]), 数组参数里面就一个NSDictionary元素即可
    [self open:ImagePickerImageCamera params:params callback:callback];
}
      
RCT_EXPORT_METHOD(imageFromCameraAlbum:(NSDictionary *)params callback:(RCTResponseSenderBlock)callback)
{
  //imageFromCameraAlbum 实现, 需要回传结果用callback(@[XXX]), 数组参数里面就一个NSDictionary元素即可
    [self open:ImagePickerImageAlbum params:params callback:callback];
}

RCT_EXPORT_METHOD(videoFromCamera:(NSDictionary *)params callback:(RCTResponseSenderBlock)callback)
{
    //videoFromCamera 实现, 需要回传结果用callback(@[XXX]), 数组参数里面就一个NSDictionary元素即可
    [self open:ImagePickerVideoCamera params:params callback:callback];
}

RCT_EXPORT_METHOD(videoFromAlbum:(NSDictionary *)params callback:(RCTResponseSenderBlock)callback)
{
    //videoFromAlbum 实现, 需要回传结果用callback(@[XXX]), 数组参数里面就一个NSDictionary元素即可
    [self open:ImagePickerVideoAlbum params:params callback:callback];
}

-(void)open:(ImagePickerType)type params:(NSDictionary *)params callback:(RCTResponseSenderBlock)callback
{
    BOOL isEdit = false;
    int compressedPixel = 1280;
    double quality = 0.6;
    int videoQuality = 0;
    int durationLimit = 15;
    
    if(params[@"isEdit"]){
        isEdit = [params[@"isEdit"] boolValue];
    }
    if(params[@"compressedPixel"]){
        compressedPixel = [params[@"compressedPixel"] intValue];
    }
    if(params[@"quality"]){
        quality = [params[@"quality"] doubleValue] / 100;
    }
    if(params[@"videoQuality"]){
        videoQuality = [params[@"videoQuality"] intValue];
    }
    if(params[@"videoDurationLimit"]){
        durationLimit = [params[@"videoDurationLimit"] intValue];
    }
    
    static CACameraController *camera = nil;
    if(!camera){
        camera = [[CACameraController alloc] init];
    }
    [camera openCameraView:type allowEdit:isEdit videoQuality:videoQuality durationLimit:durationLimit compressedPixel:compressedPixel quality:quality callback:callback];
}
      
RCT_EXPORT_METHOD(multiImage:(NSDictionary *)params callback:(RCTResponseSenderBlock)callback)
{
  //multiImage 实现, 需要回传结果用callback(@[XXX]), 数组参数里面就一个NSDictionary元素即可
//    index = index > 0 ? index : 9;
    int number = 9;
    int compressedPixel = 1280;
    double quality = 0.6;
    if(params[@"number"]){
        number = [params[@"number"] intValue] > 0 ? [params[@"number"] intValue] : 9;
    }
    if(params[@"compressedPixel"]){
        compressedPixel = [params[@"compressedPixel"] intValue];
    }
    if(params[@"quality"]){
        quality = [params[@"quality"] doubleValue] / 100;
    }
    static CAMultiAlbumViewController *album = nil;
    if(!album){
        album = [[CAMultiAlbumViewController alloc] init];
    }
    
    [album pushImagePickerController:number compressedPixel:compressedPixel quality:quality callback:callback];
}

RCT_EXPORT_METHOD(cropImage:(NSDictionary *)params callback:(RCTResponseSenderBlock)callback)
{
    int compressedPixel = 1280;
    double quality = 0.6;
    NSString* url = @"";
    if(params[@"compressedPixel"]){
        compressedPixel = [params[@"compressedPixel"] intValue];
    }
    if(params[@"quality"]){
        quality = [params[@"quality"] doubleValue] / 100;
    }
    if(params[@"url"]){
        url = params[@"url"];
    }
    
    static  CACropImageController* cropImage = nil;
    if(!cropImage){
        cropImage = [[CACropImageController alloc] init];
    }
    
    [cropImage openCropImageView:url compressedPixel:compressedPixel quality:quality callback:callback];
}

RCT_EXPORT_METHOD(cleanImage:(NSDictionary *)params callback:(RCTResponseSenderBlock)callback)
{
    NSString * path = [NSTemporaryDirectory()stringByStandardizingPath];
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (error) {
        NSLog(@"%@",error);
    }else{
        NSLog(@"清理图片缓存成功");
    }
}

@end
  
