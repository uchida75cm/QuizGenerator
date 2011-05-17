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
package jp.progression.commands.net {
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.commands.Command;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.data.Resource;
	
	/**
	 * <span lang="ja">ダウンロード処理を実行中にデータを受信したときに送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 */
	[Event( name="progress", type="flash.events.ProgressEvent" )]
	
	/**
	 * <span lang="ja">LoadCommand クラスは、読み込み処理が実装される全てのコマンドの基本となるクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // LoadCommand インスタンスを作成する
	 * var com:LoadCommand = new LoadCommand();
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * </listing>
	 */
	public class LoadCommand extends Command implements ILoadable {
		
		/**
		 * <span lang="ja">cacheAsResource プロパティの初期値を取得または設定します。
		 * すでに生成済みのコマンドに対しては適用されません。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #cacheAsResource
		 */
		public static function get defaultCacheAsResource():Boolean { return _defaultCacheAsResource; }
		public static function set defaultCacheAsResource( value:Boolean ):void { _defaultCacheAsResource = value; }
		private static var _defaultCacheAsResource:Boolean = true;
		
		/**
		 * <span lang="ja">preventCache プロパティの初期値を取得または設定します。
		 * すでに生成済みのコマンドに対しては適用されません。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #preventCache
		 */
		public static function get defaultPreventCache():Boolean { return _defaultPreventCache; }
		public static function set defaultPreventCache( value:Boolean ):void { _defaultPreventCache = value; }
		private static var _defaultPreventCache:Boolean = false;
		
		
		
		
		
		/**
		 * <span lang="ja">リクエストされる URL を示すストリングを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get url():String { return _request ? _request.url : null; }
		
		/**
		 * <span lang="ja">リクエストされる URL です。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en">The URL to be requested.
		 * </span>
		 */
		public function get request():URLRequest { return _request; }
		public function set request( value:URLRequest ):void { _request = value; }
		private var _request:URLRequest;
		
		/**
		 * <span lang="ja">読み込んだデータを Resource として登録する際に使用したい識別子を取得または設定します。
		 * cacheAsResource プロパティが true で、かつこの値が設定されていなければ、自動的に URL を識別子として登録します。</span>
		 * <span lang="en"></span>
		 */
		public function get resId():String { return _resId; }
		public function set resId( value:String ):void { _resId = value; }
		private var _resId:String;
		
		/**
		 * <span lang="ja">読み込んだデータを Resource として登録する際に使用したいグループ名を取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public function get resGroup():String { return _resGroup; }
		public function set resGroup( value:String ):void { _resGroup = value; }
		private var _resGroup:String;
		
		/**
		 * <span lang="ja">読み込まれたデータを自動的に Resource として管理するかどうかを取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #defaultCacheAsResource
		 */
		public function get cacheAsResource():Boolean { return _cacheAsResource; }
		public function set cacheAsResource( value:Boolean ):void { _cacheAsResource = value; }
		private var _cacheAsResource:Boolean = true;
		
		/**
		 * <span lang="ja">すでに Resource として登録されているデータを読み込む際に、既存のデータを破棄し、新たなリクエストを行う場合にランダムな引数を付加するかどうかを取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #defaultPreventCache
		 */
		public function get preventCache():Boolean { return _preventCache; }
		public function set preventCache( value:Boolean ):void { _preventCache = value; }
		private var _preventCache:Boolean = false;
		
		/**
		 * <span lang="ja">自身から見て最後に関連付けられた読み込みデータを取得または設定します。
		 * このコマンドインスタンスが CommandList インスタンス上に存在する場合には、自身より前、または自身の親のデータを取得します。</span>
		 * <span lang="en"></span>
		 */
		override public function get latestData():* { return _data; }
		override public function set latestData( value:* ):void {}
		
		/**
		 * <span lang="ja">読み込み操作によって受信したデータです。</span>
		 * <span lang="en">The data received from the load operation.</span>
		 */
		public function get data():* { return _data; }
		public function set data( value:* ):void { _data = value; }
		private var _data:*;
		
		/**
		 * <span lang="ja">読み込まれたデータを ByteArray 形式で取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get bytes():ByteArray { return _bytes; }
		public function set bytes( value:ByteArray ):void { _bytes = value; }
		private var _bytes:ByteArray;
		
		/**
		 * <span lang="ja">現在の読み込み対象を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get target():ILoadable { return this; }
		
		/**
		 * <span lang="ja">percent プロパティの算出時の自身の重要性を取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #percent
		 */
		public function get factor():Number { return _factor; }
		public function set factor( value:Number ):void { _factor = value; }
		private var _factor:Number = 1.0;
		
		/**
		 * <span lang="ja">loaded プロパティと total プロパティから算出される読み込み状態をパーセントで取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #factor
		 * @see #loaded
		 * @see #total
		 */
		public function get percent():Number { return _bytesTotal ? _bytesLoaded / _bytesTotal * 100 : 0; }
		
		/**
		 * <span lang="ja">登録されている ILoadable を実装したインスタンスの内、すでに読み込み処理が完了した数を取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #total
		 */
		public function get loaded():uint { return _loaded; }
		private var _loaded:uint = 0;
		
		/**
		 * <span lang="ja">登録されている ILoadable を実装したインスタンスの総数を取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #loaded
		 */
		public function get total():uint { return 1; }
		
		/**
		 * <span lang="ja">コマンドの読み込み済みのバイト数です。</span>
		 * <span lang="en">The number of bytes that are loaded for the command.</span>
		 * 
		 * @see #bytesTotal
		 */
		public function get bytesLoaded():uint { return _bytesLoaded; }
		private var _bytesLoaded:uint = 0;
		
		/**
		 * <span lang="ja">コマンド全体の圧縮後のバイト数です。</span>
		 * <span lang="en">The number of compressed bytes in the entire command.</span>
		 * 
		 * @see #bytesLoaded
		 */
		public function get bytesTotal():uint { return _bytesTotal; }
		private var _bytesTotal:uint = 0;
		
		/**
		 * <span lang="ja">コマンドオブジェクトが ProgressEvent.PROGRESS イベントを受け取った場合に呼び出されるイベントハンドラメソッドを取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #scope
		 * @see flash.events.ProgressEvent#PROGRESS
		 */
		public function get onProgress():Function { return _onProgress; }
		public function set onProgress( value:Function ):void { _onProgress = value; }
		private var _onProgress:Function;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい LoadCommand インスタンスを作成します。</span>
		 * <span lang="en">Creates a new LoadCommand object.</span>
		 * 
		 * @param request
		 * <span lang="ja">ダウンロードする URL を指定する URLRequest オブジェクトです。</span>
		 * <span lang="en">A URLRequest object specifying the URL to download.</span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function LoadCommand( request:URLRequest, initObject:Object = null ) {
			// クラスをコンパイルに含める
			progression_internal;
			
			// 引数を設定する
			_request = request;
			
			// 初期化する
			_cacheAsResource = _defaultCacheAsResource;
			_preventCache = _defaultPreventCache;
			
			// 親クラスを初期化する
			super( _executeFunction, _interruptFunction, initObject );
			
			// 継承せずにインスタンスを生成しようとしたら例外をスローする
			if ( Object( this ).constructor == LoadCommand ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( super.className ) ); }
			
			// initObject が LoadCommand であれば
			var com:LoadCommand = initObject as LoadCommand;
			if ( com ) {
				// 特定のプロパティを継承する
				_resId = com._resId;
				_resGroup = com._resGroup;
				_cacheAsResource = com._cacheAsResource;
				_preventCache = com._preventCache;
				_factor = com._factor;
				_onProgress = com._onProgress;
			}
		}
		
		
		
		
		
		/**
		 * 実行されるコマンドの実装です。
		 */
		private function _executeFunction():void {
			// 初期化する
			_data = null;
			_bytes = null;
			_loaded = 0;
			_bytesLoaded = 0;
			_bytesTotal = 0;
			
			// キャッシュを破棄するのであれば
			if ( _preventCache ) {
				// キャッシュを取得する
				var cache:Resource = Resource.progression_internal::$collection.getInstanceById( _resId || _request.url ) as Resource;
				
				if ( cache ) {
					cache.dispose();
					cache = null;
				}
			}
			
			// イベントリスナーを登録する
			super.addEventListener( ProgressEvent.PROGRESS, _progress, false, int.MAX_VALUE );
			
			// この実装を実行する
			executeFunction();
		}
		
		/**
		 * @private
		 */
		protected function executeFunction():void {
		}
		
		/**
		 * 中断実行されるコマンドの実装です。
		 */
		private function _interruptFunction():void {
			// 初期化する
			_data = null;
			_bytes = null;
			_loaded = 0;
			_bytesLoaded = 0;
			_bytesTotal = 0;
			
			// イベントリスナーを解除する
			super.removeEventListener( ProgressEvent.PROGRESS, _progress );
			
			// この実装を実行する
			interruptFunction();
		}
		
		/**
		 * @private
		 */
		protected function interruptFunction():void {
		}
		
		/**
		 * <span lang="ja">実行中のコマンド処理が完了したことを通知します。
		 * このメソッドを実行するためには、事前に execute() メソッドが実行されている必要があります。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #state
		 * @see #interrupt()
		 */
		override public function executeComplete():void {
			// 読み込み完了状態にする
			_loaded = 1;
			
			// イベントリスナーを解除する
			super.removeEventListener( ProgressEvent.PROGRESS, _progress );
			
			// リソースとしてキャッシュするのであれば
			if ( _cacheAsResource && _data ) {
				new Resource( _resId || _request.url, _data, _bytes, _bytesTotal, { group:_resGroup } );
			}
			
			// 親のメソッドを実行する
			super.executeComplete();
		}
		
		/**
		 * @private
		 */
		protected function toProperRequest( request:URLRequest ):URLRequest {
			// キャッシュを破棄しないであれば、そのまま返す
			if ( !_preventCache ) { return request; }
			
			switch ( Security.sandboxType ) {
				case Security.REMOTE				: { break; }
				case Security.LOCAL_TRUSTED			:
				case Security.LOCAL_WITH_FILE		:
				case Security.LOCAL_WITH_NETWORK	: {
					if ( !new RegExp( "^https?://" ).test( request.url ) ) { return request; }
					break;
				}
			}
			
			// 複製を作成する
			var newRequest:URLRequest = new URLRequest();
			newRequest.contentType = request.contentType;
			newRequest.method = request.method;
			newRequest.requestHeaders = request.requestHeaders;
			newRequest.url = request.url;
			
			if ( request.data is URLVariables ) {
				newRequest.data = new URLVariables( request.data.toString() );
			}
			else {
				newRequest.data = newRequest.data;
			}
			
			// ランダムな GET 値を追加する
			var preventCache:String = new Date().getTime() + "" + Math.round( Math.random() * 1000 );
			switch ( newRequest.method ) {
				case URLRequestMethod.GET	: {
					newRequest.data ||= new URLVariables();
					newRequest.data.preventCache = preventCache;
					break;
				}
				case URLRequestMethod.POST	: {
					if ( newRequest.url.indexOf( "?" ) > -1 ) {
						newRequest.url += "&";
					}
					else {
						newRequest.url += "?";
					}
					
					newRequest.url += "nocache=" + preventCache;
					break;
				}
			}
			
			return newRequest;
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 親のメソッドを実行する
			super.dispose();
			
			_request = null;
			_resId = null;
			_resGroup = null;
			_data = null;
			_bytes = null;
			_onProgress = null;
		}
		
		/**
		 * <span lang="ja">LoadCommand インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an LoadCommand subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい LoadCommand インスタンスです。</span>
		 * <span lang="en">A new LoadCommand object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new LoadCommand( _request, this );
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
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "url", "factor" );
		}
		
		
		
		
		
		/**
		 * ダウンロード処理を実行中にデータを受信したときに送出されます。
		 */
		private function _progress( e:ProgressEvent ):void {
			// 経過を保存する
			_bytesLoaded = e.bytesLoaded;
			_bytesTotal = e.bytesTotal;
			
			// イベントハンドラメソッドを実行する
			if ( _onProgress != null ) {
				_onProgress.apply( super.scope || this );
			}
		}
	}
}
