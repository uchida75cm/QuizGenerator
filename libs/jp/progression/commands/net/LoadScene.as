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
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	import jp.nium.core.ns.nium_internal;
	import jp.nium.display.ExMovieClip;
	import jp.progression.commands.Command;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.data.Resource;
	import jp.progression.scenes.SceneLoader;
	
	/**
	 * <span lang="ja">LoadScene クラスは、SceneLoader を使用した SWF ファイルの読み込み操作を行うコマンドクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // LoadScene インスタンスを作成する
	 * var com:LoadScene = new LoadScene();
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * </listing>
	 */
	public class LoadScene extends LoadCommand {
		
		/**
		 * <span lang="ja">読み込み処理に使用する SceneLoader インスタンスを取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get loader():SceneLoader { return _loader; }
		public function set loader( value:SceneLoader ):void { _loader = value; }
		private var _loader:SceneLoader;
		
		/**
		 * <span lang="ja">読み込まれた SWF ファイル内に作成される SceneObject インスタンスの container プロパティの値を取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get loaderContainer():* { return _loaderContainer; }
		public function set loaderContainer( value:* ):void { _loaderContainer = value; }
		private var _loaderContainer:*;
		
		/**
		 * <span lang="ja">オブジェクトをロードする前に、Flash Player がクロスドメインポリシーファイルの存在を確認するかどうかを取得または設定します。
		 * ただし、読み込み処理が開始された以降は設定を変更することはできません。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get checkPolicyFile():Boolean { return _checkPolicyFile; }
		public function set checkPolicyFile( value:Boolean ):void { _checkPolicyFile = value; }
		private var _checkPolicyFile:Boolean = false;
		
		/**
		 * <span lang="ja">Loader オブジェクトで使用する SecurityDomain オブジェクトを取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get securityDomain():SecurityDomain { return _securityDomain; }
		public function set securityDomain( value:SecurityDomain ):void { _securityDomain = value; }
		private var _securityDomain:SecurityDomain;
		
		/**
		 * URLLoader インスタンスを取得します。
		 */
		private var _urlloader:URLLoader;
		
		/**
		 * Sprite インスタンスを取得します。
		 */
		private var _container:Sprite;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい LoadScene インスタンスを作成します。</span>
		 * <span lang="en">Creates a new LoadScene object.</span>
		 * 
		 * @param request
		 * <span lang="ja">読み込みたい SWF ファイルの絶対 URL または相対 URL です。</span>
		 * <span lang="en"></span>
		 * @param loader
		 * <span lang="ja">読み込み処理に使用する SceneLoader インスタンスです。</span>
		 * <span lang="en"></span>
		 * @param loaderContainer
		 * <span lang="ja">読み込まれた SWF ファイルの表示オブジェクトの基準となる Sprite インスタンス、またはインスタンスを示す識別子です。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function LoadScene( request:URLRequest, loader:SceneLoader = null, loaderContainerRefOrId:* = null, initObject:Object = null ) {
			// クラスをコンパイルに含める
			nium_internal;
			progression_internal;
			
			// 引数を設定する
			_loader = loader;
			_loaderContainer = loaderContainerRefOrId;
			
			// 親クラスを初期化する
			super( request, initObject );
			
			// initObject が LoadScene であれば
			var com:LoadScene = initObject as LoadScene;
			if ( com ) {
				// 特定のプロパティを継承する
				_checkPolicyFile = com._checkPolicyFile;
				_securityDomain = com._securityDomain;
			}
		}
		
		
		
		
		
		/**
		 * @private
		 */
		override protected function executeFunction():void {
			// 参照を取得する
			switch ( true ) {
				case _loaderContainer is Sprite		: { _container = Sprite( _loaderContainer ); break; }
				case _loaderContainer is String		: { _container = ExMovieClip.nium_internal::$collection.getInstanceById( _loaderContainer ) as Sprite; break; }
			}
			
			// キャッシュを取得する
			var cache:Resource = Resource.progression_internal::$collection.getInstanceById( super.resId || super.request.url ) as Resource;
			
			// キャッシュを破棄するのであれば
			if ( super.preventCache && cache is Resource && cache.data ) {
				var loader:SceneLoader = cache.data as SceneLoader;
				
				if ( loader ) {
					loader.unload();
				}
				
				cache.dispose();
				cache = null;
			}
			
			// キャッシュが存在すれば
			if ( cache is Resource ) {
				if ( _loader ) {
					// 既存のデータを破棄する
					loader = cache.data as SceneLoader;
					if ( loader ) {
						loader.unload();
					}
					
					// データを保持する
					super.bytes = cache.bytes;
					
					// イベントリスナーを登録する
					_loader.contentSceneInfo.addEventListener( Event.COMPLETE, __complete );
					_loader.contentSceneInfo.addEventListener( IOErrorEvent.IO_ERROR, _ioError );
					_loader.contentSceneInfo.addEventListener( ProgressEvent.PROGRESS, super.dispatchEvent );
					
					// データを読み込む
					_loader.loadBytes( super.bytes, _container, _checkPolicyFile, _securityDomain );
				}
				else {
					// データを保持する
					super.data = cache.data;
					super.bytes = cache.bytes;
					
					// イベントを送出する
					super.dispatchEvent( new ProgressEvent( ProgressEvent.PROGRESS, false, false, cache.bytesTotal, cache.bytesTotal ) );
					
					// 処理を終了する
					super.executeComplete();
				}
			}
			else {
				// SceneLoader を作成する
				_loader ||= new SceneLoader();
				
				// URLLoader を作成する
				_urlloader = new URLLoader();
				_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
				
				// イベントリスナーを登録する
				_urlloader.addEventListener( Event.COMPLETE, _complete );
				_urlloader.addEventListener( IOErrorEvent.IO_ERROR, _ioError );
				_urlloader.addEventListener( ProgressEvent.PROGRESS, super.dispatchEvent );
				
				// ファイルを読み込む
				_urlloader.load( toProperRequest( super.request ) );
			}
		}
		
		/**
		 * @private
		 */
		override protected function interruptFunction():void {
			// 読み込みを閉じる
			try {
				_loader.close();
			}
			catch ( err:Error ) {}
			
			// 破棄する
			_destroy();
		}
		
		/**
		 * 破棄します。
		 */
		private function _destroy():void {
			if ( _urlloader ) {
				// イベントリスナーを解除する
				_urlloader.removeEventListener( Event.COMPLETE, _complete );
				_urlloader.removeEventListener( IOErrorEvent.IO_ERROR, _ioError );
				_urlloader.removeEventListener( ProgressEvent.PROGRESS, super.dispatchEvent );
				
				// 破棄する
				_urlloader = null;
			}
			
			if ( _loader ) {
				// イベントリスナーを解除する
				_loader.contentSceneInfo.removeEventListener( Event.COMPLETE, __complete );
				_loader.contentSceneInfo.removeEventListener( IOErrorEvent.IO_ERROR, _ioError );
				_loader.contentSceneInfo.removeEventListener( ProgressEvent.PROGRESS, super.dispatchEvent );
			}
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 親のメソッドを実行する
			super.dispose();
			
			_loader = null;
			_loaderContainer = null;
			_checkPolicyFile = false;
			_securityDomain = null;
		}
		
		/**
		 * <span lang="ja">LoadScene インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an LoadScene subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい LoadScene インスタンスです。</span>
		 * <span lang="en">A new LoadScene object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new LoadScene( super.request, _loader, _loaderContainer, this );
		}
		
		
		
		
		
		/**
		 * データが正常にロードされたときに送出されます。
		 */
		private function _complete( e:Event ):void {
			// データを保持する
			super.bytes = _urlloader.data as ByteArray;
			
			// 破棄する
			_destroy();
			
			// イベントリスナーを登録する
			_loader.contentSceneInfo.addEventListener( Event.COMPLETE, __complete );
			_loader.contentSceneInfo.addEventListener( IOErrorEvent.IO_ERROR, _ioError );
			
			// データを読み込む
			_loader.loadBytes( super.bytes, _container, _checkPolicyFile, _securityDomain );
		}
		
		/**
		 * データが正常にロードされたときに送出されます。
		 */
		private function __complete( e:Event ):void {
			// イベントリスナーを解除する
			_loader.contentSceneInfo.removeEventListener( Event.COMPLETE, __complete );
			_loader.contentSceneInfo.removeEventListener( IOErrorEvent.IO_ERROR, _ioError );
			_loader.contentSceneInfo.removeEventListener( ProgressEvent.PROGRESS, super.dispatchEvent );
			
			// データを保持する
			super.data = _loader;
			
			// 処理を終了する
			super.executeComplete();
		}
		
		/**
		 * 入出力エラーが発生してロード処理が失敗したときに送出されます。
		 */
		private function _ioError( e:IOErrorEvent ):void {
			// エラー処理を実行する
			super.throwError( this, new IOError( e.text ) );
		}
	}
}
