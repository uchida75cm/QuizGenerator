/**
 * Progression 4
 * 
 * @author Copyright (C) 2007-2010 taka:nium.jp, All Rights Reserved.
 * @version 4.0.22
 * @see http://progression.jp/
 * 
 * Progression Libraries is dual licensed under the "Progression Library License" and "GPL".
 * http://progression.jp/license
 */
package jp.progression.data {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import jp.nium.collections.IdGroupCollection;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.events.CollectionEvent;
	import jp.nium.utils.ClassUtil;
	import jp.progression.core.L10N.L10NProgressionMsg;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.core.PackageInfo;
	import jp.progression.events.ProcessEvent;
	import jp.progression.Progression;
	import jp.progression.scenes.SceneId;
	
	/**
	 * <span lang="ja">ResourcePrefetcher クラスは、Progression がアイドル状態になった際にデータの先読み処理を行うマネージャークラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.data#getResourceById()
	 * @see jp.progression.data#getResourcesByGroup()
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public final class ResourcePrefetcher {
		
		/**
		 * <span lang="ja">プロセスが待機状態になってから、先読みを開始するまでの遅延時間を取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #execute()
		 */
		public static function get interval():Number { return _interval; }
		public static function set interval( value:Number ):void { _interval = value; }
		private static var _interval:Number = 3.0;
		
		/**
		 * <span lang="ja">子として登録されているリクエスト数を取得します。</span>
		 * <span lang="en">Returns the number of children of this Request.</span>
		 */
		public static function get numRequests():uint { return _requests.length; }
		
		/**
		 * <span lang="ja">現在の処理状態を取得します。</span>
		 * <span lang="en"></span>
		 */
		public static function get state():int { return _state; }
		private static var _state:int = 0;
		
		/**
		 * PrefetchItem インスタンスを格納した配列を取得します。
		 */
		private static var _requests:Array = [];
		
		/**
		 * 現在のマネージャーインスタンスを取得します。
		 */
		private static var _manager:Progression;
		
		/**
		 * 現在の PrefetchItem インスタンスを取得します。
		 */
		private static var _current:PrefetchItem;
		
		/**
		 * 処理をロックするかどうかを取得します。
		 */
		private static var _lock:Boolean = false;
		
		/**
		 * マネージャーが動作中であるかどうかを取得します。
		 */
		private static var _process:Boolean = false;
		
		/**
		 * Timer インスタンスを取得します。
		 */
		private static var _timer:Timer = new Timer( 0 , 1 );
		
		
		
		
		
		/**
		 * 初期化する
		 */
		( function():void {
			// コレクションを取得する
			var collection:IdGroupCollection = Progression.progression_internal::$collection;
			
			// イベントリスナーを登録する
			collection.addEventListener( CollectionEvent.COLLECTION_UPDATE, _collectionUpdate );
			
			// 既存の登録を走査する
			var managers:Array = collection.instances;
			for ( var i:int = 0, l:int = managers.length; i < l; i++ ) {
				// マネージャーインスタンスを取得する
				var manager:Progression = Progression( managers[i] );
				
				// イベントリスナーを登録する
				manager.addEventListener( ProcessEvent.PROCESS_START, _processStart, false, 0, true );
				manager.addEventListener( ProcessEvent.PROCESS_COMPLETE, _processCompleteStopError, false, 0, true );
				manager.addEventListener( ProcessEvent.PROCESS_STOP, _processCompleteStopError, false, 0, true );
				manager.addEventListener( ProcessEvent.PROCESS_ERROR, _processCompleteStopError, false, 0, true );
				
				// プロセスが実行中かどうかを取得する
				if ( manager.state > 0 ) {
					// 状態を変更する
					_process = true;
					return;
				}
			}
			
			// 状態を変更する
			_process = false;
			
			// 読み込みを開始する
			_load();
		} )();
		
		
		
		
		
		/**
		 * @private
		 */
		public function ResourcePrefetcher() {
			// クラスをコンパイルに含める
			progression_internal;
			
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">先読み処理の待機状態を開始します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #pause()
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function resume():void {
			// 状態を変更する
			_lock = false;
			
			// 処理中であれば終了する
			if ( _process || _state > 0 ) { return; }
			
			// 読み込みを開始する
			_load();
		}
		
		/**
		 * <span lang="ja">先読み処理の待機状態を停止します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #resume()
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function pause():void {
			// 状態を変更する
			_lock = true;
			
			// 処理を中断する
			_interrupt();
		}
		
		/**
		 * 
		 */
		private static function _load():void {
			// コレクションを取得する
			var collection:IdGroupCollection = Progression.progression_internal::$collection;
			
			// 既存の登録を走査する
			var managers:Array = collection.instances;
			for ( var i:int = 0, l:int = managers.length; i < l; i++ ) {
				// マネージャーインスタンスを取得する
				var manager:Progression = Progression( managers[i] );
				
				// すでに実行中であれば終了する
				if ( manager.state > 0 ) {
					// 状態を変更する
					_process = true;
					return;
				}
			}
			
			// 状態を変更する
			_process = false;
			_state = 1;
			
			// タイマーを初期化する
			_timer.stop();
			_timer.delay = _interval * 1000;
			
			// イベントリスナーを登録する
			_timer.addEventListener( TimerEvent.TIMER_COMPLETE, _timerComplete );
			
			// タイマーを開始する
			_timer.start();
		}
		
		/**
		 * 
		 */
		private static function _progress():void {
			// シーン識別子の有無でソートする
			var express:Array = [];
			var locals:Array = [];
			for ( var i:int = 0, l:int = _requests.length; i < l; i++ ) {
				var item:PrefetchItem = PrefetchItem( _requests[i] );
				
				if ( item.sceneId ) {
					express.push( item );
				}
				else {
					locals.push( item );
				}
			}
			
			// シーン識別子と現在地に応じてソートする
			if ( _manager ) {
				var currents:Array = [];
				var holds:Array = [];
				var length:int = _manager.currentSceneId.length;
				for ( i = 0, l = express.length; i < l; i++ ) {
					item = express[i] as PrefetchItem;
					
					// ルートシーン名を取得する
					var name:String = item.sceneId.getNameByIndex( 0 );
					var d:int = item.sceneId.length;
					
					if ( _manager.id == name ) {
						// 差を取得する
						var d1:int = length - d;
						var d2:int = Math.abs( d1 );
						
						// 配列が存在しなければ作成する
						currents[d2] ||= [];
						
						// 深い階層を優先して読み込む
						if ( d1 <= 0 ) {
							currents[d2].unshift( item );
						}
						else {
							currents[d2].push( item );
						}
					}
					else {
						// 配列が存在しなければ作成する
						holds[d] ||= [];
						holds[d].push( item );
					}
				}
				
				// 優先順位リストを作成する
				express = [];
				for ( i = 0, l = currents.length; i < l; i++ ) {
					var results:Array = currents[i];
					
					if ( !results ) { continue; }
					
					for ( var ii:int = 0, ll:int = results.length; ii < ll; ii++ ) {
						item = results[ii] as PrefetchItem;
						
						if ( !item ) { continue; }
						
						express.push( item );
					}
				}
				for ( i = 0, l = holds.length; i < l; i++ ) {
					results = holds[i];
					
					if ( !results ) { continue; }
					
					for ( ii = 0, ll = results.length; ii < ll; ii++ ) {
						item = results[ii] as PrefetchItem;
						
						if ( !item ) { continue; }
						
						express.push( item );
					}
				}
			}
			
			// 結合する
			_requests = express.concat( locals );
			
			// アイテムを取得する
			_current = _requests.shift();
			
			// イベントリスナーを登録する
			_current.addEventListener( Event.COMPLETE, _completeIoError );
			_current.addEventListener( IOErrorEvent.IO_ERROR, _completeIoError );
			
			// 読み込みを開始する
			_current.load();
		}
		
		/**
		 * 
		 */
		private static function _interrupt():void {
			// イベントリスナーを解除します
			_timer.removeEventListener( TimerEvent.TIMER_COMPLETE, _timerComplete );
			
			// 読み込み中の対象が存在すれば
			if ( _current ) {
				if ( PackageInfo.hasDebugger ) {
					// 情報を表示する
					Logger.info( Logger.getLog( L10NProgressionMsg.getInstance().INFO_007 ).toString() );
				}
				
				// アイテムリストに戻す
				_requests.unshift( _current );
				
				// イベントリスナーを解除する
				_current.removeEventListener( Event.COMPLETE, _completeIoError );
				_current.removeEventListener( IOErrorEvent.IO_ERROR, _completeIoError );
				
				// 読み込みを閉じる
				_current.close();
				_current = null;
			}
			
			// 破棄する
			_manager = null;
			
			// 状態を変更する
			_state = 0;
		}
		
		/**
		 * <span lang="ja">先読みさせたい対象を登録します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param request
		 * <span lang="ja">先読みしたい対象のリクエストです。</span>
		 * <span lang="en"></span>
		 * @param sceneId
		 * <span lang="ja">優先順位付けの比較条件となる SceneId オブジェクトです。</span>
		 * <span lang="en"></span>
		 * @param context
		 * <span lang="ja">読み込み処理に関係する LoaderContext オブジェクト、または SoundLoaderContext オブジェクトです。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #removeRequest()
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function addRequest( request:URLRequest, sceneId:SceneId = null, context:* = null ):void {
			// 既存の登録を破棄する
			removeRequest( request );
			
			// 登録する
			_requests.push( new PrefetchItem( request, sceneId, context ) );
		}
		
		/**
		 * <span lang="ja">先読みさせたい対象から削除します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param request
		 * <span lang="ja">削除したい対象のリクエストです。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #addRequest()
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function removeRequest( request:URLRequest ):void {
			// 既存の登録を走査する
			for ( var i:int = 0, l:int = _requests.length; i < l; i++ ) {
				var item:PrefetchItem = PrefetchItem( _requests[i] );
				
				// 条件が合致したら
				if ( item.request.url == request.url ) {
					// イベントリスナーを解除する
					item.removeEventListener( Event.COMPLETE, _completeIoError );
					item.removeEventListener( IOErrorEvent.IO_ERROR, _completeIoError );
					
					// 破棄する
					item.dispose();
					_requests.splice( i, 1 );
					return;
				}
			}
		}
		
		
		
		
		
		/**
		 * コレクションに対して、インスタンスが追加された場合に送出されます。
		 */
		private static function _collectionUpdate( e:CollectionEvent ):void {
			// マネージャーインスタンスを取得する
			var manager:Progression = Progression( e.collectionTarget );
			
			// イベントリスナーを登録する
			manager.addEventListener( ProcessEvent.PROCESS_START, _processStart, false, 0, true );
			manager.addEventListener( ProcessEvent.PROCESS_COMPLETE, _processCompleteStopError, false, 0, true );
			manager.addEventListener( ProcessEvent.PROCESS_STOP, _processCompleteStopError, false, 0, true );
			manager.addEventListener( ProcessEvent.PROCESS_ERROR, _processCompleteStopError, false, 0, true );
		}
		
		/**
		 * 
		 */
		private static function _processStart( e:ProcessEvent ):void {
			// 状態を変更する
			_process = true;
			
			// 処理を中断する
			_interrupt();
		}
		
		/**
		 * 
		 */
		private static function _processCompleteStopError( e:ProcessEvent ):void {
			// 状態を変更する
			_process = false;
			
			// 現在のマネージャーを取得する
			_manager = e.targetScene.manager;
			
			// 読み込みを開始する
			_load();
		}
		
		/**
		 * 
		 */
		private static function _timerComplete( e:TimerEvent ):void {
			// イベントリスナーを解除します
			_timer.removeEventListener( TimerEvent.TIMER_COMPLETE, _timerComplete );
			
			// 対象が存在しなければ終了する
			if ( _requests.length == 0 ) { return; }
			
			if ( PackageInfo.hasDebugger ) {
				// 情報を表示する
				Logger.info( Logger.getLog( L10NProgressionMsg.getInstance().INFO_005 ).toString() );
			}
			
			// 状態を変更する
			_state = 2;
			
			// 次の処理を実行する
			_progress();
		}
		
		/**
		 * 
		 */
		private static function _completeIoError( e:Event ):void {
			if ( _current ) {
				// イベントリスナーを解除する
				_current.removeEventListener( Event.COMPLETE, _completeIoError );
				_current.removeEventListener( IOErrorEvent.IO_ERROR, _completeIoError );
				
				// 破棄する
				switch ( e.type ) {
					case Event.COMPLETE			: { _current.dispose(); break; }
					case IOErrorEvent.IO_ERROR	: { break; }
				}
				
				_current = null;
			}
			
			// 対象が存在していれば
			if ( _requests.length > 0 ) {
				// 次の処理を実行する
				_progress();
			}
			else {
				// 状態を変更する
				_state = 0;
				
				if ( PackageInfo.hasDebugger ) {
					// 情報を表示する
					Logger.info( Logger.getLog( L10NProgressionMsg.getInstance().INFO_007 ).toString() );
				}
			}
		}
	}
}





import flash.display.Bitmap;
import flash.display.Loader;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.media.Sound;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import jp.nium.core.debug.Logger;
import jp.nium.utils.ObjectUtil;
import jp.progression.core.impls.IDisposable;
import jp.progression.core.L10N.L10NProgressionMsg;
import jp.progression.core.ns.progression_internal;
import jp.progression.core.PackageInfo;
import jp.progression.data.Resource;
import jp.progression.scenes.SceneId;

/**
 * <span lang="ja">データの先読み処理のキュークラスです。</span>
 * <span lang="en"></span>
 */
internal class PrefetchItem extends EventDispatcher implements IDisposable {
	
	/**
	 * <span lang="ja">対象のリソース種別がサウンドデータであると指定します。</span>
	 * <span lang="en"></span>
	 */
	public static const SOUND:String = "sound";
	
	/**
	 * <span lang="ja">対象のリソース種別が画像データであると指定します。</span>
	 * <span lang="en"></span>
	 */
	public static const BITMAP:String = "bitmap";
	
	/**
	 * <span lang="ja">対象のリソース種別が SWF データであると指定します。</span>
	 * <span lang="en"></span>
	 */
	public static const SWF:String = "swf";
	
	/**
	 * <span lang="ja">対象のリソース種別がテキストデータであると指定します。</span>
	 * <span lang="en"></span>
	 */
	public static const TEXT:String = "text";
	
	
	
	
	
	/**
	 * <span lang="ja">リクエストされる URL を示すストリングを取得します。</span>
	 * <span lang="en"></span>
	 */
	public function get url():String { return _request ? _request.url : ""; }
	
	/**
	 * <span lang="ja">リクエストされる URL です。</span>
	 * <span lang="en"></span>
	 */
	public function get request():URLRequest { return _request; }
	private var _request:URLRequest;
	
	/**
	 * <span lang="ja">関連付けたいシーンを示すシーン識別子を取得します。</span>
	 * <span lang="en"></span>
	 */
	public function get sceneId():SceneId { return _sceneId; }
	private var _sceneId:SceneId;
	
	/**
	 * <span lang="ja">ポリシーファイルの存在の確認や、ApplicationDomain 及び SecurityDomain の設定を行う LoaderContext を取得または設定します。</span>
	 * <span lang="en"></span>
	 */
	public function get context():* { return _context; }
	private var _context:*;
	
	/**
	 * <span lang="ja">リソース種別を取得します。</span>
	 * <span lang="en"></span>
	 */
	public function get resourceType():String { return _resourceType; }
	private var _resourceType:String;
	
	/**
	 * URLLoader インスタンスを取得します。
	 */
	private var _urlloader:URLLoader;
	
	/**
	 * Loader インスタンスを取得します。
	 */
	private var _loader:Loader;
	
	/**
	 * Sound インスタンスを取得します。
	 */
	private var _sound:Sound;
	
	
	
	
	
	/**
	 * <span lang="ja">新しい PrefetchItem インスタンスを作成します。</span>
	 * <span lang="en">Creates a new PrefetchItem object.</span>
	 * 
	 * @param request
	 * <span lang="ja">読み込むファイルの絶対 URL または相対 URL を表す URLRequest インスタンスです。</span>
	 * <span lang="en"></span>
	 * @param sceneId
	 * <span lang="ja">関連付けたいシーンを示すシーン識別子です。</span>
	 * <span lang="en"></span>
	 * @param context
	 * <span lang="ja">LoaderContext オブジェクトです。</span>
	 * <span lang="en"></span>
	 */
	public function PrefetchItem( request:URLRequest, sceneId:SceneId = null, context:* = null ) {
		// クラスをコンパイルに含める
		progression_internal;
		
		// 引数を設定する
		_request = request;
		_sceneId = sceneId;
		_context = context;
		
		// リソースの種類を取得する
		var results:Array = new RegExp( "\.([a-z0-9]+)$", "i" ).exec( _request.url ) || [];
		switch ( String( results[1] ).toLowerCase() ) {
			case "mp3"		: { _resourceType = SOUND; break; }
			case "jpg"		:
			case "jpe"		:
			case "jpeg"		:
			case "gif"		:
			case "png"		: { _resourceType = BITMAP; break; }
			case "swf"		: { _resourceType = SWF; break; }
			default			: { _resourceType = TEXT; }
		}
	}
	
	
	
	
	
	/**
	 * <span lang="ja">指定された URL からデータを送信およびロードします。</span>
	 * <span lang="en"></span>
	 */
	public function load():void {
		var url:String = _request.url;
		
		// キャッシュを取得する
		var cache:Resource = Resource.progression_internal::$collection.getInstanceById( url ) as Resource;
		
		// すでにキャッシュが存在すれば終了する
		if ( cache ) {
			// イベントを送出する
			super.dispatchEvent( new Event( Event.COMPLETE ) );
			return;
		}
		
		if ( PackageInfo.hasDebugger ) {
			// 情報を表示する
			Logger.info( Logger.getLog( L10NProgressionMsg.getInstance().INFO_006 ).toString( url ) );
		}
		
		switch ( _resourceType ) {
			case SOUND	: {
				_sound = new Sound();
				
				_sound.addEventListener( Event.COMPLETE, _complete );
				_sound.addEventListener( IOErrorEvent.IO_ERROR, _ioError );
				
				_sound.load( _request, _context );
				break;
			}
			case BITMAP	:
			case SWF	: {
				_urlloader = new URLLoader();
				_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
				
				_urlloader.addEventListener( Event.COMPLETE, _complete );
				_urlloader.addEventListener( IOErrorEvent.IO_ERROR, _ioError );
				
				_urlloader.load( _request );
				break;
			}
			case TEXT	: {
				_urlloader = new URLLoader();
				
				_urlloader.addEventListener( Event.COMPLETE, _complete );
				_urlloader.addEventListener( IOErrorEvent.IO_ERROR, _ioError );
				
				_urlloader.load( _request );
				break;
			}
		}
	}
	
	/**
	 * <span lang="ja">進行中のロード操作は直ちに終了します。</span>
	 * <span lang="en"></span>
	 */
	public function close():void {
		try {
			_loader.close();
		}
		catch ( err:Error ) {}
		
		try {
			_urlloader.close();
		}
		catch ( err:Error ) {}
		
		try {
			_sound.close();
		}
		catch ( err:Error ) {}
	}
	
	/**
	 * <span lang="ja">保持しているデータを解放します。</span>
	 * <span lang="en"></span>
	 */
	public function dispose():void {
		// Loader 破棄する
		if ( _loader ) {
			_loader.unload();
			_loader = null;
		}
		
		// 破棄する
		_request = null;
		_sceneId = null;
		_context = null;
		_urlloader = null;
		_sound = null;
	}
	
	/**
	 * <span lang="ja">指定されたオブジェクトのストリング表現を返します。</span>
	 * <span lang="en">Returns the string representation of the specified object.</span>
	 * 
	 * @return
	 * <span lang="ja">オブジェクトのストリング表現です。</span>
	 * <span lang="en">A string representation of the object.</span>
	 */
	override public function toString():String {
		return ObjectUtil.formatToString( this, "PrefetchItem", "url", "sceneId" );
	}
	
	
	
	
	
	/**
	 * データが正常にロードされたときに送出されます。
	 */
	private function _complete( e:Event ):void {
		switch ( _resourceType ) {
			case SOUND	: {
				// リソースとしてキャッシュする
				new Resource( _request.url, _sound, null, _sound.bytesTotal );
				
				// イベントを送出する
				super.dispatchEvent( e );
				break;
			}
			case BITMAP	:
			case SWF	: {
				// Loader を作成する
				_loader = new Loader();
				
				// イベントリスナーを登録する
				_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, __complete );
				_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, _ioError );
				
				// 読み込む
				_loader.loadBytes( _urlloader.data, _context );
				break;
			}
			case TEXT	: {
				// リソースとしてキャッシュする
				new Resource( _request.url, _urlloader.data, null, _urlloader.bytesTotal );
				
				// イベントを送出する
				super.dispatchEvent( e );
				break;
			}
		}
	}
	
	/**
	 * データが正常にロードされたときに送出されます。
	 */
	private function __complete( e:Event ):void {
		switch ( _resourceType ) {
			case BITMAP	: {
				// リソースとしてキャッシュする
				new Resource( _request.url, Bitmap( _loader.content ).bitmapData, null, _loader.contentLoaderInfo.bytesTotal );
				break;
			}
			case SWF	: {
				// リソースとしてキャッシュする
				new Resource( _request.url, _loader, _urlloader.data, _loader.contentLoaderInfo.bytesTotal );
				break;
			}
		}
		
		// イベントを送出する
		super.dispatchEvent( e );
	}
	
	/**
	 * 入出力エラーが発生して読み込み処理が失敗したときに送出されます。
	 */
	private function _ioError( e:Event ):void {
		// イベントを送出する
		super.dispatchEvent( e );
	}
}
