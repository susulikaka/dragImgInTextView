//
//  ViewController.m
//  testForDrag
//
//  Created by SupingLi on 16/8/30.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "ViewController.h"
#import "TextCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UITextViewDelegate>

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UILongPressGestureRecognizer *gesture;
@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSIndexPath *curLocation;
@property (assign, nonatomic) CGPoint oldLocation;
@property (strong, nonatomic) UIView * mappingCell;
@property (strong, nonatomic) NSString *str;
@property (assign, nonatomic) NSInteger curseLocation;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) NSTextAttachment *curAttachment;
@property (assign, nonatomic) NSInteger curAttachIndex;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (assign, nonatomic) CGPoint curContentOffSet;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initInterface];
}

- (void)initInterface {
    self.str = @"豫章故郡，洪都新府。星分翼轸，地接衡庐。襟三江而带五湖，控蛮荆而引瓯越。物华天宝，龙光射牛斗之墟；人杰地灵，徐孺下陈蕃之榻。雄州雾列，俊采星驰。台隍枕夷夏之交，宾主尽东南之美。都督阎公之雅望，棨戟遥临；宇文新州之懿范，襜帷暂驻。十旬休假，胜友如云；千里逢迎，高朋满座。腾蛟起凤，孟学士之词宗；紫电青霜，王将军之武库。家君作宰，路出名区；童子何知，躬逢胜饯。(豫章故郡 一作：南昌故郡)\n时维九月，序属三秋。潦水尽而寒潭清，烟光凝而暮山紫。俨骖騑于上路，访风景于崇阿。临帝子之长洲，得仙人之旧馆。层峦耸翠，上出重霄；飞阁流丹，下临无地。鹤汀凫渚，穷岛屿之萦回；桂殿兰宫，即冈峦之体势。（层峦  一作：层台；即冈 一作：列冈；天人 一作：仙人）\n披绣闼，俯雕甍，山原旷其盈视，川泽纡其骇瞩。闾阎扑地，钟鸣鼎食之家；舸舰迷津，青雀黄龙之舳。云销雨霁，彩彻区明。落霞与孤鹜齐飞，秋水共长天一色。渔舟唱晚，响穷彭蠡之滨，雁阵惊寒，声断衡阳之浦。(轴 通：舳；迷津 一作：弥津；云销雨霁，彩彻区明 一作：虹销雨霁，彩彻云衢)\n遥襟甫畅，逸兴遄飞。爽籁发而清风生，纤歌凝而白云遏。睢园绿竹，气凌彭泽之樽；邺水朱华，光照临川之笔。四美具，二难并。穷睇眄于中天，极娱游于暇日。天高地迥，觉宇宙之无穷；兴尽悲来，识盈虚之有数。望长安于日下，目吴会于云间。地势极而南溟深，天柱高而北辰远。关山难越，谁悲失路之人；萍水相逢，尽是他乡之客。怀帝阍而不见，奉宣室以何年？(遥襟甫畅 一作：遥吟俯畅)\n嗟乎！时运不齐，命途多舛。冯唐易老，李广难封。屈贾谊于长沙，非无圣主；窜梁鸿于海曲，岂乏明时？所赖君子见机，达人知命。老当益壮，宁移白首之心？穷且益坚，不坠青云之志。酌贪泉而觉爽，处涸辙以犹欢。北海虽赊，扶摇可接；东隅已逝，桑榆非晚。孟尝高洁，空余报国之情；阮籍猖狂，岂效穷途之哭！(见机 一作：安贫)\n勃，三尺微命，一介书生。无路请缨，等终军之弱冠；有怀投笔，慕宗悫之长风。舍簪笏于百龄，奉晨昏于万里。非谢家之宝树，接孟氏之芳邻。他日趋庭，叨陪鲤对；今兹捧袂，喜托龙门。杨意不逢，抚凌云而自惜；钟期既遇，奏流水以何惭？\n呜乎！胜地不常，盛筵难再；兰亭已矣，梓泽丘墟。临别赠言，幸承恩于伟饯；登高作赋，是所望于群公。敢竭鄙怀，恭疏短引；一言均赋，四韵俱成。请洒潘江，各倾陆海云尔：\n滕王高阁临江渚，佩玉鸣鸾罢歌舞。\n画栋朝飞南浦云，珠帘暮卷西山雨。\n闲云潭影日悠悠，物换星移几度\n阁中帝子今何在？槛外长江空自流。\n";

        NSTextAttachment *attachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
        UIImage *img = [UIImage imageNamed:@"1"];
        attachment.image = img;
        NSAttributedString *attStr = [NSAttributedString attributedStringWithAttachment:attachment];
        
    
        self.dataSource = [[self.str componentsSeparatedByString:@"\n"] mutableCopy];
        [self.collectionView reloadData];
        NSMutableAttributedString *totalAttStr = [[NSMutableAttributedString alloc] initWithString:self.str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        [totalAttStr insertAttributedString:attStr atIndex:0];
        self.textView.attributedText = totalAttStr;
        self.dataSource = [[self.str componentsSeparatedByString:@"\n"] mutableCopy];
        [self.dataSource insertObject:@"图片" atIndex:0];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.textView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TextCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([TextCollectionViewCell class])];
    [self.textView addGestureRecognizer:self.gesture];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.curseLocation = self.textView.selectedRange.location;
}

#pragma mark - action

- (IBAction)addAction:(id)sender {
    self.curContentOffSet = self.textView.contentOffset;
    NSTextAttachment *attachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    UIImage *img = [UIImage imageNamed:@"1"];
    attachment.image = img;
    NSAttributedString *attStr = [NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString *allStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    self.curseLocation = self.textView.selectedRange.location;
    
    [allStr insertAttributedString:attStr atIndex:self.curseLocation];
    self.textView.attributedText = allStr;
    self.textView.selectedRange = NSMakeRange(self.curseLocation+1, 0);
    [self.textView setContentOffset:self.curContentOffSet animated:YES];
    [self.dataSource addObject:@"图片"];
    [self.collectionView reloadData];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.layout.itemSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame), 40);
        NSTextContainer *textContainer = self.textView.textContainer;
        NSLayoutManager *layoutManager = self.textView.layoutManager;
        CGPoint point = [gesture locationInView:self.textView];
        point.x -= self.textView.textContainerInset.left;
        point.y -= self.textView.textContainerInset.top;
        NSRange rangeP;
        
        NSInteger chIndex = [layoutManager characterIndexForPoint:point inTextContainer:textContainer fractionOfDistanceBetweenInsertionPoints:nil];
        if (chIndex >= self.textView.text.length) {
            return;
        } else {
            id attributeName = [self.textView.attributedText attribute:NSAttachmentAttributeName atIndex:chIndex effectiveRange:&rangeP];
            if (!attributeName) {
                return;
            } else {
                if ([attributeName isKindOfClass:[NSTextAttachment class]]) {
                    self.curAttachment = (NSTextAttachment *)attributeName;
                    UIImage *img = self.curAttachment.image;
                    self.curAttachIndex = [self.dataSource indexOfObject:@"图片"];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.curAttachIndex inSection:0];
                    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
#pragma marn - new
                    [self.textView setHidden:YES];
                    self.oldLocation = [gesture locationInView:self.collectionView];
                    self.curLocation = indexPath;
                    UICollectionViewCell * targetCell = [self.collectionView cellForItemAtIndexPath:indexPath];
                    UIView * cellView = [targetCell snapshotViewAfterScreenUpdates:YES];
                    self.mappingCell = cellView;
                    self.mappingCell.frame = cellView.frame;
                    
                    CGPoint center = cellView.center;
                    self.mappingCell.center = CGPointMake(CGRectGetWidth(self.view.frame), center.y);
                    [targetCell setHidden:YES];
                    NSLog(@"--------cellView:%lf,self.mappingCell:%lf",cellView.frame.origin.x,self.mappingCell.frame.origin.x);
                    [self.collectionView addSubview:self.mappingCell];
                    
                }
            }
        }

//        CGPoint location = [gesture locationInView:self.collectionView];
//        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
//        if (!indexPath || indexPath.row == 0) {
//            return;
//        }
//        [self.textView setHidden:YES];
//        self.oldLocation = location;
//        self.curLocation = indexPath;
//        UICollectionViewCell * targetCell = [self.collectionView cellForItemAtIndexPath:indexPath];
//        UIView * cellView = [targetCell snapshotViewAfterScreenUpdates:YES];
//        self.mappingCell = cellView;
//        self.mappingCell.frame = cellView.frame;
//        
//        [targetCell setHidden:YES];
//        [self.collectionView addSubview:self.mappingCell];
//        cellView.center = targetCell.center;
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint point = [gesture locationInView:self.collectionView];
        self.mappingCell.center = point;
        NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:point];
        if (![indexPath isEqual:self.curLocation] && indexPath.row != 0) {
            [self.collectionView moveItemAtIndexPath:self.curLocation toIndexPath:indexPath];
            self.curLocation = indexPath;
        }
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.curLocation];
        if (!cell) {
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:self.oldLocation];
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
            cell = [self.collectionView cellForItemAtIndexPath:newIndexPath];
            if (cell) {
                [self.collectionView moveItemAtIndexPath:self.curLocation toIndexPath:newIndexPath];
                id obj = self.dataSource[self.curAttachIndex];
                [self.dataSource removeObjectAtIndex:self.curAttachIndex];
                [self.dataSource insertObject:obj atIndex:newIndexPath.row];
            }
            
        } else {
            id obj = self.dataSource[self.curAttachIndex];
            [self.dataSource removeObjectAtIndex:self.curAttachIndex];
            [self.dataSource insertObject:obj atIndex:self.curLocation.row];
        }
        
        [UIView animateWithDuration:0.2
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:1
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             if (cell) {
                                 self.mappingCell.center = cell.center;
                             } else {
                                 self.mappingCell.center = self.oldLocation;
                             }
                         } completion:^(BOOL finished) {
                             
                             [self.mappingCell removeFromSuperview];
                             cell.hidden = NO;
                             self.mappingCell = nil;
                             self.curLocation = nil;
                             [self.textView setHidden:NO];
                             [self setNewText];
                         }];
    }
}

- (void)setNewText {
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    NSInteger length = 0;
    for (int i = 0; i < self.dataSource.count; i ++) {
        NSString * obj = self.dataSource[i];
        if (obj) {
            if (![obj isEqualToString:@"图片"]) {
                
                [str insertAttributedString:[[NSAttributedString alloc] initWithString:obj attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}] atIndex:length];
            } else {
                
                NSTextAttachment *attachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
                UIImage *img = [UIImage imageNamed:@"1"];
                attachment.image = img;
                NSAttributedString *attStr = [NSAttributedString attributedStringWithAttachment:attachment];
                [str insertAttributedString:attStr atIndex:length];
            }
        }
        length += obj.length-1;
    }
    self.textView.attributedText = str;
}


#pragma mark - delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offSet = scrollView.contentOffset;
    [self.collectionView setContentOffset:offSet];
    
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return self.view.frame.size;
//}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id xx = self.dataSource[sourceIndexPath.row];
    [self.dataSource removeObjectAtIndex:sourceIndexPath.row];
    [self.dataSource insertObject:xx atIndex:destinationIndexPath.row];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TextCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TextCollectionViewCell class]) forIndexPath:indexPath];
    [cell renderWithBlock:^(id obj) {
        [self.dataSource replaceObjectAtIndex:indexPath.row withObject:obj];
        [self.collectionView reloadData];
    }];
    cell.text.text = self.dataSource[indexPath.row];
    cell.text.font = [UIFont systemFontOfSize:16];
    return cell;
}

#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        
        self.layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame), 40);
        _collectionView =  [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-100) collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (UILongPressGestureRecognizer *)gesture {
    if (!_gesture) {
        _gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    }
    return _gesture;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100)];
        _textView.delegate = self;
//        _textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    }
    return _textView;
}

@end
