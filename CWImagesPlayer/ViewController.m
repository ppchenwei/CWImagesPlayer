//
//  ViewController.m
//  CWImagesPlayer
//
//  Created by 陈威 on 16/4/22.
//  Copyright © 2016年 陈威. All rights reserved.
//

#import "ViewController.h"
#import "CWImagesPlayer/CWImagesPlayer.h"

#define ImageUrl1     @"http://imgsrc.baidu.com/forum/w%3D580/sign=1beed5c6367adab43dd01b4bbbd6b36b/5eeb8a13632762d014f4c251a0ec08fa503dc61a.jpg"
#define ImageUrl2     @"http://imgsrc.baidu.com/baike/pic/item/718e25c757f21cf3d0006024.jpg"
#define ImageUrl3     @"http://img.sj33.cn/uploads/allimg/201302/1-130201105109.jpg"
#define ImageUrl4     @"http://img3.imgtn.bdimg.com/it/u=45736517,3590571136&fm=206&gp=0.jpg"
#define ImageUrl5     @"http://pic1.hebei.com.cn/0/10/93/06/10930644_988860.jpg"
#define ImageUrl6     @"http://m3.img.papaapp.com/farm4/d/2013/0816/14/F2BD36D8E93422FF0D68123C8026F08A_B1280_1280_1021_681.JPEG"

@interface ViewController ()<CWImagesPlayerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lable;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Test
    CWImagesPlayer *imagesPlayer = [[CWImagesPlayer alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , 200)];
    
    CWImageObject *image1 = [[CWImageObject alloc] initWithImageType:CWImageObjectTypeUrl image:nil imageUrl:ImageUrl1 placeholderImage:[UIImage imageNamed:@"placeholder"]];
    CWImageObject *image2 = [[CWImageObject alloc] initWithImageType:CWImageObjectTypeUrl image:nil imageUrl:ImageUrl2 placeholderImage:[UIImage imageNamed:@"placeholder"]];
    CWImageObject *image3 = [[CWImageObject alloc] initWithImageType:CWImageObjectTypeUrl image:nil imageUrl:ImageUrl3 placeholderImage:[UIImage imageNamed:@"placeholder"]];
    CWImageObject *image4 = [[CWImageObject alloc] initWithImageType:CWImageObjectTypeUrl image:nil imageUrl:ImageUrl4 placeholderImage:[UIImage imageNamed:@"placeholder"]];
    CWImageObject *image5 = [[CWImageObject alloc] initWithImageType:CWImageObjectTypeUrl image:nil imageUrl:ImageUrl5 placeholderImage:[UIImage imageNamed:@"placeholder"]];
    CWImageObject *image6 = [[CWImageObject alloc] initWithImageType:CWImageObjectTypeUrl image:nil imageUrl:ImageUrl6 placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    imagesPlayer.images = @[image1, image2, image3, image4, image5, image6];
    
    imagesPlayer.delegate = self;
    imagesPlayer.timeInterval = 3.5;
    [self.view addSubview:imagesPlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSelectImageViewAtIndex:(NSInteger)index
{
    self.lable.text = [NSString stringWithFormat:@"点击了第%d张图片", (int)index + 1];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.lable.text = @"";
    });
}

@end
