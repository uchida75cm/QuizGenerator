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
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import jp.progression.commands.Command;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.data.Resource;
	
	/**
	 * <span lang="ja">LoadSound クラスは、指定されたサウンドファイルの読み込み操作を行うコマンドクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // LoadSound インスタンスを作成する
	 * var com:LoadSound = new LoadSound();
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * </listing>
	 */
	public class LoadSound extends LoadCommand {
		
		/**
		 * <span lang="ja">ポリシーファイルの存在の確認や、ApplicationDomain 及び SecurityDomain の設定を行う LoaderContext を取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get context():SoundLoaderContext { return _context; }
		public function set context( value:SoundLoaderContext ):void { _context = value; }
		private var _context:SoundLoaderContext;
		
		/**
		 * Sound インスタンスを取得します。
		 */
		private var _sound:Sound;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい LoadSound インスタンスを作成します。</span>
		 * <span lang="en">Creates a new LoadSound object.</span>
		 * 
		 * @param request
		 * <span lang="ja">読み込む MP3 ファイルの絶対 URL または相対 URL を表す URLRequest インスタンスです。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function LoadSound( request:URLRequest, initObject:Object = null ) {
			// クラスをコンパイルに含める
			progression_internal;
			
			// 親クラスを初期化する
			super( request, initObject );
			
			// initObject が LoadSound であれば
			var com:LoadSound = initObject as LoadSound;
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
				// Sound を作成する
				_sound = new Sound();
				
				// イベントリスナーを登録する
				_sound.addEventListener( Event.COMPLETE, _complete );
				_sound.addEventListener( IOErrorEvent.IO_ERROR, _ioError );
				_sound.addEventListener( ProgressEvent.PROGRESS, super.dispatchEvent );
				
				// ファイルを読み込む
				_sound.load( toProperRequest( super.request ), _context );
			}
		}
		
		/**
		 * @private
		 */
		override protected function interruptFunction():void {
			// 読み込みを閉じる
			if ( _sound ) {
				_sound.close();
			}
			
			// 破棄する
			_destroy();
		}
		
		/**
		 * 破棄します。
		 */
		private function _destroy():void {
			if ( _sound ) {
				// イベントリスナーを解除する
				_sound.removeEventListener( Event.COMPLETE, _complete );
				_sound.removeEventListener( IOErrorEvent.IO_ERROR, _ioError );
				_sound.removeEventListener( ProgressEvent.PROGRESS, super.dispatchEvent );
				
				// 破棄する
				_sound = null;
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
		 * <span lang="ja">LoadSound インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an LoadSound subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい LoadSound インスタンスです。</span>
		 * <span lang="en">A new LoadSound object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new LoadSound( super.request, this );
		}
		
		
		
		
		
		/**
		 * データが正常にロードされたときに送出されます。
		 */
		private function _complete( e:Event ):void {
			// データを保持する
			super.data = _sound;
			
			// 破棄する
			_destroy();
			
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
