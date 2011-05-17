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
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.progression.casts.CastDocument;
	import jp.progression.core.L10N.L10NProgressionMsg;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.events.ManagerEvent;
	import jp.progression.events.SceneEvent;
	
	/**
	 * <span lang="ja">シーン移動時に目的地がシーンオブジェクト自身もしくは子階層であり、かつ自身が SWF ファイルを読み込んでいない状態で、SceneEvent.SCENE_LOAD イベントが発生する直前に送出されます。
	 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.SceneEvent.SCENE_PRE_LOAD
	 */
	[Event( name="scenePreLoad", type="jp.progression.events.SceneEvent" )]
	
	/**
	 * <span lang="ja">シーン移動時に目的地がシーンオブジェクト自身もしくは親階層であり、かつ自身がすでに SWF ファイルを読み込んでいる状態で、SceneEvent.SCENE_UNLOAD イベントが発生した直後に送出されます。
	 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
	 * 
	 * @eventType jp.progression.events.SceneEvent.SCENE_POST_UNLOAD
	 */
	[Event( name="scenePostUnload", type="jp.progression.events.SceneEvent" )]
	
	/**
	 * <span lang="ja">SceneLoader クラスは、自身以下のシーンリストを読み込んだ外部 SWF ファイルを使用して設計可能にするローダークラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // SceneLoader インスタンスを作成する
	 * var scene:SceneLoader = new SceneLoader();
	 * </listing>
	 */
	public class SceneLoader extends SceneObject {
		
		/**
		 * <span lang="ja">読み込まれた SWF ファイル内に作成される SceneObject インスタンスの container プロパティの値を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get loaderContainer():Sprite { return _loaderContainer; }
		private var _loaderContainer:Sprite;
		
		/**
		 * <span lang="ja">読み込まれた SWF ファイルのプライマリマネージャーインスタンスに関連付けられているルートシーンを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get content():SceneObject { return _content; }
		private var _content:SceneObject;
		
		/**
		 * <span lang="ja">読み込まれた SWF ファイルに関連付けられている SceneInfo インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get contentSceneInfo():SceneInfo { return _contentSceneInfo; }
		private var _contentSceneInfo:SceneInfo;
		
		/**
		 * @private
		 */
		override public function get scenes():Array { return []; }
		
		/**
		 * @private
		 */
		override public function get numScenes():int { return 0; }
		
		/**
		 * Loader インスタンスを取得します。
		 */
		private var _loader:Loader;
		
		/**
		 * ドキュメントインスタンスを取得します。
		 */
		private var _document:*;
		
		/**
		 * @private
		 */
		override public function get onSceneLoad():Function { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "onSceneLoad" ) ); }
		override public function set onSceneLoad( value:Function ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "onSceneLoad" ) ); }
		
		/**
		 * @private
		 */
		override public function get onSceneUnload():Function { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "onSceneUnload" ) ); }
		override public function set onSceneUnload( value:Function ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "onSceneUnload" ) ); }
		
		/**
		 * @private
		 */
		override public function get onSceneInit():Function { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "onSceneInit" ) ); }
		override public function set onSceneInit( value:Function ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "onSceneInit" ) ); }
		
		/**
		 * @private
		 */
		override public function get onSceneGoto():Function { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "onSceneGoto" ) ); }
		override public function set onSceneGoto( value:Function ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "onSceneGoto" ) ); }
		
		/**
		 * @private
		 */
		override public function get onSceneDescend():Function { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "onSceneDescend" ) ); }
		override public function set onSceneDescend( value:Function ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "onSceneDescend" ) ); }
		
		/**
		 * @private
		 */
		override public function get onSceneAscend():Function { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "onSceneAscend" ) ); }
		override public function set onSceneAscend( value:Function ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "onSceneAscend" ) ); }
		
		/**
		 * <span lang="ja">シーンオブジェクトが SceneEvent.SCENE_PRE_LOAD イベントを受け取った場合に呼び出されるイベントハンドラメソッドを取得または設定します。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.SceneEvent#SCENE_PRE_LOAD
		 */
		public function get onScenePreLoad():Function { return _onScenePreLoad; }
		public function set onScenePreLoad( value:Function ):void { _onScenePreLoad = value; }
		private var _onScenePreLoad:Function;
		
		/**
		 * <span lang="ja">シーンオブジェクトが SceneEvent.SCENE_PRE_LOAD イベントを受け取った場合に呼び出されるオーバーライド・イベントハンドラメソッドです。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.SceneEvent#SCENE_PRE_LOAD
		 */
		protected function atScenePreLoad():void {}
		
		/**
		 * <span lang="ja">シーンオブジェクトが SceneEvent.SCENE_POST_UNLOAD イベントを受け取った場合に呼び出されるイベントハンドラメソッドを取得または設定します。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.SceneEvent#SCENE_POST_UNLOAD
		 */
		public function get onScenePostUnload():Function { return _onScenePostUnload; }
		public function set onScenePostUnload( value:Function ):void { _onScenePostUnload = value; }
		private var _onScenePostUnload:Function;
		
		/**
		 * <span lang="ja">シーンオブジェクトが SceneEvent.SCENE_POST_UNLOAD イベントを受け取った場合に呼び出されるオーバーライド・イベントハンドラメソッドです。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.SceneEvent#SCENE_POST_UNLOAD
		 */
		protected function atScenePostUnload():void {}
		
		
		
		
		
		/**
		 * <span lang="ja">新しい SceneLoader インスタンスを作成します。</span>
		 * <span lang="en">Creates a new SceneLoader object.</span>
		 * 
		 * @param name
		 * <span lang="ja">シーンの名前です。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function SceneLoader( name:String = null, initObject:Object = null ) {
			// クラスをコンパイルに含める
			progression_internal;
			
			// 親クラスを初期化する
			super( name, initObject );
			
			// Loader を作成する
			_loader = new Loader();
			
			// SceneInfo を作成する
			_contentSceneInfo = SceneInfo.progression_internal::$createInstance( null, this, _loader.contentLoaderInfo );
			
			// イベントリスナーを登録する
			super.addEventListener( SceneEvent.SCENE_PRE_LOAD, _sceneEvent, false, 0, true );
			super.addEventListener( SceneEvent.SCENE_POST_UNLOAD, _sceneEvent, false, 0, true );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">SWF ファイルを、この SceneLoader オブジェクトの子であるオブジェクトにロードします。
		 * 読み込まれる SWF ファイルはドキュメントクラスに CastDocument クラスを継承、もしくは PRMLLoader コンポーネント、EasyCastingLoader コンポーネントが設置されている必要があります。</span>
		 * <span lang="en"></span>
		 * 
		 * @param request
		 * <span lang="ja">読み込む SWF ファイルの絶対 URL または相対 URL です。相対パスの場合は、メイン SWF ファイルを基準にする必要があります。絶対 URL の場合は、http:// や file:/// などのプロトコル参照も含める必要があります。ファイル名には、ドライブ指定を含めることはできません。</span>
		 * <span lang="en">The absolute or relative URL of the SWF file to be loaded. A relative path must be relative to the main SWF file. Absolute URLs must include the protocol reference, such as http:// or file:///. Filenames cannot include disk drive specifications.</span>
		 * @param loaderContainer
		 * <span lang="ja">読み込まれた SWF ファイルの表示オブジェクトの基準となる Sprite です。</span>
		 * <span lang="en"></span>
		 * @param checkPolicyFile
		 * <span lang="ja">オブジェクトをロードする前に、URL ポリシーファイルの存在を確認するかどうかを指定します。</span>
		 * <span lang="en">Specifies whether a check should be made for the existence of a URL policy file before loading the object.</span>
		 * @param securityDomain
		 * <span lang="en">SceneLoader オブジェクトで使用する SecurityDomain オブジェクトを指定します。</span>
		 * <span lang="en">Specifies the SecurityDomain object to use for a SceneLoader object.</span>
		 */
		public function load( request:URLRequest, loaderContainer:Sprite = null, checkPolicyFile:Boolean = false, securityDomain:SecurityDomain = null ):void {
			// 引数を設定する
			_loaderContainer = loaderContainer || container;
			
			// コンテナが存在しなければ
			if ( !_loaderContainer ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_024 ).toString() ); }
			
			// イベントリスナーを登録する
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, _complete, false, int.MAX_VALUE );
			_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, _ioError, false, int.MAX_VALUE );
			
			// 読み込む
			_loader.load( request, new LoaderContext( checkPolicyFile, ApplicationDomain.currentDomain, securityDomain ) );
		}
		
		/**
		 * <span lang="ja">ByteArray オブジェクトに保管されているバイナリデータから読み込みます。</span>
		 * <span lang="en">Loads from binary data stored in a ByteArray object.</span>
		 * 
		 * @param bytes
		 * <span lang="ja">ByteArray オブジェクトです。ByteArray の内容としては、Loader クラスがサポートする SWF、GIF、JPEG、PNG のうちの任意のファイル形式を使用できます。</span>
		 * <span lang="en">A ByteArray object. The contents of the ByteArray can be any of the file formats supported by the Loader class: SWF, GIF, JPEG, or PNG.</span>
		 * @param loaderContainer
		 * <span lang="ja">読み込まれた SWF ファイルの表示オブジェクトの基準となる Sprite です。</span>
		 * <span lang="en"></span>
		 * @param checkPolicyFile
		 * <span lang="ja">オブジェクトをロードする前に、URL ポリシーファイルの存在を確認するかどうかを指定します。</span>
		 * <span lang="en">Specifies whether a check should be made for the existence of a URL policy file before loading the object.</span>
		 * @param securityDomain
		 * <span lang="ja">SceneLoader オブジェクトで使用する SecurityDomain オブジェクトを指定します。</span>
		 * <span lang="en">Specifies the SecurityDomain object to use for a SceneLoader object.</span>
		 */
		public function loadBytes( bytes:ByteArray, loaderContainer:Sprite = null, checkPolicyFile:Boolean = false, securityDomain:SecurityDomain = null ):void {
			// 引数を設定する
			_loaderContainer = loaderContainer || container;
			
			// コンテナが存在しなければ
			if ( !_loaderContainer ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_024 ).toString() ); }
			
			// イベントリスナーを登録する
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, _complete, false, int.MAX_VALUE );
			_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, _ioError, false, int.MAX_VALUE );
			
			// 読み込む
			_loader.loadBytes( bytes, new LoaderContext( checkPolicyFile, ApplicationDomain.currentDomain, securityDomain ) );
		}
		
		/**
		 * <span lang="ja">load() メソッドを使用して読み込まれた、この SceneLoader オブジェクトの子を削除します。</span>
		 * <span lang="en">Removes a child of this SceneLoader object that was loaded by using the load() method.</span>
		 */
		public function unload():void {
			// イベントリスナーを解除する
			_removeLoaderListeners();
			
			// ドキュメントを破棄する
			if ( _document ) {
				_document.progression_internal::$dispose();
				_document = null;
			}
			
			// Loader を破棄する
			try {
				_loader.unload();
			}
			catch ( err:Error ) {}
			
			// 破棄する
			_loaderContainer = null;
			_content = null;
		}
		
		/**
		 * <span lang="ja">子 SWF ファイルの内容のアンロードを試み、ロードされた SWF ファイルのコマンドの実行を中止します。</span>
		 * <span lang="en">Attempts to unload child SWF file contents and stops the execution of commands from loaded SWF files.</span>
		 * 
		 * @param gc
		 * <span lang="ja">子 SWF オブジェクトでガベージコレクターが実行されるようにヒントを提供するかどうかを指定します（true または false）。</span>
		 * <span lang="en">Provides a hint to the garbage collector to run on the child SWF objects (true) or not (false).</span>
		 */
		public function unloadAndStop( gc:Boolean = true ):void {
			var version:int = parseInt( Capabilities.version.split( " " )[1] );
			if ( version < 10 ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "unloadAndStop()", "Flash Player 10, AIR 1.5" ) ); }
			
			// イベントリスナーを解除する
			_removeLoaderListeners();
			
			// ドキュメントを破棄する
			if ( _document ) {
				_document.progression_internal::$dispose();
				_document = null;
			}
			
			// Loader を破棄する
			try {
				_loader[ "unloadAndStop" ]( gc );
			}
			catch ( err:Error ) {}
			
			// 破棄する
			_loaderContainer = null;
			_content = null;
		}
		
		/**
		 * <span lang="ja">SceneLoader インスタンスに対して現在進行中の load() メソッドの処理をキャンセルします。</span>
		 * <span lang="en">Cancels a load() method operation that is currently in progress for the SceneLoader instance.</span>
		 */
		public function close():void {
			if ( _loader ) {
				_loader.close();
			}
		}
		
		/**
		 * @private
		 */
		override public function addScene( scene:SceneObject ):SceneObject {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "addScene" ) );
		}
		
		/**
		 * @private
		 */
		override public function addSceneAt( scene:SceneObject, index:int ):SceneObject {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "addSceneAt" ) );
		}
		
		/**
		 * @private
		 */
		override public function addSceneAtAbove( scene:SceneObject, index:int ):SceneObject {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "addSceneAtAbove" ) );
		}
		
		/**
		 * @private
		 */
		override public function addSceneFromXML( prml:XML ):void {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "addSceneFromXML" ) );
		}
		
		/**
		 * @private
		 */
		override public function removeScene( scene:SceneObject ):SceneObject {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "removeScene" ) );
		}
		
		/**
		 * @private
		 */
		override public function removeSceneAt( index:int ):SceneObject {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "removeSceneAt" ) );
		}
		
		/**
		 * @private
		 */
		override public function removeAllScenes():void {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "removeAllScenes" ) );
		}
		
		/**
		 * @private
		 */
		override public function contains( scene:SceneObject ):Boolean {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "contains" ) );
		}
		
		/**
		 * @private
		 */
		override public function getSceneAt( index:int ):SceneObject {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "getSceneAt" ) );
		}
		
		/**
		 * @private
		 */
		override public function getSceneByName( name:String ):SceneObject {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "getSceneByName" ) );
		}
		
		/**
		 * @private
		 */
		override public function getSceneIndex( scene:SceneObject ):int {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "getSceneIndex" ) );
		}
		
		/**
		 * @private
		 */
		override public function setSceneIndex( scene:SceneObject, index:int ):void {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "setSceneIndex" ) );
		}
		
		/**
		 * @private
		 */
		override public function setSceneIndexAbove( scene:SceneObject, index:int ):void {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "setSceneIndexAbove" ) );
		}
		
		/**
		 * @private
		 */
		override public function swapScenes( scene1:SceneObject, scene2:SceneObject ):void {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "swapScenes" ) );
		}
		
		/**
		 * @private
		 */
		override public function swapScenesAt( index1:int, index2:int ):void {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "swapScenesAt" ) );
		}
		
		/**
		 * Loader のイベントリスナーを解除します。
		 */
		private function _removeLoaderListeners():void {
			// 対象が存在すれば
			if ( _loader ) {
				// イベントリスナーを解除する
				_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, _complete );
				_loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, _ioError );
			}
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			unload();
			
			_onScenePreLoad = null;
			_onScenePostUnload = null;
			
			// 親のメソッドを実行する
			super.dispose();
		}
		
		/**
		 * <span lang="ja">指定されたオブジェクトの XML ストリング表現を返します。</span>
		 * <span lang="en">Returns a XML string representation of the XML object.</span>
		 * 
		 * @return
		 * <span lang="ja">オブジェクトの XML ストリング表現です。</span>
		 * <span lang="en">The XML string representation of the XML object.</span>
		 */
		override public function toXMLString():String {
			var xml:XML = new XML( super.toXMLString() );
			
			// 読み込みが完了していれば
			if ( _document && _document.manager ) {
				// 子シーンノードを作成する
				var scenes:Array = _document.manager.root.scenes;
				for ( var i:int = 0, l:int = scenes.length; i < l; i++ ) {
					xml.appendChild( new XML( scenes[i].toXMLString() ) );
				}
			}
			
			return xml.toXMLString();
		}
		
		
		
		
		
		/**
		 * 
		 */
		private static function _sceneEvent( e:SceneEvent ):void {
			if ( e.eventPhase != EventPhase.AT_TARGET ) { return; }
			
			// 対象を取得する
			var target:SceneLoader = e.target as SceneLoader;
			
			// イベントハンドラメソッドを実行する
			var type:String = e.type.charAt( 0 ).toUpperCase() + e.type.slice( 1 );
			( target[ "_on" + type ] || target[ "at" + type ] ).apply( target );
		}
		
		
		
		
		
		/**
		 * 受信したすべてのデータがデコードされて Loader インスタンスの data プロパティへの保存が完了したときに送出されます。
		 */
		private function _complete( e:Event ):void {
			// イベントリスナーを解除する
			_removeLoaderListeners();
			
			// ドキュメントを取得する
			if ( _loader.content && "__progressionCurrentLoader__" in _loader.content ) {
				_document = _loader.content["__progressionCurrentLoader__"];
			}
			else {
				_document = _loader.content as CastDocument;
			}
			
			// ドキュメントが存在していれば
			if ( _document ) {
				// イベントリスナーを登録する
				_document.addEventListener( ManagerEvent.MANAGER_ACTIVATE, _managerActivate );
				
				// CastDocument を初期化する
				if ( _document.progression_internal::$initialize( null, this, _loaderContainer ) ) { return; }
				
				throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_021 ).toString( _loader.contentLoaderInfo.url ) );
			}
			
			// 破棄する
			_loader.unload();
		}
		
		/**
		 * キャストオブジェクトと Progression インスタンスの関連付けがアクティブになったときに送出されます。
		 */
		private function _managerActivate( e:ManagerEvent ):void {
			// イベントリスナーを破棄する
			_document.removeEventListener( ManagerEvent.MANAGER_ACTIVATE, _managerActivate );
			
			// 対象のルートシーンを設定する
			_content = _document.manager.root;
		}
		
		/**
		 * 入出力エラーが発生してロード処理が失敗したときに送出されます。
		 */
		private function _ioError( e:IOErrorEvent ):void {
			// イベントリスナーを解除する
			_removeLoaderListeners();
		}
	}
}
