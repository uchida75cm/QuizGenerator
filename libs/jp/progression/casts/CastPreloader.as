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
package jp.progression.casts {
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.ui.ContextMenu;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.display.ExDocument;
	import jp.nium.events.ExEvent;
	import jp.progression.core.impls.ICastObject;
	import jp.progression.core.L10N.L10NProgressionMsg;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.core.PackageInfo;
	import jp.progression.events.CastEvent;
	import jp.progression.events.ExecuteEvent;
	import jp.progression.executors.ExecutorObject;
	
	/**
	 * <span lang="ja">オブジェクトが読み込みを開始した瞬間に送出されます。
	 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.CastEvent.CAST_LOAD_START
	 */
	[Event( name="castLoadStart", type="jp.progression.events.CastEvent" )]
	
	/**
	 * <span lang="ja">オブジェクトが読み込みを完了した瞬間に送出されます。
	 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.CastEvent.CAST_LOAD_COMPLETE
	 */
	[Event( name="castLoadComplete", type="jp.progression.events.CastEvent" )]
	
	/**
	 * <span lang="ja">ダウンロード処理を実行中にデータを受信したときに送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 */
	[Event( name="progress", type="flash.events.ProgressEvent" )]
	
	/**
	 * <span lang="ja">入出力エラーが発生して読み込み処理が失敗したときに送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event( name="ioError", type="flash.events.IOErrorEvent" )]
	
	/**
	 * <span lang="ja">CastPreloader クラスは、ExDocument クラスの基本機能を拡張し、イベントフローとの連携機能を実装した jp.progression パッケージで使用されるプリロード処理に特化したドキュメント専用クラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.casts#getInstanceById()
	 * @see jp.progression.casts#getInstancesByGroup()
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public class CastPreloader extends ExDocument implements ICastObject {
		
		/**
		 * <span lang="ja">ロードされた SWF ファイル内の表示オブジェクトの場合、root プロパティはその SWF ファイルが表す表示リストのツリー構造部分の一番上にある表示オブジェクトとなります。</span>
		 * <span lang="en">For a display object in a loaded SWF file, the root property is the top-most display object in the portion of the display list's tree structure represented by that SWF file.</span>
		 */
		public static function get root():CastPreloader { return _root; }
		private static var _root:CastPreloader;
		
		/**
		 * <span lang="ja">表示オブジェクトのステージです。</span>
		 * <span lang="en">The Stage of the display object.</span>
		 */
		public static function get stage():Stage { return ExDocument.stage; }
		
		/**
		 * <span lang="ja">ステージ左の X 座標を取得します。</span>
		 * <span lang="en">Get the left X coordinate of the stage.</span>
		 * 
		 * @see #right
		 * @see #top
		 * @see #bottom
		 */
		public static function get left():Number { return ExDocument.left; }
		
		/**
		 * <span lang="ja">ステージ中央の X 座標を取得します。</span>
		 * <span lang="en">Get the center X coordinate of the stage.</span>
		 * 
		 * @see #center
		 */
		public static function get center():Number { return ExDocument.center; }
		
		/**
		 * <span lang="ja">ステージ右の X 座標を取得します。</span>
		 * <span lang="en">Get the right X coordinate of the stage.</span>
		 * 
		 * @see #left
		 * @see #top
		 * @see #bottom
		 */
		public static function get right():Number { return ExDocument.right; }
		
		/**
		 * <span lang="ja">ステージ上の Y 座標を取得します。</span>
		 * <span lang="en">Get the top Y coordinate of the stage.</span>
		 * 
		 * @see #left
		 * @see #right
		 * @see #bottom
		 */
		public static function get top():Number { return ExDocument.top; }
		
		/**
		 * <span lang="ja">ステージ中央の Y 座標を取得します。</span>
		 * <span lang="en">Get the center Y coordinate of the stage.</span>
		 * 
		 * @see #centerX
		 */
		public static function get middle():Number { return ExDocument.middle; }
		
		/**
		 * <span lang="ja">ステージ下の Y 座標を取得します。</span>
		 * <span lang="en">Get the bottom Y coordinate of the stage.</span>
		 * 
		 * @see #left
		 * @see #right
		 * @see #top
		 */
		public static function get bottom():Number { return ExDocument.bottom; }
		
		/**
		 * @private
		 */
		progression_internal static function get $loader():Loader { return _loader; }
		private static var _loader:Loader;
		
		/**
		 * @private
		 */
		progression_internal static function get $foreground():Sprite { return _foreground; }
		private static var _foreground:Sprite;
		
		/**
		 * @private
		 */
		progression_internal static function get $background():Sprite { return _background; }
		private static var _background:Sprite;
		
		/**
		 * @private
		 */
		progression_internal static function get $relocateChildren():Boolean { return _relocateChildren; }
		private static var _relocateChildren:Boolean = false;
		
		
		
		
		/**
		 * <span lang="ja">自身の参照を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get self():CastPreloader { return CastPreloader( this ); }
		
		/**
		 * <span lang="ja">load() メソッドまたは loadBytes() メソッドを使用して読み込まれた SWF ファイルまたはイメージ（JPG、PNG、または GIF）ファイルのルート表示オブジェクトが含まれます。</span>
		 * <span lang="en">Contains the root display object of the SWF file or image (JPG, PNG, or GIF) file that was loaded by using the load() or loadBytes() methods.</span>
		 */
		public function get content():DisplayObject { return _loader.content; }
		
		/**
		 * <span lang="ja">読み込まれるコンテンツよりも前面に表示したい DisplayObject を管理する Sprite インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get foreground():Sprite { return _foreground; }
		
		/**
		 * <span lang="ja">読み込まれるコンテンツよりも背面に表示したい DisplayObject を管理する Sprite インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get background():Sprite { return _background; }
		
		/**
		 * <span lang="ja">自動的に読み込まれる SWF ファイルの URL を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get request():URLRequest { return _request; }
		private var _request:URLRequest;
		
		/**
		 * <span lang="ja">オブジェクトをロードする前に、Flash Player がクロスドメインポリシーファイルの存在を確認するかどうかを取得または指定します。
		 * ただし、読み込み処理が開始された以降は設定を変更することはできません。</span>
		 * <span lang="en"></span>
		 */
		public function get checkPolicyFile():Boolean { return _checkPolicyFile; }
		private var _checkPolicyFile:Boolean = false;
		
		/**
		 * <span lang="ja">関連付けられている ExecutorObject インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 */
		public function get executor():ExecutorObject { return _executor; }
		private var _executor:ExecutorObject;
		
		/**
		 * <span lang="ja">読み込まれているオブジェクトに対応する LoaderInfo オブジェクトを返します。</span>
		 * <span lang="en">Returns a LoaderInfo object corresponding to the object being loaded.</span>
		 */
		public function get contentLoaderInfo():LoaderInfo { return _loader.contentLoaderInfo; }
		
		/**
		 * <span lang="ja">そのメディアのロード済みのバイト数です。</span>
		 * <span lang="en">The number of bytes that are loaded for the media.</span>
		 */
		public function get bytesLoaded():uint { return _bytesLoaded; }
		private var _bytesLoaded:uint = 0;
		
		/**
		 * <span lang="ja">メディアファイル全体の圧縮後のバイト数です。</span>
		 * <span lang="en">The number of compressed bytes in the entire media file.</span>
		 */
		public function get bytesTotal():uint { return _bytesTotal; }
		private var _bytesTotal:uint = 0;
		
		/**
		 * 準備が完了したかどうかを取得します。
		 */
		private var _isReady:Boolean = false;
		
		/**
		 * 現在、読み込み中であるかどうかを取得します。
		 */
		private var _isLoading:Boolean = false;
		
		/**
		 * 読み込みが完了したかどうかを取得します。
		 */
		private var _isLoaded:Boolean = false;
		
		/**
		 * 
		 */
		private var _isCancel:Boolean = false;
		
		/**
		 * ExecutorObject クラスを取得します。
		 */
		private var _executorClass:Class;
		
		/**
		 * <span lang="ja">SWF ファイルの読み込みが完了し、stage 及び loaderInfo にアクセス可能になった場合に呼び出されるイベントハンドラメソッドを取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see jp.nium.events.ExEvent#EX_READY
		 */
		public function get onReady():Function { return _onReady; }
		public function set onReady( value:Function ):void { _onReady = value; }
		private var _onReady:Function;
		
		/**
		 * <span lang="ja">SWF ファイルの読み込みが完了し、stage 及び loaderInfo にアクセス可能になった場合に呼び出されるオーバーライド・イベントハンドラメソッドです。</span>
		 * <span lang="en"></span>
		 */
		protected function atReady():void {}
		
		/**
		 * <span lang="ja">ProgressEvent.PROGRESS イベントを受け取った場合に呼び出されるイベントハンドラメソッドを取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public function get onProgress():Function { return _onProgress; }
		public function set onProgress( value:Function ):void { _onProgress = value; }
		private var _onProgress:Function;
		
		/**
		 * <span lang="ja">ProgressEvent.PROGRESS イベントを受け取った場合に呼び出されるオーバーライド・イベントハンドラメソッドです。</span>
		 * <span lang="en"></span>
		 */
		protected function atProgress():void {}
		
		/**
		 * @private
		 */
		public function get onCastAdded():Function { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "onCastAdded" ) ); }
		public function set onCastAdded( value:Function ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "onCastAdded" ) ); }
		
		/**
		 * @private
		 */
		protected final function atCastAdded():void {}
		
		/**
		 * @private
		 */
		public function get onCastRemoved():Function { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "onCastRemoved" ) ); }
		public function set onCastRemoved( value:Function ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "onCastRemoved" ) ); }
		
		/**
		 * @private
		 */
		protected final function atCastRemoved():void {}
		
		/**
		 * <span lang="ja">読み込み処理が開始される直前に呼び出されるイベントハンドラメソッドを取得または設定します。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 */
		public function get onCastLoadStart():Function { return _onCastLoadStart; }
		public function set onCastLoadStart( value:Function ):void { _onCastLoadStart = value; }
		private var _onCastLoadStart:Function;
		
		/**
		 * <span lang="ja">読み込み処理が開始される直前に呼び出されるオーバーライド・イベントハンドラメソッドです。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 */
		protected function atCastLoadStart():void {}
		
		/**
		 * <span lang="ja">読み込み処理が完了された直後に呼び出されるイベントハンドラメソッドを取得または設定します。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 */
		public function get onCastLoadComplete():Function { return _onCastLoadComplete; }
		public function set onCastLoadComplete( value:Function ):void { _onCastLoadComplete = value; }
		private var _onCastLoadComplete:Function;
		
		/**
		 * <span lang="ja">読み込み処理が完了された直後に呼び出されるオーバーライド・イベントハンドラメソッドです。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 */
		protected function atCastLoadComplete():void {}
		
		
		
		
		
		/**
		 * <span lang="ja">新しい CastPreloader インスタンスを作成します。</span>
		 * <span lang="en">Creates a new CastPreloader object.</span>
		 * 
		 * @param request
		 * <span lang="ja">読み込む SWF ファイルの絶対 URL または相対 URL です。</span>
		 * <span lang="en">The absolute or relative URL of the SWF file to be loaded.</span>
		 * @param checkPolicyFile
		 * <span lang="ja">オブジェクトをロードする前に、URL ポリシーファイルの存在を確認するかどうかを指定します。</span>
		 * <span lang="en">Specifies whether a check should be made for the existence of a URL policy file before loading the object.</span>
		 * @param executorClass
		 * <span lang="ja">汎用的な処理の実装として使用したいクラスです。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function CastPreloader( request:URLRequest = null, checkPolicyFile:Boolean = false, executorClass:Class = null, initObject:Object = null ) {
			// クラスをコンパイルに含める
			progression_internal;
			
			// 引数を設定する
			_request = request;
			_checkPolicyFile = checkPolicyFile;
			_executorClass = executorClass || ExecutorObject;
			
			// インスタンスを登録する
			_root = CastPreloader( this );
			
			// Sprite を作成する
			_foreground = new Sprite();
			_background = new Sprite();
			
			// 親クラスを初期化する
			super( initObject );
			
			// 既存の DisplayObject を取得する
			var list:Array = [];
			var l:int; l = super.children.length;
			if ( l > 0 ) {
				for ( var i:int = 0; i < l; i++ ) {
					list.push( super.children[i] );
				}
				
				// 状態を変更する
				_relocateChildren = true;
			}
			
			// 表示リストに追加する
			super.addChild( _background );
			super.addChild( _foreground );
			
			// 既存の表示オブジェクトを background に移行する
			for ( i = 0, l = list.length; i < l; i++ ) {
				_background.addChild( super.removeChild( list[i] ) );
			}
			list = null;
			
			// Loader を作成する
			_loader = new Loader();
			
			// ContextMenu を作成する
			var menu:ContextMenu = new ContextMenu();
			menu.hideBuiltInItems();
			super.contextMenu = menu;
			
			// イベントリスナーを登録する
			super.addEventListener( ExEvent.EX_READY, _ready );
			super.addEventListener( CastEvent.CAST_LOAD_START, _castLoadStart );
			super.addEventListener( CastEvent.CAST_LOAD_COMPLETE, _castLoadComplete );
			_loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, _progress );
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, _complete );
			_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, super.dispatchEvent );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">読み込み処理を開始します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param request
		 * <span lang="ja">読み込む SWF ファイルの絶対 URL または相対 URL です。</span>
		 * <span lang="en">The absolute or relative URL of the SWF file to be loaded.</span>
		 */
		public function load( request:URLRequest ):void {
			_load( request );
		}
		
		/**
		 * 読み込み処理を開始します。
		 */
		private function _load( request:URLRequest ):void {
			if ( !_isReady || _isLoading || _isLoaded || _isCancel ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_022 ).toString() ); }
			
			_request = request;
			
			// Flashvars を継承する
			switch ( Capabilities.playerType ) {
				case "ActiveX"		:
				case "PlugIn"		: {
					_request.data ||= new URLVariables();
					for ( var p:String in super.loaderInfo.parameters ) {
						_request.data[p] ||= super.loaderInfo.parameters[p];
					}
					break;
				}
				case "Desktop"		:
				case "External"		:
				case "StandAlone"	: { break; }
			}
			
			// ファイルを読み込む
			_loader.load( _request, new LoaderContext( _checkPolicyFile, ApplicationDomain.currentDomain ) );
			
			// 読み込み中にする
			_isLoading = true;
		}
		
		/**
		 * <span lang="ja">CastPreloader インスタンスに対して現在進行中の load() メソッドの処理をキャンセルします。</span>
		 * <span lang="en">Cancels a load() method operation that is currently in progress for the CastPreloader instance.</span>
		 */
		public function cancel():void {
			if ( _isLoaded ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_022 ).toString() ); }
			
			if ( _isLoading ) {
				// イベントリスナーを解除する
				_loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, _progress );
				_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, _complete );
				_loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, super.dispatchEvent );
				
				// 読み込みを閉じる
				_loader.close();
				
				_isLoading = false;
			}
			
			_isCancel = true;
		}
		
		/**
		 * <span lang="ja">マネージャーオブジェクトとの関連付けを更新します。</span>
		 * <span lang="en"></span>
		 * 
		 * @return
		 * <span lang="ja">関連付けが成功したら true を、それ以外は false を返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #manager
		 * @see jp.progression.Progression
		 */
		public function updateManager():Boolean {
			return false;
		}
		
		/**
		 * <span lang="ja">特定のイベントが送出された際に、自動実行させたい Command インスタンスをリストの最後尾に追加します。
		 * 追加された Command インスタンスは、イベントが送出される直前に自動的に初期化されます。
		 * このメソッドを使用するためには executor プロパティに CommandExecutor が実装されている必要があります。</span>
		 * <span lang="en"></span>
		 * 
		 * @param commands
		 * <span lang="ja">登録したいコマンドを含む配列です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #onCastAdded
		 * @see #onCastRemoved
		 * @see #insertCommand()
		 * @see #clearCommand()
		 */
		public function addCommand( ... commands:Array ):void {
			ExecutorObject.progression_internal::$addCommand( _executor, commands );
		}
		
		/**
		 * <span lang="ja">特定のイベントが送出された際に、自動実行させたい Command インスタンスをすでにリストに登録され、実行中の Command インスタンスの次の位置に追加します。
		 * 追加された Command インスタンスは、イベントが送出される直前に自動的に初期化されます。
		 * このメソッドを使用するためには executor プロパティに CommandExecutor が実装されている必要があります。</span>
		 * <span lang="en"></span>
		 * 
		 * @param commands
		 * <span lang="ja">登録したいコマンドを含む配列です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #onCastAdded
		 * @see #onCastRemoved
		 * @see #addCommand()
		 * @see #clearCommand()
		 */
		public function insertCommand( ... commands:Array ):void {
			ExecutorObject.progression_internal::$insertCommand( _executor, commands );
		}
		
		/**
		 * <span lang="ja">登録されている Command インスタンスを削除します。
		 * このメソッドを使用するためには executor プロパティに CommandExecutor が実装されている必要があります。</span>
		 * <span lang="en"></span>
		 * 
		 * @param completely
		 * <span lang="en">true が設定されている場合は登録されている全てのコマンド登録を解除し、false の場合には現在処理中のコマンド以降の登録を解除します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #onCastAdded
		 * @see #onCastRemoved
		 * @see #addCommand()
		 * @see #insertCommand()
		 */
		public function clearCommand( completely:Boolean = false ):void {
			ExecutorObject.progression_internal::$clearCommand( _executor, completely );
		}
		
		/**
		 * @private
		 */
		public function dispose():void {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "dispose" ) );
		}
		
		/**
		 * @private
		 */
		override public function addChild( child:DisplayObject ):DisplayObject {
			throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_015 ).toString( this ) );
		}
		
		/**
		 * @private
		 */
		override public function addChildAt( child:DisplayObject, index:int ):DisplayObject {
			throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_015 ).toString( this ) );
		}
		
		/**
		 * @private
		 */
		override public function addChildAtAbove( child:DisplayObject, index:int ):DisplayObject {
			throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_015 ).toString( this ) );
		}
		
		/**
		 * @private
		 */
		override public function removeChild( child:DisplayObject ):DisplayObject {
			throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_015 ).toString( this ) );
		}
		
		/**
		 * @private
		 */
		override public function removeChildAt( index:int ):DisplayObject {
			throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_015 ).toString( this ) );
		}
		
		/**
		 * @private
		 */
		override public function removeAllChildren():void {
			throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_015 ).toString( this ) );
		}
		
		/**
		 * @private
		 */
		override public function setChildIndex( child:DisplayObject, index:int ):void {
			throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_015 ).toString( this ) );
		}
		
		/**
		 * @private
		 */
		override public function setChildIndexAbove( child:DisplayObject, index:int ):void {
			throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_015 ).toString( this ) );
		}
		
		/**
		 * @private
		 */
		override public function swapChildren( child1:DisplayObject, child2:DisplayObject ):void {
			throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_015 ).toString( this ) );
		}
		
		/**
		 * @private
		 */
		override public function swapChildrenAt( index1:int, index2:int ):void {
			throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_015 ).toString( this ) );
		}
		
		
		
		
		/**
		 * SWF ファイルの読み込みが完了し、stage 及び loaderInfo にアクセス可能になった場合に送出されます。
		 */
		private function _ready( e:ExEvent ):void {
			// 読み込み状態を取得する
			_bytesLoaded = 0;
			_bytesTotal = 0;
			
			// イベントハンドラメソッドを実行する
			atReady();
			if ( _onReady != null ) {
				_onReady.apply( this );
			}
			
			// 準備完了状態にする
			_isReady = true;
			
			// キャンセルされていたら終了する
			if ( _isCancel ) { return; }
			
			// ExecutorObject を作成する
			_executor = new _executorClass( this ) as ExecutorObject;
			
			// イベントリスナーを登録する
			_executor.addEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeCompleteLoadStart );
			
			// 実行する
			_executor.execute( new CastEvent( CastEvent.CAST_LOAD_START ) );
		}
		
		/**
		 * 処理が完了した場合に送出されます。
		 */
		private function _executeCompleteLoadStart( e:ExecuteEvent ):void {
			// イベントリスナーを解除する
			_executor.removeEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeCompleteLoadStart );
			
			// キャンセルされていたら終了する
			if ( _isCancel ) { return; }
			
			// すでに読み込みが完了していたら
			if ( _isLoaded ) {
				// イベントリスナーを登録する
				_executor.addEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeCompleteLoadComplete );
				
				// 実行する
				_executor.execute( new CastEvent( CastEvent.CAST_LOAD_COMPLETE ) );
				return;
			}
			
			// すでに読み込みが開始されていたら終了する
			if ( _isLoading ) { return; }
			
			// ファイルを読み込む
			_load( _request );
		}
		
		/**
		 * データが正常にロードされたときに送出されます。
		 */
		private function _complete( e:Event ):void {
			// イベントリスナーを解除する
			_loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, _progress );
			_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, _complete );
			_loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, super.dispatchEvent );
			
			// 読み込み完了状態にする
			_isLoading = false;
			_isLoaded = true;
			
			// 既に実行されていれば終了する
			if ( _executor.state > 0 ) { return; }
			
			// イベントリスナーを登録する
			_executor.addEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeCompleteLoadComplete );
			
			// 実行する
			_executor.execute( new CastEvent( CastEvent.CAST_LOAD_COMPLETE ) );
		}
		
		/**
		 * 処理が完了した場合に送出されます。
		 */
		private function _executeCompleteLoadComplete( e:ExecuteEvent ):void {
			// イベントリスナーを解除する
			_executor.removeEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeCompleteLoadComplete );
			
			// ExecutorObject を破棄する
			_executor.dispose();
			_executor = null;
			
			// Progression の生成を検知する
			if ( PackageInfo.managerClassRef ) {
				// イベントリスナーを登録する
				PackageInfo.managerClassRef.progression_internal::$collection.addEventListener( "collectionUpdate", _collectionUpdate );
			}
			
			// 表示リストに追加する
			super.addChildAt( _loader, super.getChildIndex( _background ) + 1 );
		}
		
		/**
		 * 
		 */
		private function _collectionUpdate( e:Event ):void {
			// イベントリスナーを解除する
			PackageInfo.managerClassRef.progression_internal::$collection.addEventListener( "collectionUpdate", _collectionUpdate );
			
			// 環境設定が存在しなければ終了する
			if ( !PackageInfo.managerClassRef.config ) { return; }
			
			// コンテクストメニューを設定する
			this["_contextMenuBuilder"] = PackageInfo.managerClassRef.config.contextMenuBuilder;
		}
		
		/**
		 * オブジェクトが読み込みを開始した瞬間に送出されます。
		 */
		private function _castLoadStart( e:CastEvent ):void {
			// イベントハンドラメソッドを実行する
			( _onCastLoadStart as Function || atCastLoadStart as Function ).apply( this );
		}
		
		/**
		 * ダウンロード処理を実行中にデータを受信したときに送出されます。
		 */
		private function _progress( e:ProgressEvent ):void {
			// 読み込み状態を取得する
			_bytesLoaded = _loader.contentLoaderInfo.bytesLoaded;
			_bytesTotal = _loader.contentLoaderInfo.bytesTotal;
			
			// イベントを送出する
			super.dispatchEvent( e );
			
			// イベントハンドラメソッドを実行する
			( _onProgress as Function || atProgress as Function ).apply( this );
		}
		
		/**
		 * オブジェクトが読み込みを完了した瞬間に送出されます。
		 */
		private function _castLoadComplete( e:CastEvent ):void {
			// イベントハンドラメソッドを実行する
			( _onCastLoadComplete as Function || atCastLoadComplete as Function ).apply( this );
		}
		
		
		
		
		
		/**
		 * 外部 ActionScript ファイルを取り込む
		 */
		include "../core/includes/CastPreloader_contextMenu.inc"
	}
}
