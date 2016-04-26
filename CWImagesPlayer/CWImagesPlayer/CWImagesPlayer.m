//
//  CWImagesPlayer.m
//  Test
//
//  Created by 陈威 on 16/4/11.
//  Copyright © 2016年 陈威. All rights reserved.
//

#import "CWImagesPlayer.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (CWImageObject)

- (void)setCWImage:(CWImageObject *)image
{
    if ([image isKindOfClass:[CWImageObject class]])
    {
        if (image.type == CWImageObjectTypeImage)
        {
            [self setImage:image.image];
        }
        else if (image.type == CWImageObjectTypeUrl)
        {
            [self sd_setImageWithURL:[NSURL URLWithString:image.imageUrl] placeholderImage:image.placeholderImage];
        }
    }
}

@end

@implementation CWImageObject

- (instancetype)initWithImageType:(CWImageObjectType)type  image:(UIImage *)image  imageUrl:(NSString *)imageUrl placeholderImage:(UIImage *)placeholderImage
{
    self = [super init];
    if (self)
    {
        self.type = type;
        self.image = image;
        self.imageUrl = imageUrl;
        self.placeholderImage = placeholderImage;
    }
    
    return  self;
}

@end


@interface CWImagesPlayer ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIPageControl *pageControl;

@property (strong, nonatomic) UIImageView *otherImageView;

@property (strong, nonatomic) UIImageView *mainImageView;

@property (assign, nonatomic, readwrite) NSInteger currentIndex;

@property (strong, nonatomic) NSTimer * timer;

@end

@implementation CWImagesPlayer

#pragma mark -----------------视图生命周期管理-----------------
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = frame;
        _currentIndex = 0;
    }
    return  self;
}

- (instancetype)initWithImages:(NSArray *)images
{
    self = [super init];
    if (self)
    {
        self.images = images;
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview)
    {
        [self startTimer];
    }
    else
    {
        [self stopTimer];
    }
}

- (void)dealloc
{
    NSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}
#pragma mark -----------------控件事件处理函数-----------------
- (void)pageControlValueDidChaned:(id)sender
{
    //Todo
}

#pragma mark -----------------UIScrollViewDelegate-----------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    
    //处理改变左右显示图片
    [self changeImageViewPositionWithOffset:offset.x];
    //处理改变图片的改变
    [self changeImagesWithOffset:offset.x];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

#pragma mark -----------------私有函数-----------------
- (void)initSubViews
{
    if (self.frame.size.width > 0 && self.frame.size.height > 0)
    {
        if (!self.scrollView.superview) [self addSubview:self.scrollView];
        
        if (_images.count > 0)
        {
            if(_images.count == 1) self.scrollView.scrollEnabled = NO;
            else self.scrollView.scrollEnabled = YES;
            
            [self.mainImageView setCWImage:_images[0]];
            [self.otherImageView setCWImage:_images[_images.count - 1]];
            
            if (!self.pageControl.superview) [self addSubview:self.pageControl];
            [self startTimer];
        }
    }
}

- (void)changeImageViewPositionWithOffset:(CGFloat)offsetx
{
    if (offsetx > self.frame.size.width && self.otherImageView.frame.origin.x == 0)
    {
        //开始向右滑动
        CGPoint center =  self.otherImageView.center;
        center.x += (self.frame.size.width * 2);
        self.otherImageView.center = center;
        
        [self.otherImageView setCWImage:self.images[(_currentIndex + 1) % self.images.count]];
    }
    else if (offsetx < self.frame.size.width && self.otherImageView.frame.origin.x == (self.frame.size.width * 2))
    {
        //开始向左滑动
        CGPoint center =  self.otherImageView.center;
        center.x -= (self.frame.size.width * 2);
        self.otherImageView.center = center;
        
        [self.otherImageView setCWImage:self.images[(_currentIndex + self.images.count - 1) % self.images.count]];
    }
}

- (void)changeImagesWithOffset:(CGFloat)offsetx
{
    BOOL bHoming = YES;
    if (offsetx <= 0)
    {
        //向左滑动一张图片
        _currentIndex = (_currentIndex + self.images.count - 1) % self.images.count;
    }
    else if (offsetx >= self.frame.size.width * 2 )
    {
        //向右滑动一张图片
        _currentIndex = (_currentIndex + 1) % self.images.count;
    }
    else
    {
        bHoming = NO;
    }
    
    if (bHoming)
    {
        [self.mainImageView setCWImage:self.images[_currentIndex]];
        [self.scrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
        if (self.otherImageView.frame.origin.x == (self.frame.size.width * 2))  [self.otherImageView setCWImage:self.images[(_currentIndex + 1) % self.images.count]];
        else [self.otherImageView setCWImage:self.images[(_currentIndex + self.images.count - 1) % self.images.count]];
    }
    self.pageControl.currentPage = _currentIndex;
}

- (void)ontimer:(NSTimer *)timer
{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + self.frame.size.width, 0) animated:YES];
}

- (void)startTimer
{
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval > 0 ? self.timeInterval : 2 target:self selector:@selector(ontimer:) userInfo:nil repeats:YES];
}

- (void)stopTimer
{
    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)imageViewTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    if ([_delegate respondsToSelector:@selector(didSelectImageViewAtIndex:)])
    {
        [_delegate didSelectImageViewAtIndex:_currentIndex];
    }
}

#pragma mark -----------------SET GET方法-----------------
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self initSubViews];
}

- (void)setImages:(NSArray *)images
{
    _images = images;
    [self initSubViews];
}


- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [_scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
        
        [_scrollView addSubview:self.mainImageView];
        
        _scrollView.delegate = self;
    }
    
    return _scrollView;
}

- (UIImageView *)mainImageView
{
    if (!_mainImageView)
    {
        _mainImageView= [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        _mainImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapGestureRecognizer:)];
        [_mainImageView addGestureRecognizer:tapGR];
    }
    
    return _mainImageView;
}

- (UIImageView *)otherImageView
{
    if (!_otherImageView)
    {
        _otherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_scrollView addSubview:_otherImageView];
    }
    
    return _otherImageView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl)
    {
        _pageControl = [[UIPageControl alloc] init];
        CGSize pageSize = [_pageControl sizeForNumberOfPages:_images.count];
        _pageControl.frame = CGRectMake(self.frame.size.width - pageSize.width - 10, self.frame.size.height - pageSize.height + 10, pageSize.width, pageSize.height);
        _pageControl.hidesForSinglePage = YES;
        [_pageControl addTarget:self action:@selector(pageControlValueDidChaned:) forControlEvents:UIControlEventValueChanged];
        self.pageControl.numberOfPages = _images.count;
    }
    
    return _pageControl;
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    _pageIndicatorTintColor = pageIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = _pageIndicatorTintColor;
}
@end
