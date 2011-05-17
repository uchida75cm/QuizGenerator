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
package jp.progression.scenes {
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.system.ApplicationDomain;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.net.Query;
	import jp.progression.casts.CastDocument;
	import jp.progression.core.L10N.L10NProgressionMsg;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.events.ManagerEvent;
	import jp.progression.events.SceneEvent;
	
	/**
	 * <span lang="ja">query プロパティの値が更新された場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.SceneEvent.SCENE_QUERY_CHANGE
	 */
	[Event( name="sceneQueryChange", type="jp.progression.events.SceneEvent" )]
	
	/**
	 * <span lang="ja">読み込み操作が開始したときに送出されます。</span>
	 * <span lang="en">Dispatched when a load operation starts.</span>
	 * 
	 * @eventType flash.events.Event.OPEN
	 */
	[Event( name="open", type="flash.events.Event" )]
	
	/**
	 * <span lang="ja">ロードされた SWF ファイルのプロパティおよびメソッドがアクセス可能で使用できる状態の場合に送出されます。</span>
	 * <span lang="en">Dispatched when the properties and methods of a loaded SWF file are accessible and ready for use.</span>
	 * 
	 * @eventType flash.events.Event.INIT
	 */
	[Event( name="init", type="flash.events.Event" )]
	
	/**
	 * <span lang="ja">データが正常にロードされたときに送出されます。</span>
	 * <span lang="en">Dispatched when data has loaded successfully.</span>
	 * 
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event( name="complete", type="flash.events.Event" )]
	
	/**
	 * <span lang="ja">読み込まれたオブジェクトが SceneLoader オブジェクトの unload() メソッドを使用して削除されるたびに、SceneInfo オブジェクトによって送出されます。または 2 番目の読み込みが同じ SceneLoader オブジェクトによって実行され、読み込み開始前に元のコンテンツが削除された場合に、LSceneInfo オブジェクトによって送出されます。</span>
	 * <span lang="en">Dispatched by a SceneInfo object whenever a loaded object is removed by using the unload() method of the SceneLoader object, or when a second load is performed by the same SceneLoader object and the original content is removed prior to the load beginning.</span>
	 * 
	 * @eventType flash.events.Event.UNLOAD
	 */
	[Event( name="unload", type="flash.events.Event" )]
	
	/**
	 * <span lang="ja">ダウンロード処理を実行中にデータを受信したときに送出されます。</span>
	 * <span lang="en">Dispatched when data is received as the download operation progresses.</span>
	 * 
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 */
	[Event( name="progress", type="flash.events.ProgressEvent" )]
	
	/**
	 * <span lang="ja">ネットワーク要求が HTTP を介して行われ、HTTP ステータスコードを検出できる場合に送出されます。</span>
	 * <span lang="en">Dispatched when a network request is made over HTTP and an HTTP status code can be detected.</span>
	 * 
	 * @eventType flash.events.HTTPStatusEvent.HTTP_STATUS
	 */
	[Event( name="httpStatus", type="flash.events.HTTPStatusEvent" )]
	
	/**
	 * <span lang="ja">入出力エラーが発生して読み込み処理が失敗したときに送出されます。</span>
	 * <span lang="en">Dispatched when an input or output error occurs that causes a load operation to fail.</span>
	 * 
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event( name="ioError", type="flash.events.IOErrorEvent" )]
	
	
	/**
	 * <span lang="ja">SceneInfo クラスは、SceneObject インスタンスに関する情報を提供します。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public final class SceneInfo extends EventDispatcher {
		
		/**
		 * パッケージ内からの呼び出しかどうかを取得します。
		 */
		private static var _internallyCalled:Boolean = false;
		
		
		
		
		
		/**
		 * <span lang="ja">この SceneInfo オブジェクトに関係した読み込まれたオブジェクトです。</span>
		 * <span lang="en">The loaded object associated with this SceneInfo object.</span>
		 */
		public function get content():SceneObject { return _content; }
		private var _content:SceneObject;
		
		/**
		 * <span lang="ja">この SceneInfo オブジェクトに関係した SceneLoader オブジェクトです。</span>
		 * <span lang="en">The SceneLoader object associated with this SceneInfo object.</span>
		 */
		public function get loader():SceneLoader { return _loader; }
		private var _loader:SceneLoader;
		
		/**
		 * <span lang="ja">シーン移動時に渡させるクエリオブジェクトを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get query():Query {
			if ( _loader ) { return _loader.sceneInfo.query; }
			return _query;
		}
		private var _query:Query;
		
		/**
		 * @private
		 */
		progression_internal function get $query():Query { return _query; }
		progression_internal function set $query( value:Query ):void {
			_query = value;
			
			// イベントを送出する
			super.dispatchEvent( new SceneEvent( SceneEvent.SCENE_QUERY_CHANGE ) );
		}
		
		/**
		 * <span lang="ja">読み込み済みの SWF ファイルの ActionScript バージョンです。</span>
		 * <span lang="en">The ActionScript version of the loaded SWF file.</span>
		 */
		public function get actionScriptVersion():int { return _loaderInfo.actionScriptVersion; }
		
		/**
		 * <span lang="ja">外部 SWF ファイルが読み込まれると、読み込まれたクラスに含まれているすべての ActionScript 3.0 定義は applicationDomain プロパティに保持されます。</span>
		 * <span lang="en">When an external SWF file is loaded, all ActionScript 3.0 definitions contained in the loaded class are stored in the applicationDomain property.</span>
		 */
		public function get applicationDomain():ApplicationDomain { return _loaderInfo.applicationDomain; }
		
		/**
		 * <span lang="ja">そのメディアの読み込み済みのバイト数です。</span>
		 * <span lang="en">The number of bytes that are loaded for the media.</span>
		 */
		public function get bytesLoaded():int { return _loaderInfo.bytesLoaded; }
		
		/**
		 * <span lang="ja">メディアファイル全体の圧縮後のバイト数です。</span>
		 * <span lang="en">The number of compressed bytes in the entire media file.</span>
		 */
		public function get bytesTotal():int { return _loaderInfo.bytesTotal; }
		
		/**
		 * <span lang="ja">コンテンツ（子）から読み込む側（親）への信頼関係を表します。</span>
		 * <span lang="en">Expresses the trust relationship from content (child) to the Loader (parent).</span>
		 */
		public function get childAllowsParent():Boolean { return _loaderInfo.childAllowsParent; }
		
		/**
		 * <span lang="ja">読み込まれたファイルの MIME タイプです。</span>
		 * <span lang="en">The MIME type of the loaded file.</span>
		 */
		public function get contentType():String { return _loaderInfo.contentType; }
		
		/**
		 * <span lang="ja">読み込み済みの SWF ファイルに関する 1 秒ごとのフレーム数を表す公称のフレームレートです。</span>
		 * <span lang="en">The nominal frame rate, in frames per second, of the loaded SWF file.</span>
		 */
		public function get frameRate():Number { return _loaderInfo.frameRate; }
		
		/**
		 * <span lang="ja">この SceneInfo オブジェクトによって記述されるメディアの読み込みを開始した SWF ファイルの URL です。</span>
		 * <span lang="en">The URL of the SWF file that initiated the loading of the media described by this SceneInfo object.</span>
		 */
		public function get loaderURL():String { return _loaderInfo.loaderURL; }
		
		/**
		 * <span lang="ja">読み込む側（親）からコンテンツ（子）への信頼関係を表します。</span>
		 * <span lang="en">Expresses the trust relationship from Loader (parent) to the content (child).</span>
		 */
		public function get parentAllowsChild():Boolean { return _loaderInfo.parentAllowsChild; }
		
		/**
		 * <span lang="ja">ロード済みの SWF ファイルに提供されるパラメータを表す、名前と値の組を含んだオブジェクトです。</span>
		 * <span lang="en">An object that contains name-value pairs that represent the parameters provided to the loaded SWF file.</span>
		 */
		public function get parameters():Object { return _loaderInfo.parameters; }
		
		/**
		 * <span lang="ja">ロードする側とそのコンテンツの間のドメインの関係を次のように表します。ドメインが同じ場合は true、異なる場合は false です。</span>
		 * <span lang="en">Expresses the domain relationship between the loader and the content: true if they have the same origin domain; false otherwise.</span>
		 */
		public function get sameDomain():Boolean { return _loaderInfo.sameDomain; }
		
		/**
		 * <span lang="ja">読み込み済みの SWF ファイルのファイル形式のバージョンです。</span>
		 * <span lang="en">The file format version of the loaded SWF file.</span>
		 */
		public function get swfVersion():int { return _loaderInfo.swfVersion; }
		
		/**
		 * <span lang="ja">読み込まれるメディアの URL です。</span>
		 * <span lang="en">The URL of the media being loaded.</span>
		 */
		public function get url():String { return _loaderInfo.url; }
		
		/**
		 * LoaderInfo インスタンスを取得します。
		 */
		private var _loaderInfo:LoaderInfo;
		
		/**
		 * ドキュメントインスタンスを取得します。
		 */
		private var _document:*;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい SceneInfo インスタンスを作成します。</span>
		 * <span lang="en">Creates a new SceneInfo object.</span>
		 */
		public function SceneInfo() {
			// クラスをコンパイルに含める
			progression_internal;
			
			// パッケージ外から呼び出されたら例外をスローする
			if ( !_internallyCalled ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_008 ).toString( "SceneInfo" ) ); };
			
			// Query を作成する
			_query = new Query( null, true );
			
			// 初期化する
			_internallyCalled = false;
		}
		
		
		
		
		
		/**
		 * @private
		 */
		progression_internal static function $createInstance( content:SceneObject, loader:SceneLoader, loaderInfo:LoaderInfo ):SceneInfo {
			_internallyCalled = true;
			
			// SceneInfo を作成する
			var sceneInfo:SceneInfo = new SceneInfo();
			sceneInfo._content = content;
			sceneInfo._loader = loader;
			sceneInfo._loaderInfo = loaderInfo;
			
			// イベントリスナーを登録する
			loaderInfo.addEventListener( Event.OPEN, sceneInfo._open );
			loaderInfo.addEventListener( Event.INIT, sceneInfo._init );
			loaderInfo.addEventListener( Event.COMPLETE, sceneInfo._complete );
			loaderInfo.addEventListener( Event.UNLOAD, sceneInfo._unload );
			loaderInfo.addEventListener( ProgressEvent.PROGRESS, sceneInfo._progress );
			loaderInfo.addEventListener( HTTPStatusEvent.HTTP_STATUS, sceneInfo._httpStatus );
			loaderInfo.addEventListener( IOErrorEvent.IO_ERROR, sceneInfo._ioError );
			
			return sceneInfo;
		}
		
		
		
		
		
		/**
		 * @private
		 */
		progression_internal function $dispose():void {
			// イベントリスナーを解除する
			_loaderInfo.removeEventListener( Event.OPEN, _open );
			_loaderInfo.removeEventListener( Event.INIT, _init );
			_loaderInfo.removeEventListener( Event.COMPLETE, _complete );
			_loaderInfo.removeEventListener( Event.UNLOAD, _unload );
			_loaderInfo.removeEventListener( ProgressEvent.PROGRESS, _progress );
			_loaderInfo.removeEventListener( HTTPStatusEvent.HTTP_STATUS, _httpStatus );
			_loaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, _ioError );
			
			// 破棄する
			_content = null;
			_loader = null;
			_loaderInfo = null;
			_query = null;
		}
		
		/**
		 * @private
		 */
		override public function dispatchEvent( event:Event ):Boolean {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "dispatchEvent" ) );
		}
		
		
		
		
		
		/**
		 * 読み込み操作が開始したときに送出されます。
		 */
		private function _open( e:Event ):void {
			// イベントを送出する
			super.dispatchEvent( e );
		}
		
		/**
		 * ロードされた SWF ファイルのプロパティおよびメソッドがアクセス可能で使用できる状態の場合に送出されます。
		 */
		private function _init( e:Event ):void {
			// イベントを送出する
			super.dispatchEvent( e );
		}
		
		/**
		 * データが正常にロードされたときに送出されます。
		 */
		private function _complete( e:Event ):void {
			// ドキュメントを取得する
			if ( _loaderInfo.content && "__progressionCurrentLoader__" in _loaderInfo.content ) {
				_document = _loaderInfo.content["__progressionCurrentLoader__"];
			}
			else {
				_document = _loaderInfo.content as CastDocument;
			}
			
			// 初期化する
			if ( _document is CastDocument ) {
				// イベントを実行する
				_managerActivate( null );
			}
			else if ( _document ) {
				// イベントリスナーを登録する
				_document.addEventListener( ManagerEvent.MANAGER_ACTIVATE, _managerActivate );
			}
			else {
				// イベントを送出する
				super.dispatchEvent( new IOErrorEvent( IOErrorEvent.IO_ERROR, false, false, Logger.getLog( L10NProgressionMsg.getInstance().ERROR_016 ).toString() ) );
			}
		}
		
		/**
		 * キャストオブジェクトと Progression インスタンスの関連付けがアクティブになったときに送出されます。
		 */
		private function _managerActivate( e:ManagerEvent ):void {
			// イベントリスナーを破棄する
			_document.removeEventListener( ManagerEvent.MANAGER_ACTIVATE, _managerActivate );
			
			// プロパティを初期化する
			_content = _document.manager.root.sceneInfo.content;
			_loader = _document.manager.root.sceneInfo.loader;
			
			// イベントを送出する
			super.dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		/**
		 * 読み込まれたオブジェクトが SceneLoader オブジェクトの unload() メソッドを使用して削除されるたびに、SceneInfo オブジェクトによって送出されます。または 2 番目の読み込みが同じ SceneLoader オブジェクトによって実行され、読み込み開始前に元のコンテンツが削除された場合に、LSceneInfo オブジェクトによって送出されます。<
		 */
		private function _unload( e:Event ):void {
			// 破棄する
			_document = null;
			_content = null;
			_loader = null;
			
			// イベントを送出する
			super.dispatchEvent( e );
		}
		
		/**
		 * ダウンロード処理を実行中にデータを受信したときに送出されます。
		 */
		private function _progress( e:ProgressEvent ):void {
			// イベントを送出する
			super.dispatchEvent( e );
		}
		
		/**
		 * ネットワーク要求が HTTP を介して行われ、HTTP ステータスコードを検出できる場合に送出されます。
		 */
		private function _httpStatus( e:HTTPStatusEvent ):void {
			// イベントを送出する
			super.dispatchEvent( e );
		}
		
		/**
		 * 入出力エラーが発生して読み込み処理が失敗したときに送出されます。
		 */
		private function _ioError( e:IOErrorEvent ):void {
			// イベントを送出する
			super.dispatchEvent( e );
		}
	}
}
