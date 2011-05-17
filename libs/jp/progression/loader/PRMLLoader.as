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
package jp.progression.loader {
	import flash.display.DisplayObjectContainer;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.core.ns.nium_internal;
	import jp.nium.core.primitives.StringObject;
	import jp.nium.utils.ClassUtil;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.Progression;
	import jp.progression.scenes.SceneObject;
	
	/**
	 * <span lang="ja">PRMLLoader クラスは、読み込んだ PRML 形式の XML ファイルから自動的に、Progression インスタンスを作成するローダークラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // PRMLLoader インスタンスを作成する
	 * var loader:PRMLLoader = new PRMLLoader();
	 * </listing>
	 */
	public class PRMLLoader extends URLLoader {
		
		
		
		
		
		/**
		 * <span lang="ja">インスタンスのクラス名を取得します。</span>
		 * <span lang="en">Indicates the instance className of the SceneObject.</span>
		 */
		public function get className():String { return _classNameObj ? _classNameObj.toString() : ClassUtil.nium_internal::$DEFAULT_CLASS_NAME; }
		private var _classNameObj:StringObject;
		
		/**
		 * <span lang="ja">リクエストされる URL を示すストリングを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get url():String { return _request ? _request.url : null; }
		private var _request:URLRequest;
		/**
		 * <span lang="ja">関連付けられている Progression インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see jp.progression.events.ManagerEvent#MANAGER_ACTIVATE
		 * @see jp.progression.events.ManagerEvent#MANAGER_DEACTIVATE
		 */
		public function get manager():Progression { return _manager; }
		private var _manager:Progression;
		
		/**
		 * <span lang="ja">関連付けられている DisplayObjectContainer インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get container():DisplayObjectContainer { return _container; }
		private var _container:DisplayObjectContainer;
		
		/**
		 * <span lang="ja">読み込み完了後に自動的にシーン移動を開始するかどうかを取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public function get autoGoto():Boolean { return _autoGoto; }
		public function set autoGoto( value:Boolean ):void { _autoGoto = value; }
		private var _autoGoto:Boolean = false;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい PRMLLoader インスタンスを作成します。</span>
		 * <span lang="en">Creates a new PRMLLoader object.</span>
		 * 
		 * @param container
		 * <span lang="ja">関連付けたい DisplayObjectContainer インスタンスです。</span>
		 * <span lang="en"></span>
		 * @param request
		 * <span lang="ja">ダウンロードする URL を指定する URLRequest オブジェクトです。このパラメータを省略すると、ロード操作は開始されません。指定すると、直ちにロード操作が開始されます。詳細については、load を参照してください。</span>
		 * <span lang="en">A URLRequest object specifying the URL to download.</span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function PRMLLoader( container:DisplayObjectContainer, request:URLRequest = null, initObject:Object = null ) {
			// クラスをコンパイルに含める
			nium_internal;
			progression_internal;
			SceneObject;
			
			// クラス名を取得する
			_classNameObj = ClassUtil.nium_internal::$getClassString( this );
			
			// 引数を設定する
			_container = container;
			_request = request;
			
			// 初期化する
			ObjectUtil.setProperties( this, initObject );
			
			// request が存在すれば読み込む
			if ( _request ) {
				load( _request );
			}
		}
		
		
		
		
		
		/**
		 * <span lang="ja">指定された URL からデータを送信およびロードします。</span>
		 * <span lang="en">Sends and loads data from the specified URL.</span>
		 * 
		 * @param request
		 * <span lang="ja">ダウンロードする URL を指定する URLRequest オブジェクトです。</span>
		 * <span lang="en">A URLRequest object specifying the URL to download.</span>
		 */
		override public function load( request:URLRequest ):void {
			_request = request;
			
			// すでに Progression が生成されていれば
			if ( _manager ) {
				_manager.progression_internal::$dispose();
				_manager = null;
			}
			
			// イベントリスナーを登録する
			super.addEventListener( Event.COMPLETE, _complete, false, int.MAX_VALUE );
			super.addEventListener( IOErrorEvent.IO_ERROR, _ioError, false, int.MAX_VALUE );
			
			// 親のメソッドを実行する
			super.load( request );
		}
		
		/**
		 * <span lang="ja">進行中のロード操作は直ちに終了します。</span>
		 * <span lang="en">Closes the load operation in progress.</span>
		 */
		override public function close():void {
			// 破棄する
			_request = null;
			
			// 読み込みを閉じる
			super.close();
		}
		
		/**
		 * <span lang="ja">XML データから Progression インスタンスを作成します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param prml
		 * <span lang="ja">生成に使用する XML データです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">生成された Progression インスタンスです。</span>
		 * <span lang="en"></span>
		 */
		public function parse( prml:XML ):Progression {
			// cls が省略されていれば SceneObject を設定する
			for each ( var scene:XML in prml..scene ) {
				var cls:String = scene.@cls;
				
				if ( cls ) { continue; }
				
				scene.@cls = "jp.progression.scenes.SceneObject";
			}
			
			// XML の構文が間違っていれば例外をスローする
			if ( !SceneObject.validate( prml ) ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_016 ).toString( "XML" ) ); }
			
			return Progression.createFromXML( _container, prml );
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
			return ObjectUtil.formatToString( this, _classNameObj.toString(), "url", "autoGoto" );
		}
		
		
		
		
		
		/**
		 * データが正常にロードされたときに送出されます。
		 */
		private function _complete( e:Event ):void {
			// イベントリスナーを解除する
			super.removeEventListener( Event.COMPLETE, _complete );
			super.removeEventListener( IOErrorEvent.IO_ERROR, _ioError );
			
			// 破棄する
			_request = null;
			
			// Progression を作成する
			_manager = parse( new XML( data ) );
			
			// 自動移動が有効化されていれば
			if ( _autoGoto ) {
				// 初期シーンに移動する
				_manager.goto( _manager.syncedSceneId );
			}
		}
		
		/**
		 * 入出力エラーが発生して読み込み処理が失敗したときに送出されます。
		 */
		private function _ioError( e:IOErrorEvent ):void {
			// イベントリスナーを解除する
			super.removeEventListener( Event.COMPLETE, _complete );
			super.removeEventListener( IOErrorEvent.IO_ERROR, _ioError );
			
			// 破棄する
			_request = null;
			
			// 例外をスローする
			throw new IOError( e.text );
		}
	}
}
