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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import jp.progression.commands.Command;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.data.Resource;
	
	/**
	 * <span lang="ja">LoadBitmapData クラスは、指定された画像ファイルの読み込み操作を行うコマンドクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // LoadBitmapData インスタンスを作成する
	 * var com:LoadBitmapData = new LoadBitmapData();
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * </listing>
	 */
	public class LoadBitmapData extends LoadCommand {
		
		/**
		 * <span lang="ja">ポリシーファイルの存在の確認や、ApplicationDomain 及び SecurityDomain の設定を行う LoaderContext を取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get context():LoaderContext { return _context; }
		public function set context( value:LoaderContext ):void { _context = value; }
		private var _context:LoaderContext;
		
		/**
		 * Loader を取得します。
		 */
		private var _loader:Loader;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい LoadBitmapData インスタンスを作成します。</span>
		 * <span lang="en">Creates a new LoadBitmapData object.</span>
		 * 
		 * @param request
		 * <span lang="ja">読み込みたい JPEG、GIF、または PNG ファイルの絶対 URL または相対 URL です。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function LoadBitmapData( request:URLRequest, initObject:Object = null ) {
			// クラスをコンパイルに含める
			progression_internal;
			
			// 親クラスを初期化する
			super( request, initObject );
			
			// initObject が LoadBitmapData であれば
			var com:LoadBitmapData = initObject as LoadBitmapData;
			if ( com ) {
				// 特定のプロパティを継承する
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
				var bmp:BitmapData = cache.data as BitmapData;
				
				if ( bmp ) {
					bmp.dispose();
				}
				
				cache.dispose();
				cache = null;
			}
			
			// キャッシュが存在すれば
			if ( cache is Resource ) {
				// データを保持する
				super.data = cache.data;
				
				// イベントを送出する
				super.dispatchEvent( new ProgressEvent( ProgressEvent.PROGRESS, false, false, cache.bytesTotal, cache.bytesTotal ) );
				
				// 処理を終了する
				super.executeComplete();
			}
			else {
				// Loader を作成する
				_loader = new Loader();
				
				// イベントリスナーを登録する
				_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, _complete );
				_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, _ioError );
				_loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, _securityError );
				_loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, super.dispatchEvent );
				
				// ファイルを読み込む
				_loader.load( toProperRequest( super.request ), _context );
			}
		}
		
		/**
		 * @private
		 */
		override protected function interruptFunction():void {
			// 読み込みを閉じる
			if ( _loader ) {
				_loader.close();
			}
			
			// 破棄する
			_destroy();
		}
		
		/**
		 * 破棄します。
		 */
		private function _destroy():void {
			if ( _loader ) {
				// イベントリスナーを解除する
				_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, _complete );
				_loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, _ioError );
				_loader.contentLoaderInfo.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, _securityError );
				_loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, super.dispatchEvent );
				
				// 破棄する
				_loader.unload();
				_loader = null;
			}
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 親のメソッドを実行する
			super.dispose();
			
			_context = null;
		}
		
		/**
		 * <span lang="ja">LoadBitmapData インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an LoadBitmapData subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい LoadBitmapData インスタンスです。</span>
		 * <span lang="en">A new LoadBitmapData object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new LoadBitmapData( super.request, this );
		}
		
		
		
		
		
		/**
		 * データが正常にロードされたときに送出されます。
		 */
		private function _complete( e:Event ):void {
			// 対象が Bitmap であれば
			try {
				// データを保持する
				super.data = Bitmap( _loader.content ).bitmapData;
			}
			catch ( err:Error ) {
				// データを破棄する
				super.data = null;
				
				// 破棄する
				_destroy();
				
				// エラー処理を実行する
				super.throwError( this, err.message );
				return;
			}
			
			// 破棄する
			_destroy();
			
			// 処理を終了する
			super.executeComplete();
		}
		
		/**
		 * 入出力エラーが発生してロード処理が失敗したときに送出されます。
		 */
		private function _ioError( e:IOErrorEvent ):void {
			// データを破棄する
			super.data = null;
			
			// 破棄する
			_destroy();
			
			// エラー処理を実行する
			super.throwError( this, new IOError( e.text ) );
		}
		
		/**
		 * 
		 */
		private function _securityError( e:SecurityErrorEvent ):void {
			// データを破棄する
			super.data = null;
			
			// 破棄する
			_destroy();
			
			// エラー処理を実行する
			super.throwError( this, new SecurityError( e.text ) );
		}
	}
}
