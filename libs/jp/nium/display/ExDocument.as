/**
 * jp.nium Classes
 * 
 * @author Copyright (C) 2007-2010 taka:nium.jp, All Rights Reserved.
 * @version 4.0.22
 * @see http://classes.nium.jp/
 * 
 * jp.nium Classes is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 */
package jp.nium.display {
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.events.ExEvent;
	import jp.nium.utils.StageUtil;
	
	/**
	 * <span lang="ja">SWF ファイルの読み込みが完了し、stage 及び loaderInfo にアクセス可能になった場合に送出されます。</span>
	 * <span lang="en">Dispatch when the SWF file completes to read and the stage and the loaderInfo becomes able to access.</span>
	 * 
	 * @eventType jp.nium.events.ExEvent.EX_READY
	 */
	[Event( name="exReady", type="jp.nium.events.ExEvent" )]
	
	/**
	 * <span lang="ja">ExDocument クラスは、ExMovieClip クラスに対してドキュメントクラスとしての機能拡張を追加したドキュメント専用クラスです。</span>
	 * <span lang="en">The ExDocument class is a display object class that added the functionality expansion as the document class, to the ExMovieClip class.</span>
	 * 
	 * @see jp.nium.display#getInstanceById()
	 * @see jp.nium.display#getInstancesByGroup()
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public class ExDocument extends ExMovieClip {
		
		/**
		 * <span lang="ja">ロードされた SWF ファイル内の表示オブジェクトの場合、root プロパティはその SWF ファイルが表す表示リストのツリー構造部分の一番上にある表示オブジェクトとなります。</span>
		 * <span lang="en">For a display object in a loaded SWF file, the root property is the top-most display object in the portion of the display list's tree structure represented by that SWF file.</span>
		 */
		public static function get root():ExDocument {
			if ( !_created ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_023 ).toString( "root" ) ); }
			return _root;
		}
		private static var _root:ExDocument;
		
		/**
		 * <span lang="ja">表示オブジェクトのステージです。</span>
		 * <span lang="en">The Stage of the display object.</span>
		 */
		public static function get stage():Stage {
			if ( !_created ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_023 ).toString( "stage" ) ); }
			return _stage;
		}
		private static var _stage:Stage;
		
		/**
		 * <span lang="ja">ステージ左の X 座標を取得します。</span>
		 * <span lang="en">Get the left X coordinate of the stage.</span>
		 */
		public static function get left():Number {
			if ( !_created ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_023 ).toString( "left" ) ); }
			return -StageUtil.getMarginLeft( _stage );
		}
		
		/**
		 * <span lang="ja">ステージ中央の X 座標を取得します。</span>
		 * <span lang="en">Get the center X coordinate of the stage.</span>
		 */
		public static function get center():Number {
			if ( !_created ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_023 ).toString( "center" ) ); }
			return ( right + left ) / 2;
		}
		
		/**
		 * <span lang="ja">ステージ右の X 座標を取得します。</span>
		 * <span lang="en">Get the right X coordinate of the stage.</span>
		 */
		public static function get right():Number {
			if ( !_created ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_023 ).toString( "right" ) ); }
			return left + _stage.stageWidth;
		}
		
		/**
		 * <span lang="ja">ステージ上の Y 座標を取得します。</span>
		 * <span lang="en">Get the top Y coordinate of the stage.</span>
		 */
		public static function get top():Number {
			if ( !_created ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_023 ).toString( "top" ) ); }
			return -StageUtil.getMarginTop( _stage );
		}
		
		/**
		 * <span lang="ja">ステージ中央の Y 座標を取得します。</span>
		 * <span lang="en">Get the center Y coordinate of the stage.</span>
		 */
		public static function get middle():Number {
			if ( !_created ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_023 ).toString( "middle" ) ); }
			return ( bottom + top ) / 2;
		}
		
		/**
		 * <span lang="ja">ステージ下の Y 座標を取得します。</span>
		 * <span lang="en">Get the bottom Y coordinate of the stage.</span>
		 */
		public static function get bottom():Number {
			if ( !_created ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_023 ).toString( "bottom" ) ); }
			return top + _stage.stageHeight;
		}
		
		/**
		 * インスタンスが生成されたかどうかを取得します。
		 */
		private static var _created:Boolean = false;
		
		
		
		
		
		/**
		 * <span lang="ja">ドキュメントの準備が完了しているかどうかを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get isReady():Boolean { return _isReady; }
		private var _isReady:Boolean = false;
		
		/**
		 * 
		 */
		private var _isTopLevel:Boolean = false;
		
		/**
		 * ステージ上に設置されたかどうかを取得します。
		 */
		private var _isAddedToStage:Boolean = false;
		
		/**
		 * ステージサイズが取得可能になったかどうかを取得します。
		 */
		private var _isStageSize:Boolean = false;
		
		/**
		 * 初期化が完了したかどうかを取得します。
		 */
		private var _isInit:Boolean = false;
		
		/**
		 * 読み込み処理が完了したかどうかを取得します。
		 */
		private var _isComplete:Boolean = false;
		
		/**
		 * 前回のステージの幅を取得します。
		 */
		private var _oldStageWidth:Number = 0.0;
		
		/**
		 * 前回のステージの高さを取得します。
		 */
		private var _oldStageHeight:Number = 0.0;
		
		/**
		 * リサイズの遅延ミリ秒を取得します。
		 */
		private var _resizeDelay:int = 0;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい ExDocument インスタンスを作成します。</span>
		 * <span lang="en">Creates a new ExDocument object.</span>
		 * 
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function ExDocument( initObject:Object = null ) {
			// 親クラスを初期化する
			super( initObject );
			
			// root が存在しない、もしくは自身が root ではなければ
			if ( !super.root || this != super.root ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_007 ).toString( super.className ) ); }
			
			// stage を初期化する
			if ( super.stage && !_created ) {
				_isTopLevel = true;
				
				super.stage.align = StageAlign.TOP_LEFT;
				super.stage.scaleMode = StageScaleMode.NO_SCALE;
			}
			
			// 初期化する
			_root = this;
			_created = true;
			
			// イベントリスナーを登録する
			super.addEventListener( Event.ADDED_TO_STAGE, _addedToStage );
			super.loaderInfo.addEventListener( Event.INIT, _init );
			
			// 既に読み込みが完了していれば
			if ( super.loaderInfo.bytesTotal > 0 && super.loaderInfo.bytesLoaded >= super.loaderInfo.bytesTotal ) {
				_complete( null );
			}
			else {
				super.loaderInfo.addEventListener( Event.COMPLETE, _complete );
			}
		}
		
		
		
		
		
		/**
		 * 準備が完了したかどうかを返します。
		 */
		private function _checkReady():void {
			if ( _isReady || !_isAddedToStage || !_isStageSize || !_isInit || !_isComplete ) { return; }
			
			// トップレベルのルートであれば
			if ( _isTopLevel ) {
				_stage.dispatchEvent( new ExEvent( ExEvent.EX_RESIZE_START ) );
				_stage.dispatchEvent( new ExEvent( ExEvent.EX_RESIZE_PROGRESS ) );
				_stage.dispatchEvent( new ExEvent( ExEvent.EX_RESIZE_COMPLETE ) );
			}
			
			// イベントを送出する
			super.dispatchEvent( new ExEvent( ExEvent.EX_READY ) );
			
			// 状態を変更する
			_isReady = true;
		}
		
		
		
		
		
		/**
		 * 表示オブジェクトが、直接、または表示オブジェクトを含むサブツリーの追加により、ステージ上の表示リストに追加されたときに送出されます。
		 */
		private function _addedToStage( e:Event ):void {
			// イベントリスナーを解除する
			super.removeEventListener( Event.ADDED_TO_STAGE, _addedToStage );
			
			// stage の参照を保存する
			_stage = super.stage;
			
			// イベントリスナーを登録する
			super.addEventListener( Event.ENTER_FRAME, _enterFrame );
			_stage.addEventListener( Event.RESIZE, _resizeStart );
			
			// 状態を変更する
			_isAddedToStage = true;
			
			// 準備が完了したかどうか確認する
			_checkReady();
		}
		
		/**
		 * SWF ファイルの読み込みが完了した場合に送出されます。
		 */
		private function _init( e:Event ):void {
			// イベントリスナーを解除する
			super.loaderInfo.removeEventListener( Event.INIT, _init );
			
			// 状態を変更する
			_isInit = true;
			
			// 準備が完了したかどうか確認する
			_checkReady();
		}
		
		/**
		 * データが正常にロードされたときに送出されます。
		 */
		private function _complete( e:Event ):void {
			// イベントリスナーを解除する
			super.loaderInfo.removeEventListener( Event.COMPLETE, _complete );
			
			// 状態を変更する
			_isComplete = true;
			
			// 準備が完了したかどうか確認する
			_checkReady();
		}
		
		/**
		 * [ブロードキャストイベント] 再生ヘッドが新しいフレームに入るときに送出されます。
		 */
		private function _enterFrame( e:Event ):void {
			if ( super.stage.stageWidth <= 0 || super.stage.stageHeight <= 0 ) { return; }
			
			// イベントリスナーを解除する
			super.removeEventListener( Event.ENTER_FRAME, _enterFrame );
			
			// 状態を変更する
			_isStageSize = true;
			
			// 準備が完了したかどうか確認する
			_checkReady();
		}
		
		/**
		 * SWF ファイルのサイズ変更が開始されたときに送出されます。
		 */
		private function _resizeStart( e:Event ):void {
			// イベントリスナーを解除する
			_stage.removeEventListener( Event.RESIZE, _resizeStart );
			
			// イベントを送出する
			_stage.dispatchEvent( new ExEvent( ExEvent.EX_RESIZE_START ) );
			
			// イベントリスナーを登録する
			super.addEventListener( Event.ENTER_FRAME, _resizeProgress );
		}
		
		/**
		 * SWF ファイルのサイズが変更中であるときに送出されます。
		 */
		private function _resizeProgress( e:Event ):void {
			// イベントを送出する
			_stage.dispatchEvent( new ExEvent( ExEvent.EX_RESIZE_PROGRESS ) );
			
			var stageWidth:Number = _stage.stageWidth;
			var stageHeight:Number = _stage.stageHeight;
			
			// 前回とサイズが変更されていなければ、イベントを送出する
			if ( stageWidth == _oldStageWidth && stageHeight == _oldStageHeight && _resizeDelay++ > _stage.frameRate / 5 ) {
				// 遅延時間を初期化する
				_resizeDelay = 0;
				
				// イベントリスナーを解除する
				super.removeEventListener( Event.ENTER_FRAME, _resizeProgress );
				
				// イベントを送出する
				_stage.dispatchEvent( new ExEvent( ExEvent.EX_RESIZE_COMPLETE ) );
				
				// イベントリスナーを登録する
				_stage.addEventListener( Event.RESIZE, _resizeStart );
			}
			
			// 現在のサイズを保存する
			_oldStageWidth = stageWidth;
			_oldStageHeight = stageHeight;
		}
	}
}
