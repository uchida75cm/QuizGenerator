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
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.ui.ContextMenu;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.display.ExDocument;
	import jp.nium.events.ExEvent;
	import jp.progression.core.impls.ICastObject;
	import jp.progression.core.impls.IManageable;
	import jp.progression.core.L10N.L10NProgressionMsg;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.core.PackageInfo;
	import jp.progression.core.proto.Configuration;
	import jp.progression.events.ManagerEvent;
	import jp.progression.events.SceneEvent;
	import jp.progression.executors.ExecutorObject;
	import jp.progression.Progression;
	import jp.progression.scenes.SceneLoader;
	
	/**
	 * <span lang="ja">Progression インスタンスとの関連付けがアクティブになったときに送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.ManagerEvent.MANAGER_ACTIVATE
	 */
	[Event( name="managerActivate", type="jp.progression.events.ManagerEvent" )]
	
	/**
	 * <span lang="ja">Progression インスタンスとの関連付けが非アクティブになったときに送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.ManagerEvent.MANAGER_DEACTIVATE
	 */
	[Event( name="managerDeactivate", type="jp.progression.events.ManagerEvent" )]
	
	/**
	 * <span lang="ja">CastDocument クラスは、ExDocument クラスの基本機能を拡張し、イベントフローとの連携機能を実装した jp.progression パッケージで使用される基本的なドキュメント専用クラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.casts#getInstanceById()
	 * @see jp.progression.casts#getInstancesByGroup()
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public class CastDocument extends ExDocument implements ICastObject, IManageable {
		
		/**
		 * <span lang="ja">ロードされた SWF ファイル内の表示オブジェクトの場合、root プロパティはその SWF ファイルが表す表示リストのツリー構造部分の一番上にある表示オブジェクトとなります。</span>
		 * <span lang="en">For a display object in a loaded SWF file, the root property is the top-most display object in the portion of the display list's tree structure represented by that SWF file.</span>
		 */
		public static function get root():CastDocument { return _root; }
		private static var _root:CastDocument;
		
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
		 * クラス内からの呼び出しかどうかを取得します。
		 */
		private static var _internallyCalled:Boolean = false;
		
		
		
		
		
		/**
		 * <span lang="ja">自身の参照を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get self():CastDocument { return CastDocument( this ); }
		
		/**
		 * <span lang="ja">読み込まれるコンテンツよりも前面に表示したい DisplayObject を管理する Sprite インスタンスを取得します。
		 * この値は CastPreloader 経由で読み込まれた場合のみ有効です。</span>
		 * <span lang="en"></span>
		 */
		public function get foreground():Sprite {
			if ( !PackageInfo.preloaderClassRef ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_023 ).toString( "foreground" ) ); }
			return PackageInfo.preloaderClassRef.progression_internal::$foreground;
		}
		
		/**
		 * <span lang="ja">読み込まれるコンテンツよりも背面に表示したい DisplayObject を管理する Sprite インスタンスを取得します。
		 * この値は CastPreloader 経由で読み込まれた場合のみ有効です。</span>
		 * <span lang="en"></span>
		 */
		public function get background():Sprite {
			if ( !PackageInfo.preloaderClassRef ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_023 ).toString( "background" ) ); }
			return PackageInfo.preloaderClassRef.progression_internal::$background;
		}
		
		/**
		 * <span lang="ja">CastPreloader 経由で読み込まれているかどうかを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get isPreloaded():Boolean { return Boolean( PackageInfo.preloaderClassRef ); }
		
		/**
		 * <span lang="ja">関連付けられている Progression インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see jp.progression.events.ManagerEvent#MANAGER_ACTIVATE
		 * @see jp.progression.events.ManagerEvent#MANAGER_DEACTIVATE
		 */
		public function get manager():Progression { return _manager; }
		private var _manager:Progression;
		private var _managerFromDocument:Progression;
		
		/**
		 * <span lang="ja">関連付けられている ExecutorObject インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #onCastAdded
		 * @see #onCastRemoved
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 */
		public function get executor():ExecutorObject { return _executor; }
		private var _executor:ExecutorObject;
		
		/**
		 * <span lang="ja">このオブジェクトの子の数を返します。
		 * このインスタンスが SceneLoader によって読み込まれている場合には、関連付けられている DisplayObjectContainer の子の数を返します。</span>
		 * <span lang="en"></span>
		 */
		override public function get numChildren():int { return _getProperty( "numChildren" ) as int; }
		
		/**
		 * <span lang="ja">この表示オブジェクトを含む DisplayObjectContainer オブジェクトを示します。
		 * このインスタンスが SceneLoader によって読み込まれている場合には、関連付けられている DisplayObjectContainer を示します。</span>
		 * <span lang="en"></span>
		 */
		override public function get parent():DisplayObjectContainer { return _getProperty( "parent" ) as DisplayObjectContainer; }
		
		/**
		 * <span lang="ja">読み込まれた SWF ファイル内の表示オブジェクトの場合、root プロパティはその SWF ファイルが表す表示リストのツリー構造部分の一番上にある表示オブジェクトとなります。
		 * このインスタンスが SceneLoader によって読み込まれている場合には、関連付けられている DisplayObject を示します。</span>
		 * <span lang="en"></span>
		 */
		override public function get root():DisplayObject { return _getProperty( "root" ) as DisplayObject; }
		
		/**
		 * <span lang="ja">表示オブジェクトのステージです。
		 * このインスタンスが SceneLoader によって読み込まれている場合には、関連付けられている Stage を示します。</span>
		 * <span lang="en"></span>
		 */
		override public function get stage():Stage { return _getProperty( "stage" ) as Stage; }
		
		/**
		 * Progression 識別子を取得します。
		 */
		private var _managerId:String;
		
		/**
		 * ルートクラスの参照を取得します。
		 */
		private var _rootClass:Class;
		
		/**
		 * 現在の対象コンテナを取得します。
		 */
		private var _container:DisplayObjectContainer;
		
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
		 * <span lang="ja">新しい CastDocument インスタンスを作成します。</span>
		 * <span lang="en">Creates a new CastDocument object.</span>
		 * 
		 * @param managerId
		 * <span lang="ja">自動的に生成される Progression インスタンスの識別子です。
		 * 省略した場合には SWF ファイル名が自動的に割り当てられます。</span>
		 * <span lang="en"></span>
		 * @param rootClass
		 * <span lang="ja">自動的に生成される Progression インスタンスのルートシーンに関連付けたいクラスの参照です。</span>
		 * <span lang="en"></span>
		 * @param config
		 * <span lang="ja">自動的に生成される Progression インスタンスの初期化情報として使用したい Configuration インスタンスです。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function CastDocument( managerId:String = null, rootClass:Class = null, config:Configuration = null, initObject:Object = null ) {
			// クラスをコンパイルに含める
			progression_internal;
			
			// 環境設定を適用する
			if ( config ) {
				Progression.initialize( config );
			}
			
			// 初期化する
			_container = this;
			
			// 引数を設定する
			_managerId = managerId;
			_rootClass = rootClass;
			
			// インスタンスを登録する
			_root ||= CastDocument( this );
			
			// CastPreloader で移動処理が行われていれば
			if ( PackageInfo.preloaderClassRef && PackageInfo.preloaderClassRef.progression_internal::$relocateChildren ) {
				// 情報を表示する
				Logger.info( Logger.getLog( L10NProgressionMsg.getInstance().INFO_001 ).toString() );
			}
			
			// 親クラスを初期化する
			super( initObject );
			
			// ContextMenu を作成する
			var menu:ContextMenu = new ContextMenu();
			menu.hideBuiltInItems();
			super.contextMenu = menu;
			
			// イベントリスナーを登録する
			super.addEventListener( ExEvent.EX_READY, _ready, false, int.MAX_VALUE );
		}
		
		
		
		
		
		/**
		 * @private
		 */
		progression_internal function $initialize( prml:XML = null, loader:SceneLoader = null, container:DisplayObjectContainer = null ):Boolean {
			// すでに存在していれば
			if ( _manager ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_002 ).toString( super.className ) ); }
			
			if ( _managerId ) {
				// Progression の初期設定を行う
				Progression.progression_internal::$loader = loader;
				
				// Progression を作成する
				_managerFromDocument = prml ? Progression.createFromXML( container, prml ) : new Progression( _managerId, container, _rootClass );
				
				// コンテナを設定する
				_container = _managerFromDocument.root.container;
				
				// 更新する
				updateManager();
				
				if ( loader ) {
					// イベントを送出する
					_manager.root.dispatchEvent( new SceneEvent( SceneEvent.SCENE_ADDED, true, false ) );
					_manager.root.dispatchEvent( new SceneEvent( SceneEvent.SCENE_ADDED_TO_ROOT, true, false ) );
				}
			}
			
			// 破棄する
			_managerId = null;
			_rootClass = null;
			
			return Boolean( !!manager );
		}
		
		/**
		 * @private
		 */
		progression_internal function $dispose():void {
			// Progression を破棄する
			_manager.progression_internal::$dispose();
			_manager = null;
			
			// コンテナを破棄する
			_container = this;
			
			// イベントを送出する
			super.dispatchEvent( new ManagerEvent( ManagerEvent.MANAGER_DEACTIVATE ) );
		}
		
		/**
		 * 対象のプロパティ値を取得します。
		 */
		private function _getProperty( name:String ):* {
			var result:* = null;
			
			if ( _internallyCalled ) {
				return super[ name ];
			}
			else {
				_internallyCalled = true;
				result = _container ? _container[ name ] : super[ name ];
				_internallyCalled = false;
			}
			
			return result;
		}
		
		/**
		 * 対象のメソッドを実行します。
		 */
		private function _applyFunction( name:String, ... args:Array ):* {
			var result:*;
			
			if ( _internallyCalled ) {
				return super[ name ].apply( this, args );
			}
			else {
				_internallyCalled = true;
				if ( _container && name in _container ) {
					result = _container[ name ].apply( null, args );
				}
				else {
					result = super[ name ].apply( null, args );
				}
				_internallyCalled = false;
			}
			
			return result;
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
			// 現在のマネージャーを取得する
			var oldManager:Progression = _manager;
			
			// 新しいマネージャーを取得する
			if ( _managerFromDocument ) {
				_manager = _managerFromDocument;
			}
			else {
				// 新しいマネージャーを取得する
				_manager = Progression.progression_internal::$getManagerByContainer( this );
			}
			
			// 変更されていなければ終了する
			if ( _manager == oldManager ) { return Boolean( !!_manager ); }
			
			// イベントを送出する
			if ( _manager ) {
				// ExecutorObject を作成する
				var classRef:Class = Progression.config.executor;
				_executor = new classRef( this );
				
				// コンテクストメニューを設定する
				this["_contextMenuBuilder"] = Progression.config.contextMenuBuilder;
				
				super.dispatchEvent( new ManagerEvent( ManagerEvent.MANAGER_ACTIVATE, false, false, _manager ) );
			}
			else {
				super.dispatchEvent( new ManagerEvent( ManagerEvent.MANAGER_DEACTIVATE, false, false, oldManager ) );
			}
			
			return Boolean( !!_manager );
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
		 * <span lang="ja">この DisplayObjectContainer インスタンスに子 DisplayObject インスタンスを追加します。</span>
		 * <span lang="en">Adds a child DisplayObject instance to this DisplayObjectContainer instance.</span>
		 * 
		 * @param child
		 * <span lang="ja">対象の DisplayObjectContainer インスタンスの子として追加する DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance to add as a child of this DisplayObjectContainer instance.</span>
		 * @return
		 * <span lang="en">child パラメータで渡す DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance that you pass in the child parameter.</span>
		 */
		override public function addChild( child:DisplayObject ):DisplayObject {
			return _applyFunction( "addChild", child ) as DisplayObject;
		}
		
		/**
		 * <span lang="ja">この DisplayObjectContainer インスタンスの指定されたインデックス位置に子 DisplayObject インスタンスを追加します。</span>
		 * <span lang="en">Adds a child DisplayObject instance to this DisplayObjectContainer instance.</span>
		 * 
		 * @param child
		 * <span lang="ja">対象の DisplayObjectContainer インスタンスの子として追加する DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance to add as a child of this DisplayObjectContainer instance.</span>
		 * @param index
		 * <span lang="ja">子を追加するインデックス位置です。</span>
		 * <span lang="en">The index position to which the child is added. If you specify a currently occupied index position, the child object that exists at that position and all higher positions are moved up one position in the child list.</span>
		 * @return
		 * <span lang="en">child パラメータで渡す DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance that you pass in the child parameter.</span>
		 */
		override public function addChildAt( child:DisplayObject, index:int ):DisplayObject {
			return _applyFunction( "addChildAt", child, index ) as DisplayObject;
		}
		
		/**
		 * <span lang="ja">この DisplayObjectContainer インスタンスの指定されたインデックス位置に子 DisplayObject インスタンスを追加します。</span>
		 * <span lang="en">Adds a child DisplayObject instance to this DisplayObjectContainer instance.</span>
		 * 
		 * @param child
		 * <span lang="ja">対象の DisplayObjectContainer インスタンスの子として追加する DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance to add as a child of this DisplayObjectContainer instance.</span>
		 * @param index
		 * <span lang="ja">子を追加するインデックス位置です。</span>
		 * <span lang="en">The index position to which the child is added. If you specify a currently occupied index position, the child object that exists at that position and all higher positions are moved up one position in the child list.</span>
		 * @return
		 * <span lang="en">child パラメータで渡す DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance that you pass in the child parameter.</span>
		 */
		override public function addChildAtAbove( child:DisplayObject, index:int ):DisplayObject {
			return _applyFunction( "addChildAtAbove", child, index ) as DisplayObject;
		}
		
		/**
		 * <span lang="ja">DisplayObjectContainer インスタンスの子リストから指定の DisplayObject インスタンスを削除します。</span>
		 * <span lang="en">Removes the specified child DisplayObject instance from the child list of the DisplayObjectContainer instance.</span>
		 * 
		 * @param child
		 * <span lang="ja">対象の DisplayObjectContainer インスタンスの子から削除する DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance to remove.</span>
		 * @return
		 * <span lang="en">child パラメータで渡す DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance that you pass in the child parameter.</span>
		 */
		override public function removeChild( child:DisplayObject ):DisplayObject {
			return _applyFunction( "removeChild", child ) as DisplayObject;
		}
		
		/**
		 * <span lang="ja">DisplayObjectContainer の子リストの指定されたインデックス位置から子 DisplayObject インスタンスを削除します。</span>
		 * <span lang="en">Removes a child DisplayObject from the specified index position in the child list of the DisplayObjectContainer.</span>
		 * 
		 * @param index
		 * <span lang="ja">削除する DisplayObject の子インデックスです。</span>
		 * <span lang="en">The child index of the DisplayObject to remove.</span>
		 * @return
		 * <span lang="ja">削除された DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance that was removed.</span>
		 */
		override public function removeChildAt( index:int ):DisplayObject {
			return _applyFunction( "removeChildAt", index ) as DisplayObject;
		}
		
		/**
		 * <span lang="ja">DisplayObjectContainer に追加されている全ての子 DisplayObject インスタンスを削除します。</span>
		 * <span lang="en">Remove the whole child DisplayObject instance which added to the DisplayObjectContainer.</span>
		 */
		override public function removeAllChildren():void {
			_applyFunction( "removeAllChildren" );
		}
		
		/**
		 * <span lang="ja">指定された表示オブジェクトが DisplayObjectContainer インスタンスの子であるか、オブジェクト自体であるかを指定します。</span>
		 * <span lang="en">Determines whether the specified display object is a child of the DisplayObjectContainer instance or the instance itself.</span>
		 * 
		 * @param child
		 * <span lang="ja">テストする子 DisplayObject インスタンスです。</span>
		 * <span lang="en">The child object to test.</span>
		 * @return
		 * <span lang="en">child インスタンスが DisplayObjectContainer の子であるか、コンテナ自体である場合は true となります。そうでない場合は false となります。</span>
		 * <span lang="en">true if the child object is a child of the DisplayObjectContainer or the container itself; otherwise false.</span>
		 */
		override public function contains( child:DisplayObject ):Boolean {
			return _applyFunction( "contains", child ) as Boolean;
		}
		
		/**
		 * <span lang="ja">指定のインデックス位置にある子表示オブジェクトオブジェクトを返します。</span>
		 * <span lang="en">Returns the child display object instance that exists at the specified index.</span>
		 * 
		 * @param index
		 * <span lang="ja">子 DisplayObject インスタンスのインデックス位置です。</span>
		 * <span lang="en">The index position of the child object.</span>
		 * @return
		 * <span lang="ja">指定されたインデックス位置にある子 DisplayObject インスタンスです。</span>
		 * <span lang="en">The child display object at the specified index position.</span>
		 */
		override public function getChildAt( index:int ):DisplayObject {
			return _applyFunction( "getChildAt", index ) as DisplayObject;
		}
		
		/**
		 * <span lang="ja">指定された名前に一致する子表示オブジェクトを返します。</span>
		 * <span lang="en">Returns the child display object that exists with the specified name.</span>
		 * 
		 * @param name
		 * <span lang="ja">返される子 DisplayObject インスタンスの名前です。</span>
		 * <span lang="en">The name of the child to return.</span>
		 * @return
		 * <span lang="ja">指定された名前を持つ子 DisplayObject インスタンスです。</span>
		 * <span lang="en">The child display object with the specified name.</span>
		 */
		override public function getChildByName( name:String ):DisplayObject {
			return _applyFunction( "getChildByName", name ) as DisplayObject;
		}
		
		/**
		 * <span lang="ja">子 DisplayObject インスタンスのインデックス位置を返します。</span>
		 * <span lang="en">Returns the index position of a child DisplayObject instance.</span>
		 * 
		 * @param child
		 * <span lang="ja">特定する子 DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance to identify.</span>
		 * @return
		 * <span lang="ja">特定する子 DisplayObject インスタンスのインデックス位置です。</span>
		 * <span lang="en">The index position of the child display object to identify.</span>
		 */
		override public function getChildIndex( child:DisplayObject ):int {
			return _applyFunction( "getChildIndex", child ) as int;
		}
		
		/**
		 * <span lang="ja">表示オブジェクトコンテナの既存の子の位置を変更します。</span>
		 * <span lang="en">Changes the position of an existing child in the display object container.</span>
		 * 
		 * @param child
		 * <span lang="ja">インデックス番号を変更する子 DisplayObject インスタンスです。</span>
		 * <span lang="en">The child DisplayObject instance for which you want to change the index number.</span>
		 * @param index
		 * <span lang="en">child インスタンスの結果のインデックス番号です。</span>
		 * <span lang="en">The resulting index number for the child display object.</span>
		 */
		override public function setChildIndex( child:DisplayObject, index:int ):void {
			_applyFunction( "setChildIndex", child, index );
		}
		
		/**
		 * <span lang="ja">表示オブジェクトコンテナの既存の子の位置を変更します。</span>
		 * <span lang="en">Changes the position of an existing child in the display object container.</span>
		 * 
		 * @param child
		 * <span lang="ja">インデックス番号を変更する子 DisplayObject インスタンスです。</span>
		 * <span lang="en">The child DisplayObject instance for which you want to change the index number.</span>
		 * @param index
		 * <span lang="en">child インスタンスの結果のインデックス番号です。</span>
		 * <span lang="en">The resulting index number for the child display object.</span>
		 */
		override public function setChildIndexAbove( child:DisplayObject, index:int ):void {
			_applyFunction( "setChildIndexAbove", child, index );
		}
		
		/**
		 * <span lang="ja">指定された 2 つの子オブジェクトの z 順序（重ね順）を入れ替えます。</span>
		 * <span lang="en">Swaps the z-order (front-to-back order) of the two specified child objects.</span>
		 * 
		 * @param child1
		 * <span lang="ja">先頭の子 DisplayObject インスタンスです。</span>
		 * <span lang="en">The first child object.</span>
		 * @param child2
		 * <span lang="ja">2 番目の子 DisplayObject インスタンスです。</span>
		 * <span lang="en">The second child object.</span>
		 */
		override public function swapChildren( child1:DisplayObject, child2:DisplayObject ):void {
			_applyFunction( "swapChildren", child1, child2 );
		}
		
		/**
		 * <span lang="ja">子リスト内の指定されたインデックス位置に該当する 2 つの子オブジェクトの z 順序（重ね順）を入れ替えます。</span>
		 * <span lang="en">Swaps the z-order (front-to-back order) of the child objects at the two specified index positions in the child list.</span>
		 * 
		 * @param index1
		 * <span lang="ja">最初の子 DisplayObject インスタンスのインデックス位置です。</span>
		 * <span lang="en">The index position of the first child object.</span>
		 * @param index2
		 * <span lang="ja">2 番目の子 DisplayObject インスタンスのインデックス位置です。</span>
		 * <span lang="en">The index position of the second child object.</span>
		 */
		override public function swapChildrenAt( index1:int, index2:int ):void {
			_applyFunction( "swapChildrenAt", index1, index2 );
		}
		
		
		
		
		
		/**
		 * SWF ファイルの読み込みが完了し、stage 及び loaderInfo にアクセス可能になった場合に送出されます。
		 */
		private function _ready( e:ExEvent ):void {
			// イベントリスナーを解除する
			super.removeEventListener( ExEvent.EX_READY, _ready );
			
			// Progression が存在しなければ
			if ( !_manager ) {
				progression_internal::$initialize( null, null, this );
			}
			
			// イベントハンドラメソッドを実行する
			( _onReady as Function || atReady as Function ).apply( this );
		}
		
		
		
		
		
		/**
		 * 外部 ActionScript ファイルを取り込む
		 */
		include "../core/includes/CastObject_contextMenu.inc"
	}
}
