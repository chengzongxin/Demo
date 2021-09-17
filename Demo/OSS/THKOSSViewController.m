//
//  THKOSSViewController.m
//  Demo
//
//  Created by Joe.cheng on 2021/9/17.
//

#import "THKOSSViewController.h"
#import "THKOSSTool.h"

@interface THKOSSViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation THKOSSViewController


- (void)uploadImage:(UIImage *)image{
    [THKOSSTool uploadImage:@[image,image] type:THKOSSModuleType_Personal success:^(NSArray<NSString *> *urls) {
        NSLog(@"%@",urls);
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}



#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    chooseButton.backgroundColor = UIColor.tmui_randomColor;
    [chooseButton setFrame:CGRectMake(100, 100, 200, 200)];
    [self.view addSubview:chooseButton];
    chooseButton.tag = 1004;
    chooseButton.center = self.view.center;//让button位于屏幕中央
//    [chooseButton setImage:[[UIImage imageNamed:@"123.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState:UIControlStateNormal];
        
    [chooseButton addTarget:self action:@selector(selectImage) forControlEvents:UIControlEventTouchDown];
}

- (void)selectImage{

    //调用系统相册的类
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];

    
    //设置选取的照片是否可编辑
    pickerController.allowsEditing = YES;
    //设置相册呈现的样式
    pickerController.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;//图片分组列表样式
    //照片的选取样式还有以下两种
    //UIImagePickerControllerSourceTypePhotoLibrary,直接全部呈现系统相册
    //UIImagePickerControllerSourceTypeCamera//调取摄像头
    
    //选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
    pickerController.delegate = self;
    //使用模态呈现相册
    [self.navigationController presentViewController:pickerController animated:YES completion:^{
  
    }];
 
}

//选择照片完成之后的代理方法

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //info是所选择照片的信息
    
//    UIImagePickerControllerEditedImage//编辑过的图片
//    UIImagePickerControllerOriginalImage//原图
    
    
    NSLog(@"%@",info);
    //刚才已经看了info中的键值对，可以从info中取出一个UIImage对象，将取出的对象赋给按钮的image
    
    UIButton *button = (UIButton *)[self.view viewWithTag:1004];
    
    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [button setImage:[resultImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];//如果按钮创建时用的是系统风格UIButtonTypeSystem，需要在设置图片一栏设置渲染模式为"使用原图"
    
    
    //裁成边角
    button.layer.cornerRadius = 100;
    button.layer.masksToBounds = YES;
    
    //使用模态返回到软件界面
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    [self uploadImage:resultImage];
 
}

//点击取消按钮所执行的方法

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    
   //这是捕获点击右上角cancel按钮所触发的事件，如果我们需要在点击cancel按钮的时候做一些其他逻辑操作。就需要实现该代理方法，如果不做任何逻辑操作，就可以不实现
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}




@end
