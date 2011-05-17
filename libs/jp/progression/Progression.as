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
package jp.progression {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	import jp.nium.collections.IdGroupCollection;
	import jp.nium.collections.IIdGroup;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ObjectUtil;
	import jp.nium.utils.StageUtil;
	import jp.nium.utils.StringUtil;
	import jp.progression.core.impls.IManageable;
	import jp.progression.core.L10N.L10NProgressionMsg;
	import jp.progression.core.managers.IHistoryManager;
	import jp.progression.core.managers.IInitializer;
	import jp.progression.core.managers.ISynchronizer;
	import jp.progression.core.managers.SceneManager;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.core.PackageInfo;
	import jp.progression.core.proto.Configuration;
	import jp.progression.events.ManagerEvent;
	import jp.progression.events.ProcessEvent;
	import jp.progression.events.SceneEvent;
	import jp.progression.scenes.SceneId;
	import jp.progression.scenes.SceneLoader;
	import jp.progression.scenes.SceneObject;
	import jp.progression.ui.IContextMenuBuilder;
	import jp.progression.ui.IKeyboardMapper;
	
	/**
	 * <span lang="ja">シーン移動処理が実行可能になった瞬間に送出されます。
	 * このイベントが送出される以前に実行された移動命令は、実行可能になるまでスタックされます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.ManagerEvent.MANAGER_READY
	 */
	[Event( name="managerReady", type="jp.progression.events.ManagerEvent" )]
	
	/**
	 * <span lang="ja">オブジェクトの lock プロパティの値が変更されたときに送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.ManagerEvent.MANAGER_LOCK_CHANGE
	 */
	[Event( name="managerLockChange", type="jp.progression.events.ManagerEvent" )]
	
	/**
	 * <span lang="ja">管理下にあるシーンの移動処理が開始された場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.ProcessEvent.PROCESS_START
	 */
	[Event( name="processStart", type="jp.progression.events.ProcessEvent" )]
	
	/**
	 * <span lang="ja">管理下にあるシーンの移動処理中に対象シーンが変更された場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.ProcessEvent.PROCESS_SCENE
	 */
	[Event( name="processScene", type="jp.progression.events.ProcessEvent" )]
	
	/**
	 * <span lang="ja">管理下にあるシーンの移動処理中に対象シーンでイベントが発生した場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.ProcessEvent.PROCESS_EVENT
	 */
	[Event( name="processEvent", type="jp.progression.events.ProcessEvent" )]
	
	/**
	 * <span lang="ja">管理下にあるシーンの移動処理中に移動先が変更された場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.ProcessEvent.PROCESS_CHANGE
	 */
	[Event( name="processChange", type="jp.progression.events.ProcessEvent" )]
	
	/**
	 * <span lang="ja">管理下にあるシーンの移動処理が完了した場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.ProcessEvent.PROCESS_COMPLETE
	 */
	[Event( name="processComplete", type="jp.progression.events.ProcessEvent" )]
	
	/**
	 * <span lang="ja">管理下にあるシーンの移動処理が停止された場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.ProcessEvent.PROCESS_STOP
	 */
	[Event( name="processStop", type="jp.progression.events.ProcessEvent" )]
	
	/**
	 * <span lang="ja">シーン移動中にエラーが発生した場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.ProcessEvent.PROCESS_ERROR
	 */
	[Event( name="processError", type="jp.progression.events.ProcessEvent" )]
	
	/**
	 * <span lang="ja">Progression クラスは、Progression を使用するための基本クラスです。
	 * シーン作成やシーン移動の処理は、全て Progression インスタンスを通じて行います。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression#getManagerById()
	 * @see jp.progression#getManagersByGroup()
	 * @see jp.progression.casts.CastDocument
	 * @see jp.progression.events.ProcessEvent
	 * @see jp.progression.scenes.SceneId
	 * @see jp.progression.scenes.SceneObject
	 * @see jp.progression.config
	 * 
	 * @example <listing version="3.0">
	 * // 環境設定を指定する
	 * Progression.initialize( new BasicAppConfig() );
	 * 
	 * // Progression インスタンスを作成する
	 * var manager:Progression = new Progression( "index", stage );
	 * 
	 * // シーン構造を作成する
	 * manager.root.addScene( new SceneObject( "about" ) );
	 * manager.root.addScene( new SceneObject( "gallery" ) );
	 * manager.root.addScene( new SceneObject( "contact" ) );
	 * 
	 * // シーンを移動する
	 * manager.goto( new SceneId( "/index/about" ) );
	 * </listing>
	 */
	public class Progression extends EventDispatcher implements IIdGroup {
		
		/**
		 * <span lang="ja">パッケージの名前を取得します。</span>
		 * <span lang="en">Package name</span>
		 */
		public static const NAME:String = "Progression";
		
		/**
		 * <span lang="ja">パッケージのバージョン情報を取得します。</span>
		 * <span lang="en"></span>
		 */
		public static const VERSION:String = "4.0.22";
		
		/**
		 * <span lang="ja">パッケージの制作者を取得します。</span>
		 * <span lang="en"></span>
		 */
		public static const AUTHOR:String = "Copyright (C) 2007-2010 taka:nium.jp, All Rights Reserved.";
		
		/**
		 * <span lang="ja">パッケージの URL を取得します。</span>
		 * <span lang="en"></span>
		 */
		public static const URL:String = "http://progression.jp/";
		
		/**
		 * @private
		 */
		progression_internal static const $BUILT_ON_LABEL:String = "Built on " + Progression.NAME + " " + Progression.VERSION.split( "." )[0];
		
		/**
		 * @private
		 */
		progression_internal static function get $BUILT_ON_URL():String {
			var url:String = Progression.URL + "built_on/";
			var info:Object = {
				ver	:Progression.VERSION,
				twn	:int( PackageInfo.hasTweener ),
				sad	:int( PackageInfo.hasSWFAddress ),
				ssz	:int( PackageInfo.hasSWFSize ),
				swh	:int( PackageInfo.hasSWFWheel )
			};
			
			url += "?" + ObjectUtil.toQueryString( info );
			
			return encodeURI( url );
		}
		
		/**
		 * <span lang="ja">初期化時に指定された Configuration を取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #initialize()
		 */
		public static function get config():Configuration { return _config; }
		private static var _config:Configuration;
		
		/**
		 * <span lang="ja">現在同期中の Progression インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #sync
		 */
		public static function get syncedManager():Progression { return _syncedManager; }
		private static var _syncedManager:Progression;
		
		/**
		 * @private
		 */
		progression_internal static const $collection:IdGroupCollection = new IdGroupCollection();
		
		/**
		 * @private
		 */
		progression_internal static var $loader:SceneLoader;
		
		/**
		 * 
		 */
		private static var _containers:Dictionary = new Dictionary( true );
		
		/**
		 * Stage インスタンスを取得します。 
		 */
		private static var _stage:Stage;
		
		
		
		
		
		/**
		 * <span lang="ja">インスタンスの識別子を取得します。</span>
		 * <span lang="en">Indicates the instance id of the Progression.</span>
		 * 
		 * @see jp.progression#getManagerById()
		 */
		public function get id():String { return _id; }
		public function set id( value:String ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_013 ).toString( "id" ) ); }
		private var _id:String;
		
		/**
		 * <span lang="ja">インスタンスのグループ名を取得または設定します。</span>
		 * <span lang="en">Indicates the instance group of the Progression.</span>
		 * 
		 * @see jp.progression#getManagersByGroup()
		 */
		public function get group():String { return _group; }
		public function set group( value:String ):void { _group = Progression.progression_internal::$collection.registerGroup( this, value ) ? value : null;  }
		private var _group:String;
		
		/**
		 * <span lang="ja">関連付けられている Stage インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get stage():Stage { return _stage; }
		
		/**
		 * <span lang="ja">シーンツリーの最上位に位置する SceneObject インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get root():SceneObject { return _root; }
		private var _root:SceneObject;
		
		/**
		 * <span lang="ja">現在位置となる SceneObject インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get current():SceneObject {
			var sceneId:SceneId = currentSceneId;
			
			// 存在しなければ終了する
			if ( !sceneId || SceneId.isNaS( sceneId ) ) { return null; }
			
			return SceneObject.progression_internal::$getSceneBySceneId( currentSceneId );
		}
		
		/**
		 * <span lang="ja">現在位置を示すシーン識別子を取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #departedSceneId
		 * @see #destinedSceneId
		 * @see #syncedSceneId
		 */
		public function get currentSceneId():SceneId {
			if ( !_sceneManager ) { return SceneId.NaS; }
			if ( _loaderManager ) {
				if ( _loaderManager.currentSceneId.length <= _root.sceneId.length ) { return SceneId.NaS; }
				return _root.globalToLocal( _loaderManager.currentSceneId );
			}
			
			return _sceneManager.currentSceneId;
		}
		
		/**
		 * <span lang="ja">出発位置を示すシーン識別子を取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #currentSceneId
		 * @see #destinedSceneId
		 * @see #syncedSceneId
		 */
		public function get departedSceneId():SceneId {
			if ( !_sceneManager ) { return SceneId.NaS; }
			if ( _loaderManager ) {
				if ( _loaderManager.departedSceneId.length <= _root.sceneId.length ) { return SceneId.NaS; }
				return _root.globalToLocal( _loaderManager.departedSceneId );
			}
			
			return _sceneManager.departedSceneId;
		}
		
		/**
		 * <span lang="ja">目的位置を示すシーン識別子を取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #currentSceneId
		 * @see #departedSceneId
		 * @see #syncedSceneId
		 */
		public function get destinedSceneId():SceneId {
			if ( !_sceneManager ) { return SceneId.NaS; }
			if ( _loaderManager ) {
				if ( _loaderManager.destinedSceneId.length <= _root.sceneId.length ) { return SceneId.NaS; }
				return _root.globalToLocal( _loaderManager.destinedSceneId );
			}
			
			return _sceneManager.destinedSceneId;
		}
		
		/**
		 * <span lang="ja">同期機能が有効化された状態でのシーン識別子を取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #currentSceneId
		 * @see #departedSceneId
		 * @see #destinedSceneId
		 */
		public function get syncedSceneId():SceneId {
			if ( !_synchronizer || !_synchronizer.enabled ) { return _root.sceneId; }
			
			return _synchronizer.sceneId;
		}
		
		/**
		 * <span lang="ja">現在のイベントタイプを取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #goto()
		 * @see jp.progression.events.SceneEvent
		 */
		public function get eventType():String { return _sceneManager.eventType; }
		
		/**
		 * <span lang="ja">現在の処理状態を取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #goto()
		 * @see jp.progression.executors.ExecutorObjectState
		 */
		public function get state():int { return _sceneManager ? _sceneManager.state : -1; }
		
		/**
		 * <span lang="ja">この Progression インスタンスに関する履歴を管理している IHistoryManager インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #goto()
		 * @see #jumpto()
		 */
		public function get history():IHistoryManager { return _history; }
		private var _history:IHistoryManager;
		
		/**
		 * <span lang="ja">この Progression インスタンスを同期対象として設定するかどうかを取得または設定します。
		 * 同期対象として有効化するためには、Progression を初期化する際にシンクロ機能に対応している Configuration を設定しておく必要があります。</span>
		 * <span lang="en"></span>
		 * 
		 * @see jp.progression.config
		 */
		public function get sync():Boolean { return _synchronizer ? _synchronizer.enabled : false; }
		public function set sync( value:Boolean ):void {
			if ( _loader ) { return; }
			
			if ( !_synchronizer ) {
				if ( value ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_003 ).toString() ); }
				else { return; }
			}
			
			_synchronizer.enabled = value;
			_syncedManager = _synchronizer.syncedManager;
		}
		
		/**
		 * <span lang="ja">シーン移動処理の実行中に、新しい移動シーケンスの開始を無効化するかどうかを取得または設定します。
		 * このプロパティを設定すると autoLock プロパティが強制的に false に設定されます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #autoLock
		 * @see #goto()
		 * @see #jumpto()
		 */
		public function get lock():Boolean { return _sceneManager ? _sceneManager.lock : false; }
		public function set lock( value:Boolean ):void { _sceneManager.lock = value; }
		
		/**
		 * <span lang="ja">シーンの移動シーケンスが開始された場合に、自動的に lock プロパティを true にするかどうかを取得または設定します。
		 * 移動シーケンスが完了後には、lock プロパティは自動的に false に設定されます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #lock
		 * @see #goto()
		 * @see #jumpto()
		 */
		public function get autoLock():Boolean { return _sceneManager ? _sceneManager.autoLock : false; }
		public function set autoLock( value:Boolean ):void { _sceneManager.autoLock = value; }
		
		/**
		 * <span lang="ja">実行時のリレーオブジェクトを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get extra():Object { return _sceneManager ? _sceneManager.extra : null; }
		
		/**
		 * 
		 */
		private var _container:DisplayObjectContainer;
		
		/**
		 * SceneLoader インスタンスを取得します。
		 */
		private var _loader:SceneLoader;
		
		/**
		 * Progression インスタンスを取得します。
		 */
		private var _loaderManager:Progression;
		
		/**
		 * IInitializer インスタンスを取得します。 
		 */
		private var _initializer:IInitializer;
		
		/**
		 * ISynchronizer インスタンスを取得します。 
		 */
		private var _synchronizer:ISynchronizer;
		
		/**
		 * SceneManager インスタンスを取得します。 
		 */
		private var _sceneManager:SceneManager;
		
		/**
		 * IKeyboardMapper インスタンスを取得します。 
		 */
		private var _keyboardMapper:IKeyboardMapper;
		
		/**
		 * IContextMenuBuilder インスタンスを取得します。
		 */
		private var _contextMenuBuilder:IContextMenuBuilder;
		private var _contextMenuBuilderStage:IContextMenuBuilder;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい Progression インスタンスを作成します。</span>
		 * <span lang="en">Creates a new Progression object.</span>
		 * 
		 * @param id
		 * <span lang="ja">インスタンスの識別子です。</span>
		 * <span lang="en"></span>
		 * @param container
		 * <span lang="ja">関連付けたい DisplayObjectContainer インスタンスです。</span>
		 * <span lang="en"></span>
		 * @param rootClass
		 * <span lang="ja">ルートシーンに関連付けたいクラスの参照です。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function Progression( id:String, container:DisplayObjectContainer, rootClass:Class = null, initObject:Object = null ) {
			// クラスをコンパイルに含める
			progression_internal;
			
			// まだ初期化されていなければ例外をスローする
			if ( !_config ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_014 ).toString() ); }
			
			// すでに登録されていれば例外をスローする
			if ( !id ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_007 ).toString() ); }
			
			// すでに登録されていれば例外をスローする
			if ( Progression.progression_internal::$collection.getInstanceById( id ) ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_005 ).toString( "Progression", id ) ); }
			
			// 引数を設定する
			_id = id;
			
			// コンテナを設定する
			var stage:Stage;
			switch ( true ) {
				case container is Stage		: {
					stage = Stage( container );
					
					if ( PackageInfo.preloaderClassRef ) {
						container = PackageInfo.preloaderClassRef.progression_internal::$loader.content || PackageInfo.preloaderClassRef.progression_internal::$background;
					}
					else {
						container = StageUtil.getDocument( stage );
					}
					break;
				}
				case container is Sprite	: {
					stage = container.stage;
					_container = container;
					break;
				}
				default						: { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_027 ).toString() ); }
			}
			
			// ステージが存在しなければ例外をスローする
			if ( !stage ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_028 ).toString() ); }
			
			// コンテナの関係性を設定する
			_stage = stage;
			_containers[container] ||= this;
			
			// SceneLoader を取得する
			_loader = Progression.progression_internal::$loader;
			
			// SceneLoader で読み込まれていなければ
			if ( !_loader ) {
				// IInitializer を作成する
				var cls:Class = _config.initializer as Class;
				if ( cls ) {
					_initializer = new cls( this );
				}
			}
			
			// SceneManager を作成する
			_sceneManager = SceneManager.progression_internal::$createInstance( this );
			
			// HistoryManager を作成する
			cls = _config.historyManager as Class;
			if ( cls ) {
				_history = new cls( this );
			}
			
			// SceneLoader で読み込まれていなければ
			if ( !_loader ) {
				// ISynchronizer を作成する
				cls = _config.synchronizer as Class;
				if ( cls ) {
					_synchronizer = new cls( this );
					_synchronizer.addEventListener( Event.COMPLETE, _complete );
				}
				
				// IKeyboardMapper を作成する
				cls = _config.keyboardMapper as Class;
				if ( cls ) {
					_keyboardMapper = new cls( this );
				}
			}
			
			// マネージャーとの関連付けを更新する
			var manageable:IManageable = container as IManageable;
			if ( manageable ) {
				// Progression との関連付けを行う
				manageable.updateManager();
			}
			else {
				// コンテクストメニューを作成する
				cls = Progression.config.contextMenuBuilder;
				if ( cls ) {
					_contextMenuBuilder = new cls( container );
				}
			}
			
			// ルート用のコンテクストメニューを作成する
			var root:Sprite = _stage.getChildAt( 0 ) as Sprite;
			manageable = root as IManageable;
			if ( !manageable ) {
				cls = Progression.config.contextMenuBuilder;
				if ( cls ) {
					_contextMenuBuilderStage = new cls( _stage.getChildAt( 0 ) );
				}
			}
			
			// rootClass を作成する
			SceneObject.progression_internal::$manager = this;
			SceneObject.progression_internal::$container = Sprite( container );
			SceneObject.progression_internal::$loader = _loader;
			
			var classRef:Class = rootClass || SceneObject;
			_root = new classRef();
			
			// イベントを送出する
			_root.dispatchEvent( new ManagerEvent( ManagerEvent.MANAGER_ACTIVATE, false, false, this ) );
			_root.dispatchEvent( new SceneEvent( SceneEvent.SCENE_ADDED, true ) );
			if ( !_loader || _loader.root ) {
				_root.dispatchEvent( new SceneEvent( SceneEvent.SCENE_ADDED_TO_ROOT, true ) );
			}
			
			// イベントリスナーを登録する
			if ( _loader ) {
				_loader.addEventListener( ManagerEvent.MANAGER_ACTIVATE, _managerActivate );
				_loader.addEventListener( ManagerEvent.MANAGER_DEACTIVATE, _managerDeactivate );
				
				if ( _loader.manager ) {
					_managerActivate( null );
				}
			}
			
			// 初期化する
			ObjectUtil.setProperties( this, initObject );
			
			// 破棄する
			Progression.progression_internal::$loader = null;
			
			// SceneLoader で読み込まれておらず、ISynchronizer が存在すれば
			if ( !_loader && _synchronizer ) {
				// 同期を開始する
				_synchronizer.start();
			}
			else {
				// イベントを送出する
				setTimeout( super.dispatchEvent, 0, new ManagerEvent( ManagerEvent.MANAGER_READY, false, false, this ) );
			}
			
			// コレクションに登録する
			Progression.progression_internal::$collection.addInstance( this );
			if ( !Progression.progression_internal::$collection.registerId( this, id ) ) {
				_id = null;
			}
		}
		
		
		
		
		
		/**
		 * <span lang="ja">Progression を初期化します。
		 * この処理は Progression インスタンスを作成する前の状態で 1 回のみ行うことができます。</span>
		 * <span lang="en"></span>
		 * 
		 * @param config
		 * <span lang="ja">初期化情報として使用したい Configuration インスタンスです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">初期化に成功した場合には true を、失敗した場合には false を返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #config
		 * @see jp.progression.config
		 * 
		 * @example <listing version="3.0">
		 * // 環境設定を指定する
		 * Progression.initialize( new BasicAppConfig() );
		 * 
		 * // Progression インスタンスを作成する
		 * var manager:Progression = new Progression( "index", stage );
		 * </listing>
		 */
		public static function initialize( config:Configuration ):Boolean {
			if ( _config ) { return false; }
			
			_config = config;
			
			return true;
		}
		
		/**
		 * <span lang="ja">XML データから Progression インスタンスを生成します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param stage
		 * <span lang="ja">関連付けたい Stage インスタンスです。</span>
		 * <span lang="en"></span>
		 * @param prml
		 * <span lang="ja">生成時に使用する設定情報を含んだ XML オブジェクトです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">生成された Progression インスタンスです。</span>
		 * <span lang="en"></span>
		 * 
		 * @example <listing version="3.0">
		 * // 環境設定を指定する
		 * Progression.initialize( new BasicAppConfig() );
		 * 
		 * // XML データを作成する
		 * var prml:XML =
		 * &lt;prml version=&quot;2.0.0&quot; type=&quot;text/prml.plain&quot;&gt;
		 * 	&lt;scene name=&quot;index&quot;&gt;
		 * 		&lt;scene name=&quot;about&quot;&gt;
		 * 		&lt;/scene&gt;
		 * 		&lt;scene name=&quot;gallery&quot;&gt;
		 * 		&lt;/scene&gt;
		 * 		&lt;scene name=&quot;contact&quot;&gt;
		 * 		&lt;/scene&gt;
		 * 	&lt;/scene&gt;
		 * &lt;/prml&gt;;
		 * 
		 * // XML データから Progression インスタンスを作成する
		 * var manager:Progression = Progression.createFromXML( stage, prml );
		 * </listing>
		 */
		public static function createFromXML( container:DisplayObjectContainer, prml:XML ):Progression {
			// cls が省略されていれば SceneObject を設定する
			for each ( var scene:XML in prml..scene ) {
				var cls:String = scene.@cls;
				
				if ( cls ) { continue; }
				
				scene.@cls = "jp.progression.scenes.SceneObject";
			}
			
			// XML の構文が間違っていれば例外をスローする
			if ( !SceneObject.validate( prml ) ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_016 ).toString( "XML" ) ); }
			
			// ルートシーンの情報を取得する
			var root:XML = prml.scene[0] as XML;
			cls = String( root.attribute( "cls" ) );
			var managerId:String = String( root.attribute( "name" ) );
			var rootClass:Class = cls ? getDefinitionByName( cls ) as Class : SceneObject;
			
			// ルートのみ削除した PRML データを作成する
			prml.scene = prml.scene[0].scene;
			
			// Progression を作成する
			var manager:Progression = new Progression( managerId, container, rootClass );
			
			// ルートシーンを初期化する
			for each ( var attribute:XML in root.attributes() ) {
				var attrName:String = String( attribute.name() );
				
				if ( attrName == "name" ) { continue; }
				if ( !( attrName in manager.root ) ) { continue; }
				
				manager.root[attrName] = StringUtil.toProperType( attribute );
			}
			
			// DataHolder を更新する
			SceneObject.progression_internal::$providingData = root.*.( name() != "scene" );
			manager.root.dataHolder.update();
			
			// ルートシーン以下に子シーンを作成する
			if ( prml.scene.length() > 0 ) {
				manager.root.addSceneFromXML( prml );
			}
			
			return manager;
		}
		
		/**
		 * @private
		 */
		progression_internal static function $getManagerByContainer( container:DisplayObjectContainer ):Progression {
			for ( var target:* in _containers ) {
				if ( container == target ) {
					return Progression( _containers[target] );
				}
			}
			
			return null;
		}
		
		
		
		
		
		/**
		 * <span lang="ja">インスタンスに対して、複数のプロパティを一括設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param parameters
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">自身の参照です。</span>
		 * <span lang="en"></span>
		 */
		public function setProperties( parameters:Object ):Progression {
			ObjectUtil.setProperties( this, parameters );
			return this;
		}
		
		/**
		 * <span lang="ja">シーンを移動します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param sceneId
		 * <span lang="ja">移動先を示すシーン識別子です。</span>
		 * <span lang="en"></span>
		 * @param extra
		 * <span lang="ja">実行時にコマンドフローをリレーするオブジェクトです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">移動処理が正常に実行された場合は true を、それ以外は false を返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #jumpto()
		 * @see #stop()
		 */
		public function goto( sceneId:SceneId, extra:Object = null ):Boolean {
			// 読み込まれた Progression インスタンスであれば
			if ( _loader ) { return _loader.manager.goto( _root.localToGlobal( sceneId ), extra ); }
			
			return _sceneManager.goto( sceneId, extra );
		}
		
		/**
		 * <span lang="ja">シーン移動に関係した処理を全て無視して、すぐに移動します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param sceneId
		 * <span lang="ja">移動先を示すシーン識別子です。</span>
		 * <span lang="en"></span>
		 * @param extra
		 * <span lang="ja">実行時にコマンドフローをリレーするオブジェクトです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">移動処理が正常に実行された場合は true を、それ以外は false を返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #goto()
		 * @see #stop()
		 */
		public function jumpto( sceneId:SceneId, extra:Object = null ):Boolean {
			// 読み込まれた Progression インスタンスであれば
			if ( _loader ) { return _loader.manager.jumpto( _root.localToGlobal( sceneId ), extra ); }
			
			return _sceneManager.jumpto( sceneId, extra );
		}
		
		/**
		 * <span lang="ja">シーン移動処理を中断します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #goto()
		 * @see #jumpto()
		 */
		public function stop():void {
			// 読み込まれた Progression インスタンスであれば
			if ( _loader ) {
				_loader.manager.stop();
			}
			else {
				_sceneManager.stop();
			}
		}
		
		/**
		 * @private
		 */
		progression_internal function $dispose():void {
			// マネージャーが存在すれば
			if ( _loaderManager ) {
				// イベントリスナーを解除する
				_loader.manager.removeEventListener( ProcessEvent.PROCESS_START, super.dispatchEvent );
				_loader.manager.removeEventListener( ProcessEvent.PROCESS_SCENE, super.dispatchEvent );
				_loader.manager.removeEventListener( ProcessEvent.PROCESS_EVENT, super.dispatchEvent );
				_loader.manager.removeEventListener( ProcessEvent.PROCESS_CHANGE, super.dispatchEvent );
				_loader.manager.removeEventListener( ProcessEvent.PROCESS_COMPLETE, super.dispatchEvent );
				_loader.manager.removeEventListener( ProcessEvent.PROCESS_STOP, super.dispatchEvent );
				_loader.manager.removeEventListener( ManagerEvent.MANAGER_LOCK_CHANGE, super.dispatchEvent );
				
				_loaderManager = null;
			}
			
			// SceneLoader が存在すれば
			if ( _loader ) {
				_loader.removeEventListener( ManagerEvent.MANAGER_ACTIVATE, _managerActivate );
				_loader.removeEventListener( ManagerEvent.MANAGER_DEACTIVATE, _managerDeactivate );
				
				_loader = null;
			}
			
			// 登録を破棄する
			Progression.progression_internal::$collection.registerId( this, null );
			_id = null;
			
			for ( var container:* in _containers ) {
				if ( _containers[container] == this ) {
					delete _containers[container];
					
					var manageable:IManageable = container as IManageable;
					if ( manageable ) {
						manageable.updateManager();
					}
					
					return;
				}
			}
			
			// ルートシーンを破棄する
			_root.progression_internal::$dispose();
			_root = null;
			
			// SceneManager を破棄する
			_sceneManager.progression_internal::$dispose();
			_sceneManager = null;
			
			// HistoryManager を破棄する
			_history.progression_internal::$dispose();
			_history = null;
			
			// IInitializer を破棄する
			if ( _initializer ) {
				_initializer.dispose();
			}
			
			// ISynchronizer を破棄する
			if ( _synchronizer ) {
				_synchronizer.dispose();
			}
			
			// 破棄する
			_keyboardMapper = null;
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
			return ObjectUtil.formatToString( this, "Progression", "id" );
		}
		
		
		
		
		
		/**
		 * シンクロナイザの準備が完了した場合に送出されます。
		 */
		private function _complete( e:Event ):void {
			// イベントリスナーを解除する
			_synchronizer.removeEventListener( Event.COMPLETE, _complete );
			
			// イベントを送出する
			super.dispatchEvent( new ManagerEvent( ManagerEvent.MANAGER_READY, false, false, this ) );
		}
		
		/**
		 * Progression インスタンスとの関連付けがアクティブになったときに送出されます。
		 */
		private function _managerActivate( e:ManagerEvent ):void {
			// マネージャーを取得する
			_loaderManager = _loader.manager;
			
			// イベントリスナーを登録する
			_loaderManager.addEventListener( ManagerEvent.MANAGER_LOCK_CHANGE, super.dispatchEvent );
			_loaderManager.addEventListener( ProcessEvent.PROCESS_START, super.dispatchEvent );
			_loaderManager.addEventListener( ProcessEvent.PROCESS_SCENE, super.dispatchEvent );
			_loaderManager.addEventListener( ProcessEvent.PROCESS_EVENT, super.dispatchEvent );
			_loaderManager.addEventListener( ProcessEvent.PROCESS_CHANGE, super.dispatchEvent );
			_loaderManager.addEventListener( ProcessEvent.PROCESS_COMPLETE, super.dispatchEvent );
			_loaderManager.addEventListener( ProcessEvent.PROCESS_STOP, super.dispatchEvent );
		}
		
		/**
		 * Progression インスタンスとの関連付けが非アクティブになったときに送出されます。
		 */
		private function _managerDeactivate( e:ManagerEvent ):void {
			// イベントリスナーを解除する
			_loaderManager.removeEventListener( ManagerEvent.MANAGER_LOCK_CHANGE, super.dispatchEvent );
			_loaderManager.removeEventListener( ProcessEvent.PROCESS_START, super.dispatchEvent );
			_loaderManager.removeEventListener( ProcessEvent.PROCESS_SCENE, super.dispatchEvent );
			_loaderManager.removeEventListener( ProcessEvent.PROCESS_EVENT, super.dispatchEvent );
			_loaderManager.removeEventListener( ProcessEvent.PROCESS_CHANGE, super.dispatchEvent );
			_loaderManager.removeEventListener( ProcessEvent.PROCESS_COMPLETE, super.dispatchEvent );
			_loaderManager.removeEventListener( ProcessEvent.PROCESS_STOP, super.dispatchEvent );
			
			// マネージャーを破棄する
			_loaderManager = null;
		}
	}
}
