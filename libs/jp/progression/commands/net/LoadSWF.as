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
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import jp.progression.commands.Command;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.data.Resource;
	
	/**
	 * <span lang="ja">LoadSound クラスは、指定された SWF ファイルの読み込み操作を行うコマンドクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // LoadSWF インスタンスを作成する
	 * var com:LoadSWF = new LoadSWF();
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * </listing>
	 */
	public class LoadSWF extends LoadCommand {
		
		/**
		 * <span lang="ja">読み込み処理に使用する Loader インスタンスを取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get loader():Loader { return _loader; }
		public function set loader( value:Loader ):void { _loader = value; }
		private var _loader:Loader;
		
		/**
		 * <span lang="ja">ポリシーファイルの存在の確認や、ApplicationDomain 及び SecurityDomain の設定を行う LoaderContext を取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get context():LoaderContext { return _context; }
		public function set context( value:LoaderContext ):void { _context = value; }
		private var _context:LoaderContext;
		
		/**
		 * URLLoader インスタンスを取得します。
		 */
		private var _urlloader:URLLoader;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい LoadSWF インスタンスを作成します。</span>
		 * <span lang="en">Creates a new LoadSWF object.</span>
		 * 
		 * @param request
		 * <span lang="ja">読み込みたい SWF、JPEG、GIF、または PNG ファイルの絶対 URL または相対 URL です。</span>
		 * <span lang="en"></span>
		 * @param loader
		 * <span lang="ja">読み込み処理に使用する Loader インスタンスです。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function LoadSWF( request:URLRequest, loader:Loader = null, initObject:Object = null ) {
			// クラスをコンパイルに含める
			progression_internal;
			
			// 引数を設定する
			_loader = loader;
			
			// 親クラスを初期化する
			super( request, initObject );
			
			// initObject が LoadSWF であれば
			var com:LoadSWF = initObject as LoadSWF;
			if ( com ) {
				// 特定のプロパティを継承する
				_loader = com._loader;
				_context = com._context;
			}
		}
		
		
		
		
		
		/**
		 * @private
		 */
		override protected function executeFunction():void {
			// キャッシュを取得する
			var cache:Resource = Resource.progression_internal::$collection.getInstanceById( super.resId || super.request.url ) as Resource;
			
			// キャッシュを破棄するのであれば
			if ( super.preventCache && cache is Resource && cache.data ) {
				var loader:Loader = cache.data as Loader;
				
				if ( loader ) {
					loader.unload();
				}
				
				cache.dispose();
				cache = null;
			}
			
			// キャッシュが存在すれば
			if ( cache is Resource ) {
				if ( _loader ) {
					// データを保持する
					super.bytes = cache.bytes;
					
					// イベントリスナーを登録する
					_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, __complete );
					_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, _ioError );
					_loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, super.dispatchEvent );
					
					// データを読み込む
					_loader.loadBytes( super.bytes, _context );
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
				// Loader を作成する
				_loader ||= new Loader();
				
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
				_urlloader.close();
			}
			catch ( err:Error ) {}
			
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
				_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, __complete );
				_loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, _ioError );
				_loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, super.dispatchEvent );
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
			_context = null;
		}
		
		/**
		 * <span lang="ja">LoadSWF インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an LoadSWF subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい LoadSWF インスタンスです。</span>
		 * <span lang="en">A new LoadSWF object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new LoadSWF( super.request, _loader, this );
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
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, __complete );
			_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, _ioError );
			
			// データを読み込む
			_loader.loadBytes( super.bytes, _context );
		}
		
		/**
		 * データが正常にロードされたときに送出されます。
		 */
		private function __complete( e:Event ):void {
			// イベントリスナーを解除する
			_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, __complete );
			_loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, _ioError );
			_loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, super.dispatchEvent );
			
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
