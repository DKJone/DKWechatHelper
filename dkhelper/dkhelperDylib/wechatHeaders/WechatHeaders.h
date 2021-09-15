//
//  WechatHeaders.h
//  testHook
//
//  Created by 朱德坤 on 2018/12/29.
//  Copyright © 2018 DKJone. All rights reserved.
//

#ifndef WechatHeaders_h
#define WechatHeaders_h

#import <UIKit/UIKit.h>

@interface MMUIViewController : UIViewController
- (id)findMainTableView;
@end



@interface MMTabBarBaseViewController : MMUIViewController
@end

#pragma mark - MMTableView



@interface MMTableViewSectionInfo : NSObject
+ (id)sectionInfoDefaut;
+ (id)sectionInfoHeader:(id)arg1;
+ (id)sectionInfoHeader:(id)arg1 Footer:(id)arg2;
- (void)addCell:(id)arg1;
- (void)removeCellAt:(unsigned long long)arg1;
- (unsigned long long)getCellCount;
@end

@interface MMTableViewCellInfo
+ (id)normalCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 accessoryType:(long long)arg4;
+ (id)switchCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 on:(BOOL)arg4;
+ (id)normalCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 rightValue:(id)arg4 accessoryType:(long long)arg5;
+ (id)editorCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 margin:(double)arg4 tip:(id)arg5 focus:(BOOL)arg6 text:(id)arg7;
+ (id)normalCellForTitle:(id)arg1 rightValue:(id)arg2;
+ (id)urlCellForTitle:(id)arg1 url:(id)arg2;
@property(nonatomic) long long editStyle; // @synthesize editStyle=_editStyle;
@property(retain, nonatomic) id userInfo;
@end

@interface MMTableView: UITableView
@end

//MARK: - WCTableViewNormalCellManager


@class UIColor, UITableViewCell, WCTableViewCellBaseConfig;

@interface WCTableViewCellManager : NSObject
+ (id)normalCellForSel:(SEL)arg1 target:(id)arg2  title:(id)arg3;
+ (id)loadingCell;
+ (id)ActivityIndicatorCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3;
+ (id)detailDisclosureButtonCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3;
+ (id)switchCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 on:(BOOL)arg4;

@end


@interface WCTableViewNormalCellManager : WCTableViewCellManager
+ (WCTableViewNormalCellManager *)normalCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 accessoryType:(long long)arg4;
+ (WCTableViewNormalCellManager *)normalCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 rightValue:(id)arg4 accessoryType:(long long)arg5;
- (id)getUserInfoValueForKey:(id)arg1;
- (void)addUserInfoValue:(id)arg1 forKey:(id)arg2;
@end

@class NSMutableArray, NSString, UITableView, UIView;

@interface WCTableViewSectionManager : NSObject

@property(nonatomic) double fTopLineLeftInset; // @synthesize fTopLineLeftInset=_fTopLineLeftInset;
@property(nonatomic) double fFooterHeight; // @synthesize fFooterHeight=_fFooterHeight;
@property(nonatomic) double fHeaderHeight; // @synthesize fHeaderHeight=_fHeaderHeight;
@property(copy, nonatomic) NSString *footerTitle; // @synthesize footerTitle=_footerTitle;
@property(copy, nonatomic) NSString *headerTitle; // @synthesize headerTitle=_headerTitle;

+ (id)defaultSection;
+ (id)sectionInfoDefaut;
- (void)removeCellAt:(unsigned long long)arg1;
- (id)getCellAt:(unsigned long long)arg1;
- (unsigned long long)getCellCount;
- (void)insertCell:(id)arg1 At:(unsigned int)arg2;
- (void)didBeClickedAt:(id)arg1;
- (void)addCell:(id)arg1;
- (id)getFooterView;
- (id)getHeaderView;

@end


//MARK: - WCTableViewManager
@class MMTableView, NSMutableArray, NSString;
@protocol MMTableViewInfoDelegate;

@interface WCTableViewManager : NSObject <UITableViewDelegate, UITableViewDataSource >

@property(retain, nonatomic) NSMutableArray *sections;

@property(nonatomic) __weak id <MMTableViewInfoDelegate> delegate;
@property(retain, nonatomic) MMTableView *tableView;
- (id)cellInfoAtIndexPath:(id)arg1;
- (void)clearCell:(id)arg1;

- (void)reloadTableView;
- (void)clearAllSection;
- (void)removeCellAt:(id)arg1;
- (void)removeSectionAt:(unsigned long long)arg1;
- (WCTableViewSectionManager *)getSectionAt:(unsigned long long)arg1;
- (unsigned long long)getSectionCount;
- (void)insertSection:(id)arg1 At:(unsigned int)arg2;
- (void)addSection:(WCTableViewSectionManager *)arg1;

- (id)getTableView;
- (id)initWithFrame:(struct CGRect)arg1 style:(long long)arg2;
- (void)addTableViewToSuperView:(id)arg1;

@end

@interface MMTableViewInfo:WCTableViewManager

@end

@interface PhotoViewController:UIViewController
- (void)initImageViewerWithUrls:(id)arg1 current:(id)arg2;
+ (id)imageFromCacheWithUrl:(id)arg1;
+ (id)imageDataFromCacheWithUrl:(id)arg1;
+ (id)genKeyForUrl:(id)arg1;
@property(nonatomic) __weak id delegate;
@property(copy, nonatomic) NSString *relativeUrl;
@property(nonatomic) BOOL needDistinguishGif; // @synthesize needDistinguishGif=_needDistinguishGif;
@property(nonatomic) BOOL isFromSafariOr3rdApp; // @synthesize isFromSafariOr3rdApp=_isFromSafariOr3rdApp;
@property(nonatomic) BOOL isFromWeApp; // @synthesize isFromWeApp=_isFromWeApp;
@property(nonatomic) BOOL isForbidForward; // @synthesize isForbidForward=_isForbidForward;
@property(nonatomic) BOOL isFromWebview; // @synthesize isFromWebview=m_isFromWebview;
@end

@interface NewQRCodeScannerParams
- (id)initWithCodeType:(int)arg1;
- (id)initWithCodeType:(int)arg1 isUseSmallCropArea:(BOOL)arg2;
@end


@interface NewQRCodeScanner
- (BOOL)scanOnePicture:(id)arg1;
- (id)initWithDelegate:(id)arg1 scannerParams:(NewQRCodeScannerParams *)arg2;
@end

@interface ScanQRCodeLogicController
- (id)initWithViewController:(id)arg1 logicParams:(id)arg2;
@property(readonly, nonatomic) NSDictionary *tryScanExtraInfo;
- (void)showScanResult;
- (void)reportEngineStatWithScene:(unsigned int)arg1 scanType:(long long)arg2;
- (void)startScan;
- (void)doScanQRCode:(id)img;
@end


@interface MMWebViewController: UIViewController
- (id)initWithURL:(id)arg1 presentModal:(BOOL)arg2 extraInfo:(id)arg3;
@end

@interface UINavigationController (LogicController)
- (void)PushViewController:(id)arg1 animated:(BOOL)arg2;
@end


@interface ContactSelectView : UIView

@property(nonatomic) unsigned int m_uiGroupScene; // @synthesize m_uiGroupScene;
@property(nonatomic) BOOL m_bMultiSelect; // @synthesize m_bMultiSelect;
@property(nonatomic) BOOL m_bShowHistoryGroup;
@property(nonatomic) BOOL m_bShowRadarCreateRoom;
@property(retain, nonatomic) NSMutableDictionary *m_dicMultiSelect; // @synthesize m_dicMultiSelect;

- (id)initWithFrame:(struct CGRect)arg1 delegate:(id)arg2;
- (void)initData:(unsigned int)arg1;
- (void)initView;
- (void)addSelect:(id)arg1;
- (void)removeSelect:(id)arg1;
- (void)setM_dicExistContact:(id)arg1;
@end

@interface MMUINavigationController : UINavigationController
@end


@interface WCPayInfoItem: NSObject

@property(retain, nonatomic) NSString *m_c2cNativeUrl;

@end

/// 朋友圈点赞和评论
@interface WCUserComment : NSObject
@property (retain, nonatomic) NSString * nickname;
@property (retain, nonatomic) NSString* username;
@property (retain, nonatomic) NSString* contentPattern;
@property (retain, nonatomic) NSString* content;
@property (retain, nonatomic) NSString* commentID;
@property (retain, nonatomic) NSString* m_cpKeyForComment;//@"wctlcm|33||z314250405||1563794344"   @"wctlcm|99|1|wxid_6913ohfkk7kq12|liuwenling001|1563794437"

@property (retain, nonatomic) NSString* refCommentID;
@property (retain, nonatomic) NSString* refUserName;

/// 点赞：1，评论：2
@property  (nonatomic) int type;
@property  (nonatomic) int isRichText;
@property  (nonatomic) unsigned int createTime;

@end


@interface CContact: NSObject <NSCoding>
@property (nonatomic, copy) NSString *m_nsOwner;                        // 拥有者
@property (nonatomic, copy) NSString *m_nsNickName;                     // 用户昵称
@property (nonatomic, copy) NSString *m_nsUsrName;                      // 微信id
@property (nonatomic, copy) NSString *m_nsMemberName;
@property (nonatomic, copy) NSString *m_nsRemark;
@property(retain, nonatomic) NSString *m_nsHeadImgUrl;
@property(nonatomic) unsigned int m_uiSex;

- (id)getContactDisplayName;

/// 是不是公众号
- (BOOL)isBrandContact;
/// 是不是公众号
- (BOOL)isHolderContact;


@end

@interface CContactMgr : NSObject

- (id)getSelfContact;
- (id)getContactByName:(id)arg1;
- (id)getContactForSearchByName:(id)arg1;
- (BOOL)getContactsFromServer:(id)arg1;
- (BOOL)isInContactList:(id)arg1;
- (BOOL)addLocalContact:(id)arg1 listType:(unsigned int)arg2;
- (NSArray *)getContactList:(unsigned int)arg1 contactType:(unsigned int)arg2;
- (BOOL)deleteContactLocal:(id)arg1 listType:(unsigned int)arg2;
- (BOOL)deleteContact:(id)arg1 listType:(unsigned int)arg2;
@end

@protocol ContactSelectViewDelegate <NSObject>

- (void)onSelectContact:(CContact *)arg1;

@end

@interface MMServiceCenter : NSObject

+ (instancetype)defaultCenter;
- (id)getService:(Class)service;

@end

@interface MMContext : NSObject

+ (id)activeUserContext;
+ (id)rootContext;
+ (id)currentContext;
- (id)getService:(Class)arg1;
@property(readonly, nonatomic) MMServiceCenter *serviceCenter;

@end

@interface ScanQRCodeLogicParams 
- (id)initWithCodeType:(int)arg1 fromScene:(unsigned int)arg2 enterScene:(unsigned long long)arg3 bNeedCameraScan:(BOOL)arg4 bShowMyQRCodeBtn:(BOOL)arg5 wrapper:(id)arg6;
- (id)initWithCodeType:(int)arg1 fromScene:(unsigned int)arg2;

@end

@interface CMessageWrap : NSObject
@property (retain, nonatomic) WCPayInfoItem *m_oWCPayInfoItem;
@property(nonatomic, assign) NSInteger m_uiGameType;  // 1、猜拳; 2、骰子; 0、自定义表情
@property(nonatomic, assign) unsigned long m_uiGameContent;
@property(nonatomic, strong) NSString *m_nsEmoticonMD5;
@property(nonatomic) long long m_n64MesSvrID;
@property (nonatomic, copy) NSString *m_nsContent;                      // 内容
@property (nonatomic, copy) NSString *m_nsToUsr;                        // 接收的用户(微信id)
@property (nonatomic, copy) NSString *m_nsFromUsr;                      // 发送的用户(微信id)
@property (nonatomic, copy) NSString *m_nsLastDisplayContent;
@property (nonatomic, assign) unsigned int m_uiCreateTime;               // 消息生成时间
@property (nonatomic, assign) unsigned int m_uiStatus;                   // 消息状态
@property (nonatomic, assign) int m_uiMessageType;                       // 消息类型
@property (nonatomic, copy) NSString *m_nsRealChatUsr;
@property (nonatomic, copy) NSString *m_nsPushContent;
- (id)initWithMsgType:(long long)arg1;

@property(nonatomic) unsigned int m_uiMesLocalID;
@end

@interface CBaseContact : NSObject
@property (nonatomic, copy) NSString *m_nsEncodeUserName;                // 微信用户名转码
@property (nonatomic, assign) int m_uiFriendScene;                       // 是否是自己的好友(非订阅号、自己)
@property (nonatomic,assign) BOOL m_isPlugin;                            // 是否为微信插件
- (BOOL)isChatroom;
@end

@interface GameController : NSObject
+ (NSString*)getMD5ByGameContent:(NSInteger) content;
@end

@interface CMessageMgr : NSObject
- (id)GetMsg:(id)arg1 n64SvrID:(long long)arg2;
- (void)onRevokeMsg:(id)msg;
- (void)AddMsg:(id)arg1 MsgWrap:(id)arg2;
- (void)AddLocalMsg:(id)arg1 MsgWrap:(id)arg2 fixTime:(BOOL)arg3 NewMsgArriveNotify:(BOOL)arg4;
- (void)AsyncOnSpecialSession:(id)arg1 MsgList:(id)arg2;
- (id)GetHelloUsers:(id)arg1 Limit:(unsigned int)arg2 OnlyUnread:(BOOL)arg3;
- (void)AddEmoticonMsg:(NSString *)msg MsgWrap:(CMessageWrap *)msgWrap;
- (void)DelMsg:(id)arg1 MsgWrap:(id)arg2;
- (void)ResendMsg:(id)arg1 MsgWrap:(id)arg2;
- (_Bool)RevokeMsg:(id)arg1 MsgWrap:(id)arg2 Counter:(unsigned int)arg3;


@end

@interface WCContentItem : NSObject
@property(retain, nonatomic) NSString *linkUrl;
@property(nonatomic) int type;
@property(retain, nonatomic) NSMutableArray *mediaList;  
@end

/// 朋友圈数据
@interface WCDataItem : NSObject
@property (retain, nonatomic) NSMutableArray * likeUsers;
@property  (nonatomic) int likeCount;
@property (retain, nonatomic) NSString* username;
@property (retain, nonatomic) NSMutableArray * commentUsers;
@property  (nonatomic) int commentCount;
@property(nonatomic,assign) BOOL likeFlag;
@property(nonatomic) unsigned int createtime;
@property(retain, nonatomic) NSString *contentDesc;
@property(retain, nonatomic) WCContentItem *contentObj;

@end
@interface WCNewCommitViewController : MMUIViewController
- (id)initWithSightDraft:(id)arg1;
@end
@interface WCForwardViewController : WCNewCommitViewController
- (id)initWithDataItem:(id)arg1 sessionID:(id)arg2;
- (id)initWithDataItem:(id)arg1;
@end


@interface SettingUtil : NSObject
/// 获取当前用户的用户名:wxid_....
+ (id)getLocalUsrName:(unsigned int)arg1;
@end

@interface MMNewSessionMgr : NSObject
- (unsigned int)GenSendMsgTime;
- (void)deleteSessionAtIndex:(unsigned int)arg1 forceDelete:(_Bool)arg2;
- (unsigned int)getSessionIndexOfUser:(id)arg1;
@end

@interface WCBizUtil : NSObject

+ (id)dictionaryWithDecodedComponets:(id)arg1 separator:(id)arg2;

@end

@interface NSMutableDictionary (SafeInsert)

- (void)safeSetObject:(id)arg1 forKey:(id)arg2;

@end

@interface NSDictionary (NSDictionary_SafeJSON)

- (id)arrayForKey:(id)arg1;
- (id)dictionaryForKey:(id)arg1;
- (double)doubleForKey:(id)arg1;
- (float)floatForKey:(id)arg1;
- (long long)int64ForKey:(id)arg1;
- (long long)integerForKey:(id)arg1;
- (id)stringForKey:(id)arg1;

@end

@interface NSString (NSString_SBJSON)

- (id)JSONArray;
- (id)JSONDictionary;
- (id)JSONValue;

@end

@interface WCRedEnvelopesLogicMgr: NSObject

- (void)OpenRedEnvelopesRequest:(id)params;
- (void)ReceiverQueryRedEnvelopesRequest:(id)arg1;
- (void)GetHongbaoBusinessRequest:(id)arg1 CMDID:(unsigned int)arg2 OutputType:(unsigned int)arg3;

/** Added Methods */
- (unsigned int)calculateDelaySeconds;

@end


@interface SKBuiltinBuffer_t : NSObject

@property(retain, nonatomic) NSData *buffer; // @dynamic buffer;

@end

@interface HongBaoRes : NSObject

@property(retain, nonatomic) SKBuiltinBuffer_t *retText; // @dynamic retText;
@property(nonatomic) int cgiCmdid; // @dynamic cgiCmdid;

@end

@interface HongBaoReq : NSObject

@property(retain, nonatomic) SKBuiltinBuffer_t *reqText; // @dynamic reqText;

@end



@interface CAppViewControllerManager: NSObject

+ (id)topViewControllerOfWindow:(id)arg1;
+ (id)topViewControllerOfMainWindow;
+ (id)topMostController;
+ (id)getCurrentNavigationController;
+ (id)getTabBarController;
+ (id)getAppViewControllerManager;

@end



@interface ScanCodeHistoryItem : NSObject
@property(copy, nonatomic) NSString *type;
@property(copy, nonatomic) NSString *codeUrl;
@end

@interface ScanQRCodeResultsMgr :NSObject
- (void)retryRequetScanResult:(ScanCodeHistoryItem *)arg1 viewController:(id)arg2;
@end

@interface CGroupMgr :NSObject
+ (BOOL)isSupportOpenIMGroup;
- (BOOL)CreateGroup:(id)arg1 withMemberList:(id)arg2;
@end

/// 群组成员
@interface GroupMember : NSObject
@property(retain, nonatomic) NSString *m_nsMemberName;
- (id)init;
@end

@interface MMLoadingView : UIView
@property(retain, nonatomic) NSString *text;
- (void)stopLoadingAndShowOK;
- (void)stopLoadingAndShowError:(id)arg1 withDelay:(double)arg2;
- (void)stopLoadingAndShowError:(id)arg1;
- (void)stopLoadingAndShowOK:(id)arg1 withDelay:(double)arg2;
- (void)stopLoadingAndShowOK:(id)arg1;
- (void)stopLoading;
- (void)startLoading;


@end

@interface MicroMessengerAppDelegate
+ (MicroMessengerAppDelegate *)GlobalInstance;
@property(retain, nonatomic) UIWindow *window;
@property (nonatomic, retain) UIWindow *launchWindow;
-(void)showLaunchVideo;
@end

@interface WCOperateFloatView : UIView{
    UIImageView *m_lineView;
}

@property(nonatomic) __weak UINavigationController *navigationController;
@property(readonly, nonatomic) UIButton *m_commentBtn;
@property(readonly, nonatomic) UIButton *m_likeBtn;
@property(nonatomic,strong) UIButton *m_shareBtn;
@property(nonatomic,strong)UIImageView *m_lineView2;
@property(readonly, nonatomic) WCDataItem *m_item;
- (void)onLikeItem:(id)arg1;
- (void)hide;
- (void)animationDidStopHide;
- (void)animationDidStop;
- (void)showWithItemData:(id)arg1 tipPoint:(struct CGPoint)arg2;
- (id)init;
- (double)protectWidth:(double)arg1;
- (double)buttonWidth:(id)arg1;
/// 朋友圈转发
- (void)forwordTimeLine:(id)arg1;

@end

@interface WCPayTransferPrepayRequestStruct : NSObject

@property(retain, nonatomic) NSString *placeorderReserves;
@property(nonatomic) unsigned int m_uiPayChannel;
@property(nonatomic) int m_transferScene;
@property(retain, nonatomic) NSString *m_nsProducetDesc;
@property(nonatomic) unsigned int m_uiPayScene;
@property(nonatomic) unsigned long long m_uiTotalFee;
@property(nonatomic) unsigned int m_uiFeeType;
@property(retain, nonatomic) NSString *m_nsReceiverUserName;
@end

@interface WCPayLogicMgr:NSObject
- (void)GetTransferPrepayRequest:(id)arg1;
@end

 //MARK: - imagePicker
@class EditImageAttr, MMAsset, MMImagePickerController, NSArray, NSDictionary, SightDraft, UINavigationController, WCFinderDataItem, WCFinderReportPostStateModel;
@protocol MMImagePickerControllerDelegate <NSObject>
@optional
- (void)onImagePickerControllerClickPostFinderLongVideoWithPostStateModel:(WCFinderReportPostStateModel *)arg1;
- (void)MMImagePickerController:(MMImagePickerController *)arg1 didFinishPickingImageWithEditImageAttr:(EditImageAttr *)arg2;
- (void)MMVideoPickerController:(UINavigationController *)arg1 didFinishPickingVideoWithAsset:(MMAsset *)arg2;
- (void)MMVideoPickerController:(UINavigationController *)arg1 didFinishPickingSightWithInfo:(SightDraft *)arg2;
- (void)MMVideoPickerController:(UINavigationController *)arg1 didFinishPickingMediaWithInfo:(NSDictionary *)arg2;
- (void)MMImagePickerControllerDidSkip:(MMImagePickerController *)arg1;
- (void)MMImagePickerControllerDidCancel:(MMImagePickerController *)arg1;
- (void)MMImagePickerManager:(UINavigationController *)arg1 didFinishPickingAssetWithDataItem:(WCFinderDataItem *)arg2 GPSInfoArrayOfAsset:(NSArray *)arg3 dataReportModel:(WCFinderReportPostStateModel *)arg4;
- (void)MMImagePickerController:(MMImagePickerController *)arg1 didFailToPickAssets:(NSArray *)arg2;
- (void)MMImagePickerController:(MMImagePickerController *)arg1 didFinishPickingMediaWithInfo:(NSArray *)arg2;
@end

@class EditImageLogicController, EditVideoLogicController, MMAssetPickerController, MMImagePickerControllerPreviewReportObject, MMNearbyAssetPickerViewController, NSArray, NSString, WCFinderEditOptionModel;
@protocol MMImagePickerControllerDelegate;

@interface MMImagePickerController : MMUINavigationController

@property(nonatomic) unsigned long long enterTime; // @synthesize enterTime=_enterTime;
@property(nonatomic) __weak MMNearbyAssetPickerViewController *nearbyAssetPicker; // @synthesize nearbyAssetPicker=_nearbyAssetPicker;
@property(nonatomic) _Bool showSkipBtn; // @synthesize showSkipBtn=_showSkipBtn;
@property(retain, nonatomic) WCFinderEditOptionModel *finderOptionModel; // @synthesize finderOptionModel=_finderOptionModel;
@property(nonatomic) _Bool buttonEnableAfterSend; // @synthesize buttonEnableAfterSend=_buttonEnableAfterSend;
@property(nonatomic) _Bool videoDirectToEdit; // @synthesize videoDirectToEdit=_videoDirectToEdit;
@property(nonatomic) unsigned long long maxGifDataSize; // @synthesize maxGifDataSize=_maxGifDataSize;
@property(retain, nonatomic) EditVideoLogicController *editVideoLogicController; // @synthesize editVideoLogicController=_editVideoLogicController;
@property(retain, nonatomic) EditImageLogicController *editImageLogicController; // @synthesize editImageLogicController=_editImageLogicController;
@property(retain, nonatomic) MMImagePickerControllerPreviewReportObject *m_previewReportObject; // @synthesize m_previewReportObject;
@property(nonatomic) _Bool isAllowCache; // @synthesize isAllowCache=_isAllowCache;
@property(nonatomic) _Bool isPresentInSplitVC; // @synthesize isPresentInSplitVC=_isPresentInSplitVC;
@property(nonatomic) int previewEditScene; // @synthesize previewEditScene=_previewEditScene;
@property(nonatomic) _Bool isEditMode; // @synthesize isEditMode=_isEditMode;
@property(nonatomic) _Bool isOriginalImage; // @synthesize isOriginalImage=_isOriginalImage;
@property(retain, nonatomic) NSArray *selectedImageAssets; // @synthesize selectedImageAssets=_selectedImageAssets;
@property(retain, nonatomic) NSArray *selectedImageURLs; // @synthesize selectedImageURLs=_selectedImageURLs;
@property(retain, nonatomic) NSString *currentAlbum; // @synthesize currentAlbum=_currentAlbum;
@property(retain, nonatomic) NSString *finishWording; // @synthesize finishWording=_finishWording;
@property(nonatomic) int compressType; // @synthesize compressType=_compressType;
@property(nonatomic) int maxImageCount; // @synthesize maxImageCount=_maxImageCount;
@property(nonatomic) _Bool canHybridSendAsset; // @synthesize canHybridSendAsset=_canHybridSendAsset;
@property(nonatomic) _Bool canSendGif; // @synthesize canSendGif=_canSendGif;
@property(nonatomic) _Bool returnMetaForVideo; // @synthesize returnMetaForVideo=_returnMetaForVideo;
@property(nonatomic) _Bool customizesClickAction; // @synthesize customizesClickAction=_customizesClickAction;
@property(nonatomic) _Bool showPreviewView; // @synthesize showPreviewView=_showPreviewView;
@property(nonatomic) _Bool needThumbImage; // @synthesize needThumbImage=_needThumbImage;
@property(nonatomic) _Bool canSendMultiVideo; // @synthesize canSendMultiVideo=_canSendMultiVideo;
@property(nonatomic) _Bool canSendMultiImage; // @synthesize canSendMultiImage=_canSendMultiImage;
@property(nonatomic) _Bool isNotShowVideoSizeAlertView; // @synthesize isNotShowVideoSizeAlertView=_isNotShowVideoSizeAlertView;
@property(nonatomic) _Bool isOnlyShowVideoMessage; // @synthesize isOnlyShowVideoMessage=_isOnlyShowVideoMessage;
@property(nonatomic) _Bool canSendVideoMessage; // @synthesize canSendVideoMessage=_canSendVideoMessage;
@property(nonatomic) _Bool forceSendOriginImage; // @synthesize forceSendOriginImage=_forceSendOriginImage;
@property(nonatomic) _Bool canSendOriginImage; // @synthesize canSendOriginImage=_canSendOriginImage;
@property(nonatomic) __weak MMAssetPickerController *photoPicker; // @synthesize photoPicker=_photoPicker;
@property(nonatomic) __weak id <MMImagePickerControllerDelegate> m_delegate; // @synthesize m_delegate;
- (void)onAssetPickerControlCenterClickPostFinderLongVideoWithPostStateModel:(id)arg1;
- (void)didReceiveMemoryWarning;
- (int)getPickerScene;
- (void)logImagePickerFinishLoad:(_Bool)arg1;
- (void)logStartImagePicker;
- (void)reportPickerActionInfo;
- (void)reportPicerReportInfo;
- (id)pickerReportInfo;
- (void)reportPreviewCount;
- (void)increasePreviewCount;
- (void)selectedDataItem:(id)arg1 GPSInfoArrayOfAsset:(id)arg2 dataReportModel:(id)arg3;
- (void)failToFetchAssets:(id)arg1;
- (void)selectAsset:(id)arg1;
- (void)selectedEditImageAttr:(id)arg1;
- (void)selectedSight:(id)arg1;
- (void)selectedVideo:(id)arg1;
- (void)didClickSkipBtn;
- (void)selectedAssets:(id)arg1;
- (void)selectedClickNextAction;
- (void)cancelImagePicker;
- (void)removeImageDatas;
- (id)getReportExtInfoDismissState:(_Bool)arg1 eventCode:(long long)arg2;
- (_Bool)isFinderScene;

- (id)initWithPoiInfo:(id)arg1 withOnlyShowVideoMessage:(_Bool)arg2 withNotShowVideoSizeAlertView:(_Bool)arg3 withMaxDuration:(unsigned long long)arg4 withShouldIncludeVideo:(_Bool)arg5;
- (id)initForJustReturnMMAsset:(_Bool)arg1 withAdjustRevertIndex:(unsigned long long)arg2 withDirectToFirstAlbum:(_Bool)arg3 withOnlyShowVideoMessage:(_Bool)arg4 withNotShowVideoSizeAlertView:(_Bool)arg5 withPickerVCForceFullScrenn:(_Bool)arg6;


@end



@interface ZipArchive : NSObject



@property(nonatomic) id delegate; // @synthesize delegate=_delegate;
- (id)Date1980;
- (_Bool)OverWrite:(id)arg1;
- (void)OutputErrorMessage:(id)arg1;
- (_Bool)UnzipCloseFile;
- (_Bool)UnzipCurrentFileWithPosition:(unsigned int)arg1 length:(unsigned int)arg2 retData:(id *)arg3;
- (_Bool)UnzipGetCurrentFileName:(id *)arg1 retIsDirectory:(_Bool *)arg2 retFileLength:(unsigned long long *)arg3;
- (_Bool)UnzipGoToFirstFile;
- (_Bool)UnzipGoToNextFile;
- (_Bool)UnzipLocateFile:(id)arg1;
- (_Bool)UnzipHasRelativeDir:(_Bool *)arg1;
- (_Bool)UnzipFileTo:(id)arg1 overWrite:(_Bool)arg2;
- (_Bool)UnzipOpenFile:(id)arg1 Password:(id)arg2;
- (_Bool)UnzipOpenFile:(id)arg1;
- (_Bool)CloseZipFile2;
- (_Bool)addFileToZip:(id)arg1 newname:(id)arg2;
- (_Bool)addSingleFileToZip:(id)arg1 fileNameInZip:(id)arg2;
- (_Bool)CreateZipFile2:(id)arg1 Password:(id)arg2;
- (_Bool)CreateZipFile2:(id)arg1;
- (void)dealloc;
- (id)init;

@end

@interface MZipUtil : NSObject

+ (BOOL)UnZipFile:(NSString *)path toPath:(NSString *)destination;
+ (BOOL)UnZipFile:(NSString *)path toPath:(NSString *)destination overwrite:(BOOL)overwrite password:(NSString *)password error:(NSError **)error;


@end


#endif /* WechatHeaders_h */


