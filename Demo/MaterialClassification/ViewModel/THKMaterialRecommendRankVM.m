//
//  THKMaterialRecommendRankVM.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/21.
//

#import "THKMaterialRecommendRankVM.h"

@interface THKMaterialRecommendRankVM ()


@property (nonatomic, strong) NSArray <NSArray *> *headerTitles;
@property (nonatomic, strong) NSArray <NSArray *> *icons;
@property (nonatomic, strong) NSArray <NSArray *> *titles;
@property (nonatomic, strong) NSArray <NSArray *> *subtitles;

@property (nonatomic, strong) THKRequestCommand *requestCommand;

@property (nonatomic, strong, nullable) NSArray <THKMaterialHotListModel *> *data;

@end

@implementation THKMaterialRecommendRankVM
@dynamic requestCommand;
@dynamic data;


- (void)initialize{
    [super initialize];
    
    _headerTitles = @[@[@"冰箱品牌榜(๑•̀ㅂ•́)و✧",@""],
                      @[@"冰箱推荐榜哈哈哈😆",@"经典三门 无霜风冷",],
                      @[@"冰箱推荐榜哈哈哈😆",@"经典四门 无霜风冷",],
                      @[@"冰箱推荐榜哈哈哈😆",@"经典五门 无霜风冷",],
                      @[@"冰箱推荐榜哈哈哈😆",@"经典六门 无霜风冷",],];
    
    _icons = @[@[@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F202007%2F11%2F20200711184432_ic25F.jpeg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626937380&t=9e96d0bcb69f82406f6ccb5db06e773d",@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201712%2F15%2F20171215221023_KiYWM.thumb.700_0.jpeg&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626937380&t=e9c342d03d8478f6b41c7f0a5552f084",@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201508%2F15%2F20150815131712_fEyPM.jpeg&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626937380&t=c6dd2f0386494ff4bafbc536c27d416f"],
                @[@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=623994087,1173615898&fm=26&gp=0.jpg",@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic1.zhimg.com%2F50%2Fv2-71dcef82c8afb85dacd42a995f64f1b5_hd.jpg&refer=http%3A%2F%2Fpic1.zhimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626937380&t=a1d0e311f83398e60371a466209abba1",@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fcdn.duitang.com%2Fuploads%2Fitem%2F201408%2F24%2F20140824154253_45Hay.png&refer=http%3A%2F%2Fcdn.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626937380&t=c5ffa3ef3d76b4787a6352db62015895"],
                @[@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic4.zhimg.com%2F50%2Fv2-5a63ee9cbe62d53ee36e1c99caa095d9_hd.jpg&refer=http%3A%2F%2Fpic4.zhimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626937380&t=c6f75eea1d9260386bb2f20d706c0e15",@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic3.zhimg.com%2F50%2Fv2-728648096894b4aa9eda8d33cdcf5f28_hd.jpg&refer=http%3A%2F%2Fpic3.zhimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626937380&t=660cb729a2ee254eda8c398ffc9543e7",@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fdp.gtimg.cn%2Fdiscuzpic%2F0%2Fdiscuz_x5_gamebbs_qq_com_forum_201306_19_1256219xc797y90heepdbh.jpg%2F0&refer=http%3A%2F%2Fdp.gtimg.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626937380&t=98b856b6650e34ad1aa1004b8b90cffb"],
                @[@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201901%2F04%2F20190104222555_Rvvyu.thumb.700_0.jpeg&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626937380&t=c92a94778530e4b4542f548d626990c6",@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1441836571,2166773131&fm=26&gp=0.jpg",@"https://pics4.baidu.com/feed/d000baa1cd11728bd4d98501effc13c8c3fd2c27.jpeg?token=73c8c9c6a7f8bee46641914a57098d98"],
                @[@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F202007%2F03%2F20200703140553_8Fk3Y.jpeg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626937380&t=153e10bd08e45dfebe0a1a220cb84aa1",@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fs10.sinaimg.cn%2Fbmiddle%2F005Hq1RPgy6LxuSIxIt49%26690&refer=http%3A%2F%2Fs10.sinaimg.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626937380&t=dc41901894f299e45b0aa88d91ba7bc3",@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201811%2F18%2F20181118142953_yaktg.thumb.700_0.jpeg&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626937380&t=b50a0b5d471cfdbbeb946070c125906e"],];
    
    _titles = @[@[@"西门子",@"东门子",@"北门子"],
                @[@"松下/经典三门 NREC26W",@"松下/经典四门 NREC26W",@"松下/经典五门 NREC26W"],
                @[@"松下/经典三门 NREC26W",@"松下/经典四门 NREC26W",@"松下/经典五门 NREC26W"],
                @[@"松下/经典三门 NREC26W",@"松下/经典四门 NREC26W",@"松下/经典五门 NREC26W"],
                @[@"松下/经典三门 NREC26W",@"松下/经典四门 NREC26W",@"松下/经典五门 NREC26W"],];
    
    _subtitles = @[@[@"97",@"98",@"99"],
                   @[@"松下压缩机1风冷无霜",@"松下压缩机2风冷无霜",@"松下压缩机3风冷无霜"],
                   @[@"松下压缩机1风冷无霜",@"松下压缩机2风冷无霜",@"松下压缩机3风冷无霜"],
                   @[@"松下压缩机1风冷无霜",@"松下压缩机2风冷无霜",@"松下压缩机3风冷无霜"],
                   @[@"松下压缩机1风冷无霜",@"松下压缩机2风冷无霜",@"松下压缩机3风冷无霜"],];
}

- (THKBaseRequest *)requestWithInput:(id)input{
    return [[THKMaterialHotListRequest alloc] init];
}

@end
