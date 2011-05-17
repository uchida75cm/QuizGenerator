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
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.EventPhase;
	import flash.utils.getDefinitionByName;
	import jp.nium.collections.IdGroupCollection;
	import jp.nium.collections.IIdGroup;
	import jp.nium.collections.UniqueList;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.core.ns.nium_internal;
	import jp.nium.core.primitives.StringObject;
	import jp.nium.utils.ClassUtil;
	import jp.nium.utils.ObjectUtil;
	import jp.nium.utils.StringUtil;
	import jp.progression.core.impls.IDisposable;
	import jp.progression.core.impls.IExecutable;
	import jp.progression.core.impls.IManageable;
	import jp.progression.core.L10N.L10NProgressionMsg;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.core.PackageInfo;
	import jp.progression.data.DataHolder;
	import jp.progression.events.ManagerEvent;
	import jp.progression.events.SceneEvent;
	import jp.progression.executors.ExecutorObject;
	import jp.progression.Progression;
	
	/**
	 * <span lang="ja">シーン移動時に目的地がシーンオブジェクト自身もしくは子階層だった場合に、階層が変更された直後に送出されます。
	 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.SceneEvent.SCENE_LOAD
	 */
	[Event( name="sceneLoad", type="jp.progression.events.SceneEvent" )]
	
	/**
	 * <span lang="ja">シーン移動時に目的地がシーンオブジェクト自身もしくは親階層だった場合に、階層が変更される直前に送出されます。
	 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.SceneEvent.SCENE_UNLOAD
	 */
	[Event( name="sceneUnload", type="jp.progression.events.SceneEvent" )]
	
	/**
	 * <span lang="ja">シーンオブジェクト自身が目的地だった場合に、到達した瞬間に送出されます。
	 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.SceneEvent.SCENE_INIT
	 */
	[Event( name="sceneInit", type="jp.progression.events.SceneEvent" )]
	
	/**
	 * <span lang="ja">シーンオブジェクト自身が目的地だった場合に、イベント sceneInit の非同期処理が完了した瞬間に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.SceneEvent.SCENE_INIT_COMPLETE
	 */
	[Event( name="sceneInitComplete", type="jp.progression.events.SceneEvent" )]
	
	/**
	 * <span lang="ja">シーンオブジェクト自身が出発地だった場合に、移動を開始した瞬間に送出されます。
	 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.SceneEvent.SCENE_GOTO
	 */
	[Event( name="sceneGoto", type="jp.progression.events.SceneEvent" )]
	
	/**
	 * <span lang="ja">シーン移動時に目的地がシーンオブジェクトの子階層であり、かつ出発地ではない場合に、自身が移動を中継した瞬間に送出されます。
	 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.SceneEvent.SCENE_DESCEND
	 */
	[Event( name="sceneDescend", type="jp.progression.events.SceneEvent" )]
	
	/**
	 * <span lang="ja">シーン移動時に目的地がシーンオブジェクトの親階層であり、かつ出発地ではない場合に、自身が移動を中継した瞬間に送出されます。
	 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.SceneEvent.SCENE_ASCEND
	 */
	[Event( name="sceneAscend", type="jp.progression.events.SceneEvent" )]
	
	/**
	 * <span lang="ja">シーンオブジェクトがシーンリストに追加された場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.SceneEvent.SCENE_ADDED
	 */
	[Event( name="sceneAdded", type="jp.progression.events.SceneEvent" )]
	
	/**
	 * <span lang="ja">シーンオブジェクトが直接、またはシーンオブジェクトを含むサブツリーの追加により、ルートシーン上のシーンリストに追加されたときに送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.SceneEvent.SCENE_ADDED_TO_ROOT
	 */
	[Event( name="sceneAddedToRoot", type="jp.progression.events.SceneEvent" )]
	
	/**
	 * <span lang="ja">シーンオブジェクトがシーンリストから削除された場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.SceneEvent.SCENE_REMOVED
	 */
	[Event( name="sceneRemoved", type="jp.progression.events.SceneEvent" )]
	
	/**
	 * <span lang="ja">シーンオブジェクトが直接、またはシーンオブジェクトを含むサブツリーの削除により、ルートシーン上のシーンリストから削除されようとしているときに送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.SceneEvent.SCENE_REMOVED_FROM_ROOT
	 */
	[Event( name="sceneRemovedFromRoot", type="jp.progression.events.SceneEvent" )]
	
	/**
	 * <span lang="ja">シーンオブジェクトの title プロパティが変更された場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.SceneEvent.SCENE_TITLE_CHANGE
	 */
	[Event( name="sceneTitleChange", type="jp.progression.events.SceneEvent" )]
	
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
	 * <span lang="ja">非同期処理中にエラーが発生した場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.ExecuteErrorEvent.EXECUTE_ERROR
	 */
	[Event( name="executeError", type="jp.progression.events.ExecuteErrorEvent" )]
	
	/**
	 * <span lang="ja">SceneObject クラスは、シーンコンテナとして機能する全てのオブジェクトの基本クラスです。
	 * 
	 * "DisplayObject like SceneObject Event Flow" is created by seyself (http://seyself.com/)</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.Progression
	 * @see jp.progression.scenes#getSceneById()
	 * @see jp.progression.scenes#getSceneBySceneId()
	 * @see jp.progression.scenes#getScenesByGroup()
	 * 
	 * @example <listing version="3.0">
	 * // SceneObject インスタンスを作成する
	 * var scene:SceneObject = new SceneObject( "about" );
	 * 
	 * // シーンイベントを設定する
	 * scene.onSceneInit = function():void {
	 * 	trace( scene, "に到着しました。"
	 * };
	 * scene.onSceneGoto = function():void {
	 * 	trace( scene, "から出発しました。"
	 * };
	 * 
	 * // Progression インスタンスを作成する
	 * var manager:Progression = new Progression( "index", stage );
	 * 
	 * // シーン構造を作成する
	 * manager.root.addScene( scene );
	 * 
	 * // シーンを移動する
	 * manager.goto( new SceneId( "/index/about" ) );
	 * </listing>
	 */
	public class SceneObject extends EventDispatcher implements IIdGroup, IManageable, IExecutable, IDisposable {
		
		/**
		 * @private
		 */
		progression_internal static const $collection:IdGroupCollection = new IdGroupCollection();
		
		/**
		 * @private
		 */
		progression_internal static var $manager:Progression;
		
		/**
		 * @private
		 */
		progression_internal static var $container:Sprite;
		
		/**
		 * @private
		 */
		progression_internal static var $loader:SceneLoader;
		
		/**
		 * @private
		 */
		progression_internal static var $providingData:*;
		
		/**
		 * インスタンス名の接頭辞を取得します。
		 */
		private static var _prefix:String = "scene";
		
		
		
		
		
		/**
		 * <span lang="ja">インスタンスのクラス名を取得します。</span>
		 * <span lang="en">Indicates the instance className of the SceneObject.</span>
		 */
		public function get className():String { return _classNameObj ? _classNameObj.toString() : ClassUtil.nium_internal::$DEFAULT_CLASS_NAME; }
		private var _classNameObj:StringObject;
		
		/**
		 * <span lang="ja">インスタンスを表すユニークな識別子を取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see jp.progression.scenes#getSceneById()
		 */
		public function get id():String { return _id; }
		public function set id( value:String ):void {
			// 既存の登録を取得する
			var instance:IIdGroup = SceneObject.progression_internal::$collection.getInstanceById( value );
			
			// すでに存在していれば例外をスローする
			if ( instance ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_022 ).toString( value ) ); }
			
			// 登録する
			_id = SceneObject.progression_internal::$collection.registerId( this, value ) ? value : null;
		}
		private var _id:String;
		
		/**
		 * <span lang="ja">インスタンスのグループ名を取得または設定します。</span>
		 * <span lang="en">Indicates the instance group of the SceneObject.</span>
		 * 
		 * @see jp.progression.scenes#getScenesByGroup()
		 */
		public function get group():String { return _group; }
		public function set group( value:String ):void { _group = SceneObject.progression_internal::$collection.registerGroup( this, value ) ? value : null; }
		private var _group:String;
		
		/**
		 * <span lang="ja">インスタンスの名前を取得または設定します。</span>
		 * <span lang="en">Indicates the instance name of the SceneObject.</span>
		 * 
		 * @see #sceneId
		 * @see #getSceneByName()
		 */
		public function get name():String { return _name; }
		public function set name( value:String ):void {
			if ( __root == this ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_004 ).toString( "name" ) ); }
			if ( _manager && sceneId.contains( _manager.currentSceneId ) ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_026 ).toString( toString() ) ); }
			
			if ( value ) {
				if ( !SceneId.validateName( value ) ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_005 ).toString( "name" ) ); }
				
				_name = value;
			}
			else {
				_name = _prefix + _uniqueNum;
			}
		}
		private var _name:String;
		private var _uniqueNum:Number;
		
		/**
		 * <span lang="ja">シーン識別子を取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #name
		 */
		public function get sceneId():SceneId {
			if ( _sceneId ) { return _sceneId; }
			if ( __parent && __parent.root ) { return new SceneId( __parent.sceneId.path + "/" + _name ); }
			
			return SceneId.NaS;
		}
		private var _sceneId:SceneId;
		
		/**
		 * <span lang="ja">シーンのタイトルを取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see jp.progression.events.SceneEvent#SCENE_SCENE_TITLE_CHANGE
		 */
		public function get title():String { return _title; }
		public function set title( value:String ):void {
			_title = value;
			
			// イベントを送出する
			_dispatchEvent( new SceneEvent( SceneEvent.SCENE_TITLE_CHANGE ) );
		}
		private var _title:String;
		
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
		 * <span lang="ja">関連付けられている Stage インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get stage():Stage { return _stage; }
		private var _stage:Stage;
		
		/**
		 * <span lang="ja">関連付けられている Sprite インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get container():Sprite {
			if ( _sceneInfo && _sceneInfo.loader ) { return _sceneInfo.loader.loaderContainer; }
			if ( __root ) { return __root._container; }
			
			return null;
		}
		private var _container:Sprite;
		
		/**
		 * <span lang="ja">自身の参照を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get self():SceneObject { return this; }
		
		/**
		 * <span lang="ja">この SceneObject オブジェクトを含む SceneObject オブジェクトを示します。</span>
		 * <span lang="en">Indicates the SceneObject object that contains this SceneObject object.</span>
		 * 
		 * @see #root
		 * @see #next
		 * @see #previous
		 */
		public function get parent():SceneObject { return __parent; }
		private function set _parent( value:SceneObject ):void {
			__parent = value;
			
			if ( __parent ) {
				// イベントを送出する
				_dispatchEvent( new SceneEvent( SceneEvent.SCENE_ADDED, true ) );
			}
			else {
				// イベントを送出する
				_dispatchEvent( new SceneEvent( SceneEvent.SCENE_REMOVED, true ) );
			}
		}
		private var __parent:SceneObject;
		private var ___parent:SceneObject;
		
		/**
		 * イベントフロー上で親となる SceneObject インスタンスを取得します。
		 */
		private var _eventParent:SceneObject;
		
		/**
		 * <span lang="ja">シーンツリー構造の一番上に位置する SceneObject インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #parent
		 * @see #next
		 * @see #previous
		 */
		public function get root():SceneObject { return __root; }
		private function set _root( value:SceneObject ):void {
			// 現在のルートシーンを取得する
			var oldRoot:SceneObject = __root;
			
			// ルートシーンを更新する
			__root = value;
			
			// ルートシーンが変更されていれば
			if ( oldRoot != __root ) {
				if ( __root ) {
					// イベントを送出する
					_dispatchEvent( new SceneEvent( SceneEvent.SCENE_ADDED_TO_ROOT ) );
				}
				else {
					// イベントを送出する
					_dispatchEvent( new SceneEvent( SceneEvent.SCENE_REMOVED_FROM_ROOT ) );
				}
			}
			
			// 子シーンが存在しなければ終了する
			if ( !_scenes ) { return; }
			
			// 子シーンのルートシーンを更新する
			for ( var i:int = 0, l:int = numScenes; i < l; i++ ) {
				SceneObject( _scenes.getItemAt( i ) )._root = __root;
			}
		}
		private var __root:SceneObject;
		
		/**
		 * <span lang="ja">このシーンが関連付けられている親の SceneObject インスタンス内で、次に位置する SceneObject インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #parent
		 * @see #root
		 * @see #previous
		 */
		public function get next():SceneObject {
			if ( !__parent ) { return null; }
			
			var scenes:UniqueList = __parent._scenes;
			var index:int = scenes.getItemIndex( this ) + 1;
			
			if ( index < 0 || scenes.numItems < index ) { return null; }
			
			return scenes.getItemAt( index );
		}
		
		/**
		 * <span lang="ja">このシーンが関連付けられている親の SceneObject インスタンス内で、一つ前に位置する SceneObject インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #parent
		 * @see #root
		 * @see #next
		 */
		public function get previous():SceneObject {
			if ( !__parent ) { return null; }
			
			var scenes:UniqueList = __parent._scenes;
			var index:int = scenes.getItemIndex( this ) - 1;
			
			if ( index < 0 || scenes.numItems < index ) { return null; }
			
			return scenes.getItemAt( index );
		}
		
		/**
		 * <span lang="ja">子シーンインスタンスが保存されている配列です。
		 * この配列を操作することで元の配列を変更することはできません。</span>
		 * <span lang="en"></span>
		 */
		public function get scenes():Array { return _scenes ? _scenes.toArray() : []; }
		private var _scenes:UniqueList;
		
		/**
		 * <span lang="ja">子として登録されているシーン数を取得します。</span>
		 * <span lang="en">Returns the number of children of this SceneObject.</span>
		 */
		public function get numScenes():int { return _scenes ? _scenes.numItems : 0; }
		
		/**
		 * <span lang="ja">一度でもシーンに移動してきた時があるかどうかを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get visited():Boolean { return _visited; }
		private var _visited:Boolean = false;
		
		/**
		 * <span lang="ja">関連付けられている ExecutorObject インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get executor():ExecutorObject { return _executor; }
		private var _executor:ExecutorObject;
		
		/**
		 * <span lang="ja">関連付けられている SceneInfo インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see jp.progression.scenes.SceneLoader
		 */
		public function get sceneInfo():SceneInfo { return _sceneInfo; }
		private var _sceneInfo:SceneInfo;
		
		/**
		 * <span lang="ja">関連付けられている DataHolder インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see jp.progression.data
		 */
		public function get dataHolder():DataHolder { return _dataHolder; }
		private var _dataHolder:DataHolder;
		
		/**
		 * キャプチャフェイズ用の EventDispatcher インスタンスを取得します。
		 */
		private var _captureDispatcher:EventDispatcher;
		
		/**
		 * <span lang="ja">シーンオブジェクトが SceneEvent.SCENE_LOAD イベントを受け取った場合に呼び出されるイベントハンドラメソッドを取得または設定します。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.SceneEvent#SCENE_LOAD
		 */
		public function get onSceneLoad():Function { return _onSceneLoad; }
		public function set onSceneLoad( value:Function ):void { _onSceneLoad = value; }
		private var _onSceneLoad:Function;
		
		/**
		 * <span lang="ja">シーンオブジェクトが SceneEvent.SCENE_LOAD イベントを受け取った場合に呼び出されるオーバーライド・イベントハンドラメソッドです。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.SceneEvent#SCENE_LOAD
		 */
		protected function atSceneLoad():void {}
		
		/**
		 * <span lang="ja">シーンオブジェクトが SceneEvent.SCENE_UNLOAD イベントを受け取った場合に呼び出されるイベントハンドラメソッドを取得または設定します。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.SceneEvent#SCENE_UNLOAD
		 */
		public function get onSceneUnload():Function { return _onSceneUnload; }
		public function set onSceneUnload( value:Function ):void { _onSceneUnload = value; }
		private var _onSceneUnload:Function;
		
		/**
		 * <span lang="ja">シーンオブジェクトが SceneEvent.SCENE_UNLOAD イベントを受け取った場合に呼び出されるオーバーライド・イベントハンドラメソッドです。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.SceneEvent#SCENE_UNLOAD
		 */
		protected function atSceneUnload():void {}
		
		/**
		 * <span lang="ja">シーンオブジェクトが SceneEvent.SCENE_INIT イベントを受け取った場合に呼び出されるイベントハンドラメソッドを取得または設定します。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.SceneEvent#SCENE_INIT
		 */
		public function get onSceneInit():Function { return _onSceneInit; }
		public function set onSceneInit( value:Function ):void { _onSceneInit = value; }
		private var _onSceneInit:Function;
		
		/**
		 * <span lang="ja">シーンオブジェクトが SceneEvent.SCENE_INIT イベントを受け取った場合に呼び出されるオーバーライド・イベントハンドラメソッドです。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.SceneEvent#SCENE_INIT
		 */
		protected function atSceneInit():void {}
		
		/**
		 * <span lang="ja">シーンオブジェクトが SceneEvent.SCENE_GOTO イベントを受け取った場合に呼び出されるイベントハンドラメソッドを取得または設定します。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.SceneEvent#SCENE_GOTO
		 */
		public function get onSceneGoto():Function { return _onSceneGoto; }
		public function set onSceneGoto( value:Function ):void { _onSceneGoto = value; }
		private var _onSceneGoto:Function;
		
		/**
		 * <span lang="ja">シーンオブジェクトが SceneEvent.SCENE_GOTO イベントを受け取った場合に呼び出されるオーバーライド・イベントハンドラメソッドです。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.SceneEvent#SCENE_GOTO
		 */
		protected function atSceneGoto():void {}
		
		/**
		 * <span lang="ja">シーンオブジェクトが SceneEvent.SCENE_DESCEND イベントを受け取った場合に呼び出されるイベントハンドラメソッドを取得または設定します。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.SceneEvent#SCENE_DESCEND
		 */
		public function get onSceneDescend():Function { return _onSceneDescend; }
		public function set onSceneDescend( value:Function ):void { _onSceneDescend = value; }
		private var _onSceneDescend:Function;
		
		/**
		 * <span lang="ja">シーンオブジェクトが SceneEvent.SCENE_DESCEND イベントを受け取った場合に呼び出されるオーバーライド・イベントハンドラメソッドです。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.SceneEvent#SCENE_DESCEND
		 */
		protected function atSceneDescend():void {}
		
		/**
		 * <span lang="ja">シーンオブジェクトが SceneEvent.SCENE_ASCEND イベントを受け取った場合に呼び出されるイベントハンドラメソッドを取得または設定します。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.SceneEvent#SCENE_ASCEND
		 */
		public function get onSceneAscend():Function { return _onSceneAscend; }
		public function set onSceneAscend( value:Function ):void { _onSceneAscend = value; }
		private var _onSceneAscend:Function;
		
		/**
		 * <span lang="ja">シーンオブジェクトが SceneEvent.SCENE_ASCEND イベントを受け取った場合に呼び出されるオーバーライド・イベントハンドラメソッドです。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.SceneEvent#SCENE_ASCEND
		 */
		protected function atSceneAscend():void {}
		
		
		
		
		
		/**
		 * <span lang="ja">新しい SceneObject インスタンスを作成します。</span>
		 * <span lang="en">Creates a new SceneObject object.</span>
		 * 
		 * @param name
		 * <span lang="ja">シーンの名前です。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function SceneObject( name:String = null, initObject:Object = null ) {
			// クラスをコンパイルに含める
			nium_internal;
			progression_internal;
			
			// クラス名を取得する
			_classNameObj = ClassUtil.nium_internal::$getClassString( this );
			
			// 親クラスを初期化する
			super();
			
			// コレクションに登録する
			_uniqueNum = SceneObject.progression_internal::$collection.addInstance( this );
			
			// EventDispatcher を作成する
			_captureDispatcher = new EventDispatcher( this );
			
			// 名前を設定する
			if ( __root ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_004 ).toString( "name" ) ); }
			if ( !SceneId.validateName( name ) ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_005 ).toString( "name" ) ); }
			_name = name || ( _prefix + _uniqueNum );
			
			// Progression が存在すればルートとして設定する
			if ( SceneObject.progression_internal::$manager ) {
				if ( !SceneId.validateName( SceneObject.progression_internal::$manager.id ) ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_005 ).toString( "name" ) ); }
				
				// 特定のプロパティを初期化する
				_name = SceneObject.progression_internal::$manager.id;
				_sceneId = new SceneId( "/" + _name );
				_manager = SceneObject.progression_internal::$manager;
				_stage = SceneObject.progression_internal::$manager.stage;
				_container = SceneObject.progression_internal::$container;
				_root = this;
				
				var classRef:Class = Progression.config.executor;
				_executor = new classRef( this );
				
				var loader:SceneLoader = SceneObject.progression_internal::$loader;
				
				//if ( loader ) {
					//_sceneInfo = loader.contentSceneInfo;
				//}
				//else {
					//_sceneInfo = SceneInfo.progression_internal::$createInstance( this, null, _container.loaderInfo );
				//}
				_sceneInfo = SceneInfo.progression_internal::$createInstance( this, SceneObject.progression_internal::$loader, _container.loaderInfo );
				
				classRef = Progression.config.dataHolder;
				_dataHolder = new classRef( this );
				
				// 破棄する
				SceneObject.progression_internal::$manager = null;
				SceneObject.progression_internal::$container = null;
				SceneObject.progression_internal::$loader = null;
			}
			
			// 初期化する
			ObjectUtil.setProperties( this, initObject );
			
			// イベントリスナーを登録する
			super.addEventListener( SceneEvent.SCENE_INIT_COMPLETE, _sceneInitComplete, false, int.MAX_VALUE, true );
			super.addEventListener( SceneEvent.SCENE_LOAD, _sceneEvent, false, 0, true );
			super.addEventListener( SceneEvent.SCENE_UNLOAD, _sceneEvent, false, 0, true );
			super.addEventListener( SceneEvent.SCENE_INIT, _sceneEvent, false, 0, true );
			super.addEventListener( SceneEvent.SCENE_GOTO, _sceneEvent, false, 0, true );
			super.addEventListener( SceneEvent.SCENE_DESCEND, _sceneEvent, false, 0, true );
			super.addEventListener( SceneEvent.SCENE_ASCEND, _sceneEvent, false, 0, true );
			
			// 自身がルートであれば終了する
			if ( __root == this ) { return; }
			
			// イベントリスナーを登録する
			super.addEventListener( SceneEvent.SCENE_ADDED_TO_ROOT, _sceneAddedToRoot, false, int.MAX_VALUE, true );
			super.addEventListener( SceneEvent.SCENE_REMOVED_FROM_ROOT, _sceneRemovedFromRoot, false, int.MAX_VALUE, true );
		}
		
		
		
		
		/**
		 * <span lang="ja">XML データが PRML フォーマットに準拠しているかどうかを返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param prml
		 * <span lang="ja">フォーマットを検査したい XML データです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">フォーマットが合致すれば true を、合致しなければ false となります。</span>
		 * <span lang="en"></span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function validate( prml:XML ):Boolean {
			prml = new XML( prml.toXMLString() );
			
			// <prml> タグが存在しなければ
			if ( String( prml.name() ) != "prml" ) { return false; }
			
			// バージョンが正しくなければ
			switch ( String( prml.attribute( "version" ) ) ) {
				case "2.0.0"	: { break; }
				default			: { return false; }
			}
			
			// コンテンツタイプを確認する
			var type:String = String( prml.attribute( "type" ) );
			switch ( type ) {
				case "text/easycasting"		:
				case "text/prml"			:
				case "text/prml.plain"		:
				default						: {
					if ( new RegExp( "^text/prml(\\..+)?$" ).test( type ) ) { break; }
					return false;
				}
			}
			
			// ルートにシーンが 1 つ以上存在しなければ
			if ( prml.scene.length() < 1 ) { return false; }
			
			// 必須プロパティを精査する
			for each ( var scene:XML in prml..scene ) {
				if ( !( SceneId.validateName( String( scene.attribute( "name" ) ) ) ) ) { return false; }
				if ( !String( scene.attribute( "cls" ) ) ) { return false; }
			}
			
			return true;
		}
		
		/**
		 * @private
		 */
		progression_internal static function $getSceneBySceneId( sceneId:SceneId ):SceneObject {
			// 存在しなければ終了する
			if ( !sceneId || SceneId.isNaS( sceneId ) ) { return null; }
			
			// Progression インスタンスを取得する
			var manager:Progression = Progression.progression_internal::$collection.getInstanceById( sceneId.getNameByIndex( 0 ) ) as Progression;
			
			// 存在しなければ終了する
			if ( !manager ) { return null; }
			
			// シーン識別子からシーンの参照を取得する
			var current:SceneObject = manager.root;
			for ( var i:int = 1, l:int = sceneId.length; i < l; i++ ) {
				// 対象が SceneLoader であれば
				if ( current is SceneLoader ) { return null; }
				
				// 子シーンの参照を取得する
				current = current.getSceneByName( sceneId.getNameByIndex( i ) );
				
				// SceneLoader を取得する
				var loader:SceneLoader = current as SceneLoader;
				
				// SceneLoader が存在し、コンテンツが読み込まれていれば
				if ( loader && loader.content ) {
					current = loader.content.root;
				}
			}
			
			return current;
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
		public function setProperties( parameters:Object ):SceneObject {
			ObjectUtil.setProperties( this, parameters );
			return this;
		}
		
		/**
		 * <span lang="ja">シーン識別子をルートシーン（グローバル）パスからローダーシーンの（ローカル）パスに変換します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param sceneId
		 * <span lang="ja">変換したいシーン識別子オブジェクトです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">ローカルパスに変換されたシーン識別子オブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function globalToLocal( sceneId:SceneId ):SceneId {
			if ( !_sceneInfo ) { return sceneId; }
			
			// 読み込まれた Progression インスタンスであれば
			if ( _sceneInfo.loader ) {
				var depth:int = _sceneInfo.loader.sceneId.length;
				
				if ( sceneId.length > depth ) {
					sceneId = _sceneInfo.loader.globalToLocal( new SceneId( "/" + root.name + sceneId.slice( depth ), sceneId.query ) );
				}
				else {
					sceneId = _sceneInfo.loader.globalToLocal( new SceneId( "/" + root.name, sceneId.query ) );
				}
			}
			
			return sceneId;
		}
		
		/**
		 * <span lang="ja">シーン識別子をローダーシーンの（ローカル）パスからルートシーン（グローバル）パスに変換します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param sceneId
		 * <span lang="ja">変換したいシーン識別子オブジェクトです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">グローバルパスに変換されたシーン識別子オブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function localToGlobal( sceneId:SceneId ):SceneId {
			// 読み込まれた Progression インスタンスであれば
			if ( _sceneInfo && _sceneInfo.loader ) {
				// 移動先が管理下に存在しなければ
				if ( !root.sceneId.contains( sceneId ) ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_013 ).toString( sceneId ) ); }
				
				// 親のパスと結合する
				if ( sceneId.length > 1 ) {
					return _sceneInfo.loader.localToGlobal( _sceneInfo.loader.sceneId.transfer( "." + sceneId.slice( 1 ), sceneId.query ) );
				}
				else {
					return _sceneInfo.loader.localToGlobal( _sceneInfo.loader.sceneId );
				}
			}
			
			return sceneId;
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
			// 自身がルートであれば常に true を返す
			if ( __root == this ) { return true; }
			
			// 現在のマネージャーを取得する
			var oldManager:Progression = _manager;
			
			// 親が IManageable であれば
			var manageable:IManageable = __parent as IManageable;
			_manager = manageable ? manageable.manager : null;
			
			if ( _manager ) {
				_stage = __parent._stage;
				_sceneInfo = __parent._sceneInfo;
			}
			else {
				_stage = null;
				_sceneInfo = null;
			}
			
			// 変更されていなければ終了する
			if ( _manager == oldManager ) { return Boolean( !!_manager ); }
			
			// イベントを送出する
			if ( _manager ) {
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
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see #onSceneLoad
		 * @see #onSceneUnload
		 * @see #onSceneInit
		 * @see #onSceneGoto
		 * @see #onSceneAscend
		 * @see #onSceneDescend
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
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see #onSceneLoad
		 * @see #onSceneUnload
		 * @see #onSceneInit
		 * @see #onSceneGoto
		 * @see #onSceneAscend
		 * @see #onSceneDescend
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
		 * <span lang="ja">登録されている全てのコマンド登録を解除したい場合には true を、現在処理中のコマンド以降の登録を解除したい場合には false です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see #onSceneLoad
		 * @see #onSceneUnload
		 * @see #onSceneInit
		 * @see #onSceneGoto
		 * @see #onSceneAscend
		 * @see #onSceneDescend
		 */
		public function clearCommand( completely:Boolean = false ):void {
			ExecutorObject.progression_internal::$clearCommand( _executor, completely );
		}
		
		/**
		 * <span lang="ja">この SceneObject インスタンスに子 SceneObject インスタンスを追加します。</span>
		 * <span lang="en">Adds a child SceneObject instance to this SceneObject instance.</span>
		 * 
		 * @param scene
		 * <span lang="ja">対象の SceneObject インスタンスの子として追加する SceneObject インスタンスです。</span>
		 * <span lang="en">The SceneObject instance to add as a scene of this SceneObject instance.</span>
		 * @return
		 * <span lang="en">scene パラメータで渡す SceneObject インスタンスです。</span>
		 * <span lang="en">The SceneObject instance that you pass in the scene parameter.</span>
		 * 
		 * @see #addSceneAt()
		 * @see #addSceneAtAbove()
		 * @see #addSceneFromXML()
		 */
		public function addScene( scene:SceneObject ):SceneObject {
			return _addSceneAt( scene, numScenes );
		}
		
		/**
		 * <span lang="ja">この SceneObject インスタンスの指定されたインデックス位置に子 SceneObject インスタンスを追加します。</span>
		 * <span lang="en">Adds a child SceneObject instance to this SceneObject instance.</span>
		 * 
		 * @param scene
		 * <span lang="ja">対象の SceneObject インスタンスの子として追加する SceneObject インスタンスです。</span>
		 * <span lang="en">The SceneObject instance to add as a scene of this SceneObject instance.</span>
		 * @param index
		 * <span lang="ja">子を追加するインデックス位置です。</span>
		 * <span lang="en">The index position to which the scene is added. If you specify a currently occupied index position, the scene object that exists at that position and all higher positions are moved up one position in the scene list.</span>
		 * @return
		 * <span lang="en">scene パラメータで渡す SceneObject インスタンスです。</span>
		 * <span lang="en">The SceneObject instance that you pass in the scene parameter.</span>
		 * 
		 * @see #addScene()
		 * @see #addSceneAtAbove()
		 * @see #addSceneFromXML()
		 */
		public function addSceneAt( scene:SceneObject, index:int ):SceneObject {
			return _addSceneAt( scene, index );
		}
		
		/**
		 * 
		 */
		private function _addSceneAt( scene:SceneObject, index:int ):SceneObject {
			// インデックスの範囲を超えていれば例外をスローする
			if ( index < 0 || numScenes < index ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_004 ).toString() ); }
			
			// すでに親が存在していれば解除する
			var parent:SceneObject = scene.parent;
			if ( parent ) {
				parent.removeScene( scene );
				index = Math.min( index, parent.numScenes );
			}
			
			// イベントフロー時の参照先を登録する
			scene._eventParent = this;
			
			// 存在しなければ作成する
			_scenes ||= new UniqueList();
			
			// 登録する
			_scenes.addItemAt( scene, index );
			scene._parent = this;
			scene._root = __root;
			
			return scene;
		}
		
		/**
		 * <span lang="ja">この SceneObject インスタンスの指定されたインデックス位置に子 SceneObject インスタンスを追加します。</span>
		 * <span lang="en">Adds a child SceneObject instance to this SceneObject instance.</span>
		 * 
		 * @param scene
		 * <span lang="ja">対象の SceneObject インスタンスの子として追加する SceneObject インスタンスです。</span>
		 * <span lang="en">The SceneObject instance to add as a scene of this SceneObject instance.</span>
		 * @param index
		 * <span lang="ja">子を追加するインデックス位置です。</span>
		 * <span lang="en">The index position to which the scene is added. If you specify a currently occupied index position, the scene object that exists at that position and all higher positions are moved up one position in the scene list.</span>
		 * @return
		 * <span lang="en">scene パラメータで渡す SceneObject インスタンスです。</span>
		 * <span lang="en">The SceneObject instance that you pass in the scene parameter.</span>
		 * 
		 * @see #addScene()
		 * @see #addSceneAt()
		 * @see #addSceneFromXML()
		 */
		public function addSceneAtAbove( scene:SceneObject, index:int ):SceneObject {
			if ( _scenes ) { return _addSceneAt( scene, _scenes.getItemAt( index ) ? index + 1 : index ); }
			return _addSceneAt( scene, index );
		}
		
		/**
		 * <span lang="ja">この SceneObject インスタンスの子を PRML 形式の XML データから追加します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param prml
		 * <span lang="en">PRML 形式の XML データです。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #addScene()
		 * @see #addSceneAt()
		 * @see #addSceneAtAbove()
		 */
		public function addSceneFromXML( prml:XML ):void {
			prml = new XML( prml.toXMLString() );
			
			// cls が省略されていれば SceneObject を設定する
			for each ( var scene:XML in prml..scene ) {
				var cls:String = scene.@cls;
				
				if ( cls ) { continue; }
				
				scene.@cls = "jp.progression.scenes.SceneObject";
			}
			
			// PRML のフォーマットが正しくなければ例外をスローする
			if ( !validate( prml ) ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_005 ).toString( "PRML" ) ); }
			
			// <scene> から SceneObject を作成する
			for each ( scene in prml.scene ) {
				// クラスの参照を作成する
				cls = String( scene.@cls ) || "jp.progression.scenes.SceneObject";
				var classRef:Class = getDefinitionByName( cls ) as Class;
				
				// 存在しなければ例外をスローする
				if ( !classRef ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_011 ).toString( cls ) ); }
				
				// SceneObject を作成する
				var child:SceneObject = new classRef() as SceneObject;
				
				// 存在しなければ例外をスローする
				if ( !child ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_011 ).toString( "cls", cls, "SceneObject" ) ); }
				
				// プロパティを初期化する
				for each ( var attribute:XML in scene.attributes() ) {
					var attrName:String = String( attribute.name() );
					
					if ( !( attrName in child ) ) { continue; }
					
					child[attrName] = StringUtil.toProperType( attribute );
				}
				
				// 子シーンに追加する
				_addSceneAt( child, numScenes );
				
				// 孫シーンを追加する
				if ( scene.scene.length() > 0 ) {
					child.addSceneFromXML( <prml version={ prml.@version } type={ prml.@type }>{ scene.scene }</prml> );
				}
				
				// DataHolder を更新する
				delete scene.scene; 
				progression_internal::$providingData = scene.*;
				child.dataHolder.update();
			}
		}
		
		/**
		 * <span lang="ja">SceneObject インスタンスの子リストから指定の SceneObject インスタンスを削除します。</span>
		 * <span lang="en">Removes the specified child SceneObject instance from the scene list of the SceneObject instance.</span>
		 * 
		 * @param scene
		 * <span lang="ja">対象の SceneObject インスタンスの子から削除する SceneObject インスタンスです。</span>
		 * <span lang="en">The SceneObject instance to remove.</span>
		 * @return
		 * <span lang="en">scene パラメータで渡す SceneObject インスタンスです。</span>
		 * <span lang="en">The SceneObject instance that you pass in the scene parameter.</span>
		 * 
		 * @see #removeSceneAt()
		 * @see #removeAllScenes()
		 */
		public function removeScene( scene:SceneObject ):SceneObject {
			if ( !_scenes ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_011 ).toString( scene ) ); }
			return _removeSceneAt( _scenes.getItemIndex( scene ) );
		}
		
		/**
		 * <span lang="ja">SceneObject の子リストの指定されたインデックス位置から子 SceneObject インスタンスを削除します。</span>
		 * <span lang="en">Removes a child SceneObject from the specified index position in the child list of the SceneObject.</span>
		 * 
		 * @param index
		 * <span lang="ja">削除する SceneObject の子インデックスです。</span>
		 * <span lang="en">The child index of the SceneObject to remove.</span>
		 * @return
		 * <span lang="ja">削除された SceneObject インスタンスです。</span>
		 * <span lang="en">The SceneObject instance that was removed.</span>
		 * 
		 * @see #removeScene()
		 * @see #removeAllScenes()
		 */
		public function removeSceneAt( index:int ):SceneObject {
			return _removeSceneAt( index );
		}
		
		/**
		 * 
		 */
		private function _removeSceneAt( index:int ):SceneObject {
			if ( !_scenes ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_011 ).toString( "DisplayObject" ) ); }
			
			// シーンを取得する
			var scene:SceneObject = _scenes.getItemAt( index );
			
			if ( _manager && scene.sceneId.contains( _manager.currentSceneId ) ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_026 ).toString( toString() ) ); }
			
			// 登録を解除する
			_scenes.removeItemAt( index );
			scene._parent = null;
			scene._root = null;
			
			// 登録情報が存在しなければ
			if ( _scenes.numItems < 1 ) {
				_scenes.dispose();
				_scenes = null;
			}
			
			// イベントフロー時の参照先の登録を解除する
			scene._eventParent = null;
			
			return scene;
		}
		
		/**
		 * <span lang="ja">SceneObject に追加されている全ての子 SceneObject インスタンスを削除します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #removeScene()
		 * @see #removeSceneAt()
		 */
		public function removeAllScenes():void {
			while ( _scenes && _scenes.numItems > 0 ) {
				_removeSceneAt( 0 );
			}
		}
		
		/**
		 * <span lang="ja">指定されたシーンオブジェクトが SceneObject インスタンスの子であるか、オブジェクト自体であるかを指定します。</span>
		 * <span lang="en">Determines whether the specified SceneObject is a scene of the SceneObject instance or the instance itself.</span>
		 * 
		 * @param scene
		 * <span lang="ja">テストする子 SceneObject インスタンスです。</span>
		 * <span lang="en">The scene object to test.</span>
		 * @return
		 * <span lang="en">scene インスタンスが SceneObject の子であるか、コンテナ自体である場合は true となります。そうでない場合は false となります。</span>
		 * <span lang="en">true if the scene object is a scene of the SceneObject or the container itself; otherwise false.</span>
		 */
		public function contains( scene:SceneObject ):Boolean {
			// 自身であれば true を返す
			if ( scene == this ) { return true; }
			
			// 子または孫に存在すれば true を返す
			for ( var i:int = 0, l:int = numScenes; i < l; i++ ) {
				if ( _scenes.contains( scene ) ) { return true; }
				if ( SceneObject( _scenes.getItemAt( i ) ).contains( scene ) ) { return true; }
			}
			
			return false;
		}
		
		/**
		 * <span lang="ja">指定のインデックス位置にある子シーンオブジェクトオブジェクトを返します。</span>
		 * <span lang="en">Returns the child SceneObject instance that exists at the specified index.</span>
		 * 
		 * @param index
		 * <span lang="ja">子 SceneObject インスタンスのインデックス位置です。</span>
		 * <span lang="en">The index position of the scene object.</span>
		 * @return
		 * <span lang="ja">指定されたインデックス位置にある子 SceneObject インスタンスです。</span>
		 * <span lang="en">The child SceneObject at the specified index position.</span>
		 */
		public function getSceneAt( index:int ):SceneObject {
			if ( _scenes ) { return _scenes.getItemAt( index ); }
			return null;
		}
		
		/**
		 * <span lang="ja">指定された名前に一致する子シーンオブジェクトを返します。</span>
		 * <span lang="en">Returns the child SceneObject that exists with the specified name.</span>
		 * 
		 * @param name
		 * <span lang="ja">返される子 SceneObject インスタンスの名前です。</span>
		 * <span lang="en">The name of the scene to return.</span>
		 * @return
		 * <span lang="ja">指定された名前を持つ子 SceneObject インスタンスです。</span>
		 * <span lang="en">The child SceneObject with the specified name.</span>
		 */
		public function getSceneByName( name:String ):SceneObject {
			if ( !_scenes ) { return null; }
			
			for ( var i:int = _scenes.numItems; 0 < i; i-- ) {
				var scene:SceneObject = _scenes.getItemAt( i - 1 );
				if ( scene.name == name ) { return scene; }
			}
			
			return null;
		}
		
		/**
		 * <span lang="ja">子 SceneObject インスタンスのインデックス位置を返します。</span>
		 * <span lang="en">Returns the index position of a child SceneObject instance.</span>
		 * 
		 * @param child
		 * <span lang="ja">特定する子 SceneObject インスタンスです。</span>
		 * <span lang="en">The SceneObject instance to identify.</span>
		 * @return
		 * <span lang="ja">特定する子 SceneObject インスタンスのインデックス位置です。</span>
		 * <span lang="en">The index position of the child SceneObject to identify.</span>
		 */
		public function getSceneIndex( scene:SceneObject ):int {
			if ( !_scenes ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_011 ).toString( "DisplayObject" ) ); }
			return _scenes.getItemIndex( scene );
		}
		
		/**
		 * <span lang="ja">シーンオブジェクトコンテナの既存の子の位置を変更します。</span>
		 * <span lang="en">Changes the position of an existing scene in the SceneObject container.</span>
		 * 
		 * @param scene
		 * <span lang="ja">インデックス番号を変更する子 SceneObject インスタンスです。</span>
		 * <span lang="en">The child SceneObject instance for which you want to change the index number.</span>
		 * @param index
		 * <span lang="en">child インスタンスの結果のインデックス番号です。</span>
		 * <span lang="en">The resulting index number for the child SceneObject.</span>
		 * 
		 * @see #setSceneIndexAbove()
		 */
		public function setSceneIndex( scene:SceneObject, index:int ):void {
			if ( !_scenes ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_011 ).toString( "DisplayObject" ) ); }
			_scenes.setItemIndex( scene, index );
		}
		
		/**
		 * <span lang="ja">シーンオブジェクトコンテナの既存の子の位置を変更します。</span>
		 * <span lang="en">Changes the position of an existing scene in the SceneObject container.</span>
		 * 
		 * @param scene
		 * <span lang="ja">インデックス番号を変更する子 SceneObject インスタンスです。</span>
		 * <span lang="en">The child SceneObject instance for which you want to change the index number.</span>
		 * @param index
		 * <span lang="en">child インスタンスの結果のインデックス番号です。</span>
		 * <span lang="en">The resulting index number for the child SceneObject.</span>
		 * 
		 * @see #setSceneIndex()
		 */
		public function setSceneIndexAbove( scene:SceneObject, index:int ):void {
			if ( !_scenes ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_011 ).toString( "DisplayObject" ) ); }
			_scenes.setItemIndex( scene, _scenes.getItemAt( index ) ? index + 1 : index );
		}
		
		/**
		 * <span lang="ja">指定された 2 つの子オブジェクトの z 順序（重ね順）を入れ替えます。</span>
		 * <span lang="en">Swaps the z-order (front-to-back order) of the two specified scene objects.</span>
		 * 
		 * @param scene1
		 * <span lang="ja">先頭の子 SceneObject インスタンスです。</span>
		 * <span lang="en">The first scene object.</span>
		 * @param scene2
		 * <span lang="ja">2 番目の子 SceneObject インスタンスです。</span>
		 * <span lang="en">The second scene object.</span>
		 * 
		 * @see #swapScenesAt()
		 */
		public function swapScenes( scene1:SceneObject, scene2:SceneObject ):void {
			if ( !_scenes ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_011 ).toString( "DisplayObject" ) ); }
			_scenes.swapItems( scene1, scene2 );
		}
		
		/**
		 * <span lang="ja">子リスト内の指定されたインデックス位置に該当する 2 つの子オブジェクトの z 順序（重ね順）を入れ替えます。</span>
		 * <span lang="en">Swaps the z-order (front-to-back order) of the scene objects at the two specified index positions in the scene list.</span>
		 * 
		 * @param index1
		 * <span lang="ja">最初の子 SceneObject インスタンスのインデックス位置です。</span>
		 * <span lang="en">The index position of the first scene object.</span>
		 * @param index2
		 * <span lang="ja">2 番目の子 SceneObject インスタンスのインデックス位置です。</span>
		 * <span lang="en">The index position of the second scene object.</span>
		 * 
		 * @see #swapScenes()
		 */
		public function swapScenesAt( index1:int, index2:int ):void {
			if ( !_scenes ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_011 ).toString( "DisplayObject" ) ); }
			_scenes.swapItemsAt( index1, index2 );
		}
		
		/**
		 * <span lang="ja">イベントリスナーオブジェクトを EventDispatcher インスタンスに登録し、リスナーがイベントの通知を受け取るようにします。
		 * このメソッドを使用して登録されたリスナーを removeEventListener() メソッドで削除した場合には、restoreRemovedListeners() メソッドで再登録させることができます。</span>
		 * <span lang="en">Register the event listener object into the EventDispatcher instance to get the event notification.
		 * If the registered listener by this method removed by using removeEventListener() method, it can re-register using restoreRemovedListeners() method.</span>
		 * 
		 * @param type
		 * <span lang="ja">イベントのタイプです。</span>
		 * <span lang="en">The type of event.</span>
		 * @param listener
		 * <span lang="ja">イベントを処理するリスナー関数です。この関数は Event インスタンスを唯一のパラメータとして受け取り、何も返さないものである必要があります。関数は任意の名前を持つことができます。</span>
		 * <span lang="en">The listener function that processes the event. This function must accept an Event object as its only parameter and must return nothing. The function can have any name.</span>
		 * @param useCapture
		 * <span lang="ja">リスナーが、キャプチャ段階、またはターゲットおよびバブリング段階で動作するかどうかを判断します。useCapture を true に設定すると、リスナーはキャプチャ段階のみでイベントを処理し、ターゲット段階またはバブリング段階では処理しません。useCapture を false に設定すると、リスナーはターゲット段階またはバブリング段階のみでイベントを処理します。3 つの段階すべてでイベントを受け取るには、addEventListener を 2 回呼び出します。useCapture を true に設定して 1 度呼び出し、useCapture を false に設定してもう一度呼び出します。</span>
		 * <span lang="en">Determines whether the listener works in the capture phase or the target and bubbling phases. If useCapture is set to true, the listener processes the event only during the capture phase and not in the target or bubbling phase. If useCapture is false, the listener processes the event only during the target or bubbling phase. To listen for the event in all three phases, call addEventListener twice, once with useCapture set to true, then again with useCapture set to false.</span>
		 * @param priority
		 * <span lang="ja">イベントリスナーの優先度レベルです。優先度は、符号付き 32 ビット整数で指定します。数値が大きくなるほど優先度が高くなります。優先度が n のすべてのリスナーは、優先度が n -1 のリスナーよりも前に処理されます。複数のリスナーに対して同じ優先度が設定されている場合、それらは追加された順番に処理されます。デフォルトの優先度は 0 です。</span>
		 * <span lang="en">The priority level of the event listener. The priority is designated by a signed 32-bit integer. The higher the number, the higher the priority. All listeners with priority n are processed before listeners of priority n-1. If two or more listeners share the same priority, they are processed in the order in which they were added. The default priority is 0.</span>
		 * @param useWeakReference
		 * <span lang="ja">リスナーへの参照が強参照と弱参照のいずれであるかを判断します。デフォルトである強参照の場合は、リスナーのガベージコレクションが回避されます。弱参照では回避されません。</span>
		 * <span lang="en">Determines whether the reference to the listener is strong or weak. A strong reference (the default) prevents your listener from being garbage-collected. A weak reference does not.</span>
		 */
		override public function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void {
			if ( !_captureDispatcher ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_024 ).toString( toString() ) ); }
			
			if ( useCapture ) {
				_captureDispatcher.addEventListener( type, listener, false, priority, useWeakReference );
			}
			else {
				super.addEventListener( type, listener, false, priority, useWeakReference );
			}
		}
		
		/**
		 * <span lang="ja">EventDispatcher インスタンスからリスナーを削除します。
		 * このメソッドを使用して削除されたリスナーは、restoreRemovedListeners() メソッドで再登録させることができます。</span>
		 * <span lang="en">Remove the listener from EventDispatcher instance.
		 * The listener removed by using this method can re-register by restoreRemovedListeners() method.</span>
		 * 
		 * @param type
		 * <span lang="ja">イベントのタイプです。</span>
		 * <span lang="en">The type of event.</span>
		 * @param listener
		 * <span lang="ja">削除するリスナーオブジェクトです。</span>
		 * <span lang="en">The listener object to remove.</span>
		 * @param useCapture
		 * <span lang="ja">リスナーが、キャプチャ段階、またはターゲットおよびバブリング段階に対して登録されたかどうかを示します。リスナーがキャプチャ段階だけでなくターゲット段階とバブリング段階にも登録されている場合は、removeEventListener() を 2 回呼び出して両方のリスナーを削除する必要があります。1 回は useCapture() を true に設定し、もう 1 回は useCapture() を false に設定する必要があります。</span>
		 * <span lang="en">Specifies whether the listener was registered for the capture phase or the target and bubbling phases. If the listener was registered for both the capture phase and the target and bubbling phases, two calls to removeEventListener() are required to remove both, one call with useCapture() set to true, and another call with useCapture() set to false.</span>
		 */
		override public function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ):void {
			if ( !_captureDispatcher ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_024 ).toString( toString() ) ); }
			
			if ( useCapture ) {
				_captureDispatcher.removeEventListener( type, listener, false );
			}
			else {
				super.removeEventListener( type, listener, false );
			}
		}
		
		/**
		 * <span lang="ja">イベントをイベントフローに送出します。</span>
		 * <span lang="en">Dispatches an event into the event flow.</span>
		 * 
		 * @param event
		 * <span lang="ja">イベントフローに送出されるイベントオブジェクトです。イベントが再度送出されると、イベントのクローンが自動的に作成されます。イベントが送出された後にそのイベントの target プロパティは変更できないため、再送出処理のためにはイベントの新しいコピーを作成する必要があります。</span>
		 * <span lang="en">The Event object that is dispatched into the event flow. If the event is being redispatched, a clone of the event is created automatically. After an event is dispatched, its target property cannot be changed, so you must create a new copy of the event for redispatching to work.</span>
		 * @return
		 * <span lang="ja">値が true の場合、イベントは正常に送出されました。値が false の場合、イベントの送出に失敗したか、イベントで preventDefault() が呼び出されたことを示しています。</span>
		 * <span lang="en">A value of true if the event was successfully dispatched. A value of false indicates failure or that preventDefault() was called on the event.</span>
		 */
		override public function dispatchEvent( event:Event ):Boolean {
			var e:SceneEvent = event as SceneEvent;
			
			if ( e ) { return _dispatchEvent( e ); }
			
			return super.dispatchEvent( event );
		}
		
		/**
		 * 
		 */
		private function _dispatchEvent( event:SceneEvent ):Boolean {
			if ( !_captureDispatcher ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_024 ).toString( toString() ) ); }
			
			// シーンフローイベントであれば
			switch ( event.type ) {
				case SceneEvent.SCENE_LOAD				:
				case SceneEvent.SCENE_UNLOAD			:
				case SceneEvent.SCENE_INIT				:
				case SceneEvent.SCENE_GOTO				:
				case SceneEvent.SCENE_DESCEND			:
				case SceneEvent.SCENE_ASCEND			:
				case SceneEvent.SCENE_PRE_LOAD			:
				case SceneEvent.SCENE_POST_UNLOAD		:
				case ManagerEvent.MANAGER_ACTIVATE		:
				case ManagerEvent.MANAGER_DEACTIVATE	: {
					// ターゲットが存在すれば終了する
					if ( event.target || event.currentTarget ) { return false; }
					
					// プロパティを設定する
					event.progression_internal::$eventPhase = EventPhase.AT_TARGET;
					event.progression_internal::$target = this;
					event.progression_internal::$currentTarget = this;
					
					// イベントを送出する
					return super.dispatchEvent( event );
				}
			}
			
			var result:Boolean = false;
			
			event.progression_internal::$currentTarget = this;
			
			if ( event.eventPhase == EventPhase.AT_TARGET ) {
				event.progression_internal::$target = this;
			}
			
			if ( _eventParent && event.eventPhase <= EventPhase.AT_TARGET ) {
				// 新規イベントオブジェクトを作成する
				var phase1:SceneEvent = SceneEvent( event.clone() );
				phase1.progression_internal::$eventPhase = EventPhase.CAPTURING_PHASE;
				phase1.progression_internal::$target = event.progression_internal::$target;
				
				// イベントを送出する
				result = _eventParent._dispatchEvent( phase1 );
			}
			
			if ( event.eventPhase == EventPhase.CAPTURING_PHASE ) {
				// イベントを送出する
				result = _captureDispatcher.dispatchEvent( event );
			}
			else {
				// イベントを送出する
				result = super.dispatchEvent( event );
			}
			
			if ( event.bubbles && _eventParent && event.eventPhase >= EventPhase.AT_TARGET ) {
				// 新規イベントオブジェクトを作成する
				var phase3:SceneEvent = SceneEvent( event.clone() );
				phase3.progression_internal::$eventPhase = EventPhase.BUBBLING_PHASE;
				phase3.progression_internal::$target = event.progression_internal::$target;
				
				// イベントを送出する
				result = _eventParent._dispatchEvent( phase3 );
			}
			
			return result;
		}
		
		/**
		 * <span lang="ja">EventDispatcher インスタンスに、特定のイベントタイプに対して登録されたリスナーがあるかどうかを確認します。</span>
		 * <span lang="en">Checks whether the EventDispatcher object has any listeners registered for a specific type of event.</span>
		 * 
		 * @param event
		 * <span lang="ja">イベントのタイプです。</span>
		 * <span lang="en">The type of event.</span>
		 * @return
		 * <span lang="ja">指定したタイプのリスナーが登録されている場合は true に、それ以外の場合は false になります。</span>
		 * <span lang="en">A value of true if a listener of the specified type is registered; false otherwise.</span>
		 */
		override public function hasEventListener(type:String):Boolean {
			if ( !_captureDispatcher ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_024 ).toString( toString() ) ); }
			
			return super.hasEventListener( type ) || _captureDispatcher.hasEventListener( type );
		}
		
		/**
		 * <span lang="ja">指定されたイベントタイプについて、この EventDispatcher インスタンスまたはその祖先にイベントリスナーが登録されているかどうかを確認します。</span>
		 * <span lang="en">Checks whether an event listener is registered with this EventDispatcher object or any of its ancestors for the specified event type.</span>
		 * 
		 * @param event
		 * <span lang="ja">イベントのタイプです。</span>
		 * <span lang="en">The type of event.</span>
		 * @return
		 * <span lang="ja">指定したタイプのリスナーがトリガされた場合は true に、それ以外の場合は false になります。</span>
		 * <span lang="en">A value of true if a listener of the specified type will be triggered; false otherwise.</span>
		 */
		override public function willTrigger(type:String):Boolean {
			var result:Boolean = hasEventListener( type );
			
			if ( _eventParent) {
				result ||= _eventParent.hasEventListener( type );
			}
			
			return result;
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		public function dispose():void {
			if ( _manager && sceneId.contains( _manager.currentSceneId ) ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_026 ).toString( toString() ) ); }
			
			while ( _scenes && _scenes.numItems > 0 ) {
				var target:SceneObject = _scenes.getItemAt( 0 ) as SceneObject;
				var disposable:IDisposable = target as IDisposable;
				
				if ( disposable ) {
					disposable.dispose();
				}
				else {
					_removeSceneAt( _scenes.getItemIndex( target ) );
				}
			}
			
			if ( __parent ) {
				__parent.removeScene( this );
			}
			
			SceneObject.progression_internal::$collection.registerId( this, null );
			SceneObject.progression_internal::$collection.registerGroup( this, null );
			
			_id = null;
			_group = null;
			
			_name = null;
			_title = null;
			
			_onSceneLoad = null;
			_onSceneUnload = null;
			_onSceneInit = null;
			_onSceneGoto = null;
			_onSceneDescend = null;
			_onSceneAscend = null;
		}
		
		/**
		 * @private
		 */
		progression_internal function $dispose():void {
			// 破棄する
			dispose();
			
			// ExecutorObject を破棄する
			if ( _executor ) {
				_executor.dispose();
				_executor = null;
			}
			
			// SceneInfo を破棄する
			if ( _sceneInfo ) {
				_sceneInfo.progression_internal::$dispose();
				_sceneInfo = null;
			}
			
			// 破棄する
			_manager = null;
			_stage = null;
			_container = null;
			_root = null;
			
			// イベントを送出する
			super.dispatchEvent( new ManagerEvent( ManagerEvent.MANAGER_DEACTIVATE ) );
		}
		
		/**
		 * <span lang="ja">指定されたオブジェクトの XML ストリング表現を返します。</span>
		 * <span lang="en">Returns a XML string representation of the XML object.</span>
		 * 
		 * @return
		 * <span lang="ja">オブジェクトの XML ストリング表現です。</span>
		 * <span lang="en">The XML string representation of the XML object.</span>
		 */
		public function toXMLString():String {
			// シーンノードを作成する
			var xml:XML = <scene name={ name } cls={ ClassUtil.getClassPath( this ) } />;
			
			// タイトルが存在すれば設定する
			if ( _title ) {
				xml.@title = _title;
			}
			
			// DataHolder のデータを追加する
			if ( dataHolder && dataHolder.data ) {
				xml.appendChild( dataHolder.data );
			}
			
			// 子シーンノードを作成する
			if ( _scenes ) {
				for ( var i:int = 0, l:int = numScenes; i < l; i++ ) {
					xml.appendChild( new XML( SceneObject( _scenes.getItemAt( i ) ).toXMLString() ) );
				}
			}
			
			return xml.toXMLString();
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
			return ObjectUtil.formatToString( this, _classNameObj.toString(), SceneId.isNaS( sceneId ) ? ( id ? "id" : null ) : "sceneId" );
		}
		
		
		
		
		
		/**
		 * シーンオブジェクトが直接、またはシーンオブジェクトを含むサブツリーの追加により、ルートシーン上のシーンリストに追加されたときに送出されます。
		 */
		private static function _sceneAddedToRoot( e:SceneEvent ):void {
			if ( e.eventPhase != EventPhase.AT_TARGET ) { return; }
			
			// 実装する
			var target:SceneObject = e.target as SceneObject;
			target.___parent = target.parent;
			target._executor = ExecutorObject.progression_internal::$equip( target, target.parent );
			
			// イベントリスナーを登録する
			if ( target.parent ) {
				target.parent.addEventListener( ManagerEvent.MANAGER_ACTIVATE, target._managerActivateDeactivate, false, int.MAX_VALUE );
				target.parent.addEventListener( ManagerEvent.MANAGER_DEACTIVATE, target._managerActivateDeactivate, false, int.MAX_VALUE );
			}
			
			if ( target._executor ) {
				// DataHolder を作成する
				var classRef:Class = Progression.config.dataHolder;
				target._dataHolder = new classRef( target );
			}
			else {
				if ( PackageInfo.hasDebugger ) {
					Logger.warn( Logger.getLog( L10NProgressionMsg.getInstance().WARN_003 ).toString( target, "dataHolder" ) );
				}
			}
		}
		
		/**
		 * シーンオブジェクトが直接、またはシーンオブジェクトを含むサブツリーの削除により、ルートシーン上のシーンリストから削除されようとしているときに送出されます。
		 */
		private static function _sceneRemovedFromRoot( e:SceneEvent ):void {
			if ( e.eventPhase != EventPhase.AT_TARGET ) { return; }
			
			// 実装を解除する
			var target:SceneObject = e.target as SceneObject;
			target.___parent = null;
			target._executor = ExecutorObject.progression_internal::$unequip( target );
			
			// イベントリスナーを解除する
			if ( target.parent ) {
				target.parent.removeEventListener( ManagerEvent.MANAGER_ACTIVATE, target._managerActivateDeactivate );
				target.parent.removeEventListener( ManagerEvent.MANAGER_DEACTIVATE, target._managerActivateDeactivate );
			}
			
			// DataHolder を破棄する
			if ( target._dataHolder ) {
				target._dataHolder.dispose();
			}
		}
		
		/**
		 * 
		 */
		private static function _sceneInitComplete( e:SceneEvent ):void {
			if ( e.eventPhase != EventPhase.AT_TARGET ) { return; }
			
			// 既読にする
			var target:SceneObject = e.target as SceneObject;
			target._visited = true;
		}
		
		/**
		 * 
		 */
		private static function _sceneEvent( e:SceneEvent ):void {
			if ( e.eventPhase != EventPhase.AT_TARGET ) { return; }
			
			// 対象を取得する
			var target:SceneObject = e.target as SceneObject;
			
			// イベントハンドラメソッドを実行する
			var type:String = e.type.charAt( 0 ).toUpperCase() + e.type.slice( 1 );
			( target[ "_on" + type ] || target[ "at" + type ] ).apply( target );
		}
		
		
		
		
		
		/**
		 * 
		 */
		private function _managerActivateDeactivate( e:ManagerEvent ):void {
			updateManager();
		}
	}
}
