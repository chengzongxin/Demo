//
//  ViewController.m
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/1/19.
//

#import "ViewController.h"
#import "THKGraphicCollectionVC.h"
#import <dlfcn.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.groupTableViewBackgroundColor;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self push];
}


- (void)push{
    NSLog(@"111");
    THKGraphicCollectionVM *vm = [[THKGraphicCollectionVM alloc] init];
    THKGraphicCollectionVC *vc = [[THKGraphicCollectionVC alloc] initWithViewModel:vm];
    [self presentViewController:vc animated:YES completion:nil];
//    [self.navigationController pushViewController:[NSClassFromString(@"THKReferenPictureListVC") new] animated:YES];
}


void __sanitizer_cov_trace_pc_guard_init(uint32_t *start,
                                         uint32_t *stop) {
  static uint64_t N;  // Counter for the guards.
  if (start == stop || *start) return;  // Initialize only once.
//  printf("INIT: %p %p\n", start, stop);
  for (uint32_t *x = start; x < stop; x++)
    *x = ++N;  // Guards should start from 1.
}

void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {
  if (!*guard) return;
  void *PC = __builtin_return_address(0);
  char PcDescr[1024];
//  printf("guard: %p %x PC %s\n", guard, *guard, PcDescr);
    
    Dl_info info;
    dladdr(PC, &info);
    
//    printf("fname=%s \n fbase=%p \n sname=%s \n saddr=%p \n",
//           info.dli_fname,
//           info.dli_fbase,
//           info.dli_sname,
//           info.dli_saddr);
    
}


@end
