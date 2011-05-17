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
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.progression.casts.CastPreloader;
	import jp.progression.commands.Command;
	
	/**
	 * <span lang="ja">ダウンロード処理を実行中にデータを受信したときに送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 */
	[Event( name="progress", type="flash.events.ProgressEvent" )]
	
	/**
	 * <span lang="ja">PreloadSWF クラスは、CastPreloader クラスの読み込みタイミングを任意の位置に指定し、LoaderList コマンドで監視可能にするコマンドクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // CastPreloader クラスのサブクラスの CastEvent.CAST_LOAD_START 発生中に登録する
	 * protected override function atCastLoadStart():void {
	 * 	// コマンドを登録する
	 * 	addCommand(
	 * 		new Trace( "start" ),
	 * 		new LoaderList( {
	 * 				// 読み込み進捗状態を取得する
	 * 				onProgress:function():void {
	 * 					trace( this.bytesLoaded, this.bytesTotal );
	 * 				}
	 * 			},
	 * 			
	 * 			// 本体となる index.swf をこのタイミングで読み込み、親の LoaderList で監視する
	 * 			new PreloadSWF(),
	 * 			
	 * 			// index.swf と同時に読み込み管理したい対象を設定する
	 * 			new LoadURL( new URLRequest( "example.xml" ) ),
	 * 			new LoadBitmapData( new URLRequest( "example.png" ) )
	 * 		),
	 * 		new Trace( "complete" )
	 * 	);
	 * }
	 * </listing>
	 */
	public class PreloadSWF extends Command implements ILoadable {
		
		/**
		 * CastPreloader インスタンスを取得します。
		 */
		private var _loader:CastPreloader;
		
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
		 * <span lang="ja">読み込み操作によって受信したデータです。</span>
		 * <span lang="en">The data received from the load operation.</span>
		 */
		public function get data():* { return _data; }
		public function set data( value:* ):void { _data = value; }
		private var _data:*;
		
		/**
		 * @private
		 */
		public function get bytes():ByteArray { return null; }
		public function set bytes( value:ByteArray ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "bytes" ) ); }
		
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
		 * <span lang="ja">新しい PreloadSWF インスタンスを作成します。</span>
		 * <span lang="en">Creates a new PreloadSWF object.</span>
		 * 
		 * @param request
		 * <span lang="ja">読み込む SWF ファイルの絶対 URL または相対 URL です。</span>
		 * <span lang="en">The absolute or relative URL of the SWF file to be loaded.</span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function PreloadSWF( request:URLRequest = null, initObject:Object = null ) {
			// 引数を設定する
			_request = request;
			
			// 親クラスを初期化する
			super( _executeFunction, _interruptFunction, initObject );
		}
		
		
		
		
		
		/**
		 * 実行されるコマンドの実装です。
		 */
		private function _executeFunction():void {
			// 初期化する
			_loaded = 0;
			_bytesLoaded = 0;
			_bytesTotal = 0;
			
			// CastPreloader を取得する
			_loader = CastPreloader.root;
			
			// イベントリスナーを登録する
			super.addEventListener( ProgressEvent.PROGRESS, _progress, false, int.MAX_VALUE );
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, _complete );
			_loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, super.dispatchEvent );
			
			// 読み込み処理を開始する
			_loader.load( _request || _loader.request );
		}
		
		/**
		 * 中断実行されるコマンドの実装です。
		 */
		private function _interruptFunction():void {
			if ( _loader ) {
				// イベントリスナーを解除する
				_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, _complete );
				_loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, super.dispatchEvent );
				
				// 破棄する
				_loader = null;
			}
			
			// イベントリスナーを解除する
			super.removeEventListener( ProgressEvent.PROGRESS, _progress );
			
			// 初期化する
			_loaded = 0;
			_bytesLoaded = 0;
			_bytesTotal = 0;
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 親のメソッドを実行する
			super.dispose();
			
			_request = null;
			_onProgress = null;
		}
		
		/**
		 * <span lang="ja">PreloadSWF インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an PreloadSWF subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい PreloadSWF インスタンスです。</span>
		 * <span lang="en">A new PreloadSWF object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new PreloadSWF( _request, this );
		}
		
		
		
		
		
		/**
		 * 
		 */
		private function _complete( e:Event ):void {
			// イベントリスナーを解除する
			super.removeEventListener( ProgressEvent.PROGRESS, _progress );
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, _complete );
			_loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, super.dispatchEvent );
			
			// 破棄する
			_loader = null;
			
			// 処理を終了する
			super.executeComplete();
		}
		
		/**
		 * 
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
