//
//  AJKMainViewController.m
//  curveLineDemo
//
//  Created by shan xu on 14-4-9.
//  Copyright (c) 2014年 夏至. All rights reserved.
//

#import "AJKMainViewController.h"

@interface AJKMainViewController (){
    UIImageView *iconImgView;
}

@end

@implementation AJKMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    iconImgView = [[UIImageView alloc] init];
    iconImgView.frame = CGRectMake(20, 40, 35, 35);
    iconImgView.image = [UIImage imageNamed:@"icon"];
    iconImgView.userInteractionEnabled = YES;
    [self.view addSubview:iconImgView];

    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(iconGes:)];
    panGes.delegate = self;
    panGes.delaysTouchesBegan = YES;
    panGes.cancelsTouchesInView = NO;
    [iconImgView addGestureRecognizer:panGes];
}

- (void)iconGes:(UIPanGestureRecognizer *)panGes{
//    CGPoint translation = [panGes translationInView:self.view];//x、y移动值
//    CGPoint velocity = [panGes velocityInView:self.view];//x、y移动速度
    CGPoint pointer = [panGes locationInView:self.view];//x、y当前值
    
    if (panGes.state == UIGestureRecognizerStateBegan) {
    }else if (panGes.state == UIGestureRecognizerStateChanged){
        iconImgView.center = pointer;
    }else if (panGes.state == UIGestureRecognizerStateEnded){
        [self curveToPoint:pointer];
    }else if (panGes.state == UIGestureRecognizerStateCancelled){
        [self curveToPoint:pointer];
    }
}

- (void)curveToPoint:(CGPoint)startPoint{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon"]];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.frame = CGRectMake(0, 0, 35, 35);
    imageView.center = startPoint;

    CALayer *layer = [[CALayer alloc]init];
    layer.contents = imageView.layer.contents;
    layer.frame = imageView.frame;
    layer.opacity = 1;
    [self.view.layer addSublayer:layer];
    
    CGPoint endPoint = CGPointMake(290, self.view.bounds.size.height - 50);

    UIBezierPath *path = [UIBezierPath bezierPath];
    //动画起点
    [path moveToPoint:startPoint];
    //贝塞尔曲线中间点
    float sx = startPoint.x;
    float sy = startPoint.y;
    float ex = endPoint.x;
    float ey = endPoint.y;
    float x = sx+(ex-sx)/3;
    float y = sy+(ey-sy)*0.5-400;
    CGPoint centerPoint = CGPointMake(x,y);
    [path addQuadCurveToPoint:endPoint controlPoint:centerPoint];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = 0.8;
    animation.delegate = self;
    animation.autoreverses = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [layer addAnimation:animation forKey:@"move"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    id aName = [anim valueForKey:@"move"];
    NSLog(@"%@",aName);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
