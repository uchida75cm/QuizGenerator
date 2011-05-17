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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.EventPhase;
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	import jp.nium.collections.IIdGroup;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.core.ns.nium_internal;
	import jp.nium.core.primitives.StringObject;
	import jp.nium.display.ExMovieClip;
	import jp.nium.utils.ClassUtil;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.core.impls.ICastObject;
	import jp.progression.core.impls.IManageable;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.events.CastEvent;
	import jp.progression.events.ManagerEvent;
	import jp.progression.executors.ExecutorObject;
	import jp.progression.Progression;
	
	/**
	 * <span lang="ja">IExecutable オブジェクトが AddChild コマンド、または AddChildAt コマンド経由で表示リストに追加された場合に送出されます。
	 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.CastEvent.CAST_ADDED
	 */
	[Event( name="castAdded", type="jp.progression.events.CastEvent" )]
	
	/**
	 * <span lang="ja">CastEvent.CAST_ADDED イベント中に実行された非同期処理が完了した場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.CastEvent.CAST_ADDED_COMPLETE
	 */
	[Event( name="castAddedComplete", type="jp.progression.events.CastEvent" )]
	
	/**
	 * <span lang="ja">IExecutable オブジェクトが RemoveChild コマンド、または RemoveAllChild コマンド経由で表示リストから削除された場合に送出されます。
	 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.CastEvent.CAST_REMOVED
	 */
	[Event( name="castRemoved", type="jp.progression.events.CastEvent" )]
	
	/**
	 * <span lang="ja">CastEvent.CAST_REMOVED イベント中に実行された非同期処理が完了した場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.CastEvent.CAST_REMOVED_COMPLETE
	 */
	[Event( name="castRemovedComplete", type="jp.progression.events.CastEvent" )]
	
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
	 * <span lang="ja">CastObject クラスは、イベントフローとの連携機能を実装した jp.progression パッケージで使用される基本的な機能を委譲する形で表示オブジェクトに対して実装するクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.casts#getInstanceById()
	 * @see jp.progression.casts#getInstancesByGroup()
	 * 
	 * @example <listing version="3.0">
	 * // Sprite インスタンスを作成する
	 * var sp:Sprite = new Sprite();
	 * 
	 * // Sprite インスタンスの委譲先となる CastObject インスタンスを作成する
	 * var cast:CastObject = new CastObject( sp );
	 * 
	 * // 画面設置時のイベントを設定する
	 * cast.onCastAdded = function():void {
	 * 	trace( "表示されました" );
	 * };
	 * cast.onCastRemoved = function():void {
	 * 	trace( "消去されました" );
	 * };
	 * 
	 * // SerialList コマンドを実行する
	 * new SerialList( null,
	 * 	// 画面に表示する
	 * 	new AddChild( this, cast ),
	 * 	
	 * 	// 画面から消去する
	 * 	new RemoveChild( this, cast )
	 * ).execute();
	 * </listing>
	 */
	public dynamic class CastObject extends Proxy implements ICastObject, IManageable {
		
		/**
		 * 全てのインスタンスを保存した Dictionary インスタンスを取得します。
		 */
		private static var _instances:Dictionary = new Dictionary( true );
		
		
		
		
		
		/**
		 * <span lang="ja">委譲元となる DisplayObject インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get target():DisplayObject { return _target; }
		private var _target:DisplayObject;
		
		/**
		 * <span lang="ja">インスタンスのクラス名を取得します。</span>
		 * <span lang="en">Indicates the instance className of the IExDisplayObject.</span>
		 */
		public function get className():String { return _classNameObj ? _classNameObj.toString() : ClassUtil.nium_internal::$DEFAULT_CLASS_NAME; }
		private var _classNameObj:StringObject;
		
		/**
		 * <span lang="ja">インスタンスの識別子を取得または設定します。</span>
		 * <span lang="en">Indicates the instance id of the IExDisplayObject.</span>
		 * 
		 * @see jp.nium.display#getInstanceById()
		 */
		public function get id():String { return _id; }
		public function set id( value:String ):void {
			// 既存の登録を取得する
			var instance:IIdGroup = ExMovieClip.nium_internal::$collection.getInstanceById( value );
			
			// すでに存在していれば例外をスローする
			if ( instance ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_022 ).toString( value ) ); }
			
			// 登録する
			_id = ExMovieClip.nium_internal::$collection.registerId( this, value ) ? value : null;
		}
		private var _id:String;
		
		/**
		 * <span lang="ja">インスタンスのグループ名を取得または設定します。</span>
		 * <span lang="en">Indicates the instance group of the IExDisplayObject.</span>
		 * 
		 * @see jp.nium.display#getInstancesByGroup()
		 */
		public function get group():String { return _group; }
		public function set group( value:String ):void { _group = ExMovieClip.nium_internal::$collection.registerGroup( this, value ) ? value : null;  }
		private var _group:String;
		
		/**
		 * <span lang="ja">自身の参照を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get self():CastObject { return CastObject( this ); }
		
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
		 * EventDispatcher インスタンスを取得します。
		 */
		private var _dispatcher:EventDispatcher;
		
		/**
		 * 親の表示オブジェクトの参照を取得します。
		 */
		private var _parent:DisplayObjectContainer;
		
		/**
		 * <span lang="ja">キャストオブジェクトが CastEvent.CAST_ADDED イベントを受け取った場合に呼び出されるイベントハンドラメソッドを取得または設定します。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.CastEvent#CAST_ADDED
		 * @see jp.progression.events.CastEvent#CAST_ADDED_COMPLETE
		 */
		public function get onCastAdded():Function { return _onCastAdded; }
		public function set onCastAdded( value:Function ):void { _onCastAdded = value; }
		private var _onCastAdded:Function;
		
		/**
		 * <span lang="ja">キャストオブジェクトが CastEvent.CAST_ADDED イベントを受け取った場合に呼び出されるオーバーライド・イベントハンドラメソッドです。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.CastEvent#CAST_ADDED
		 * @see jp.progression.events.CastEvent#CAST_ADDED_COMPLETE
		 */
		protected function atCastAdded():void {}
		
		/**
		 * <span lang="ja">キャストオブジェクトが CastEvent.CAST_REMOVED イベントを受け取った場合に呼び出されるイベントハンドラメソッドを取得または設定します。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.CastEvent#CAST_REMOVED
		 * @see jp.progression.events.CastEvent#CAST_REMOVED_COMPLETE
		 */
		public function get onCastRemoved():Function { return _onCastRemoved; }
		public function set onCastRemoved( value:Function ):void { _onCastRemoved = value; }
		private var _onCastRemoved:Function;
		
		/**
		 * <span lang="ja">キャストオブジェクトが CastEvent.CAST_REMOVED イベントを受け取った場合に呼び出されるオーバーライド・イベントハンドラメソッドです。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.CastEvent#CAST_REMOVED
		 * @see jp.progression.events.CastEvent#CAST_REMOVED_COMPLETE
		 */
		protected function atCastRemoved():void {}
		
		
		
		
		
		/**
		 * <span lang="ja">新しい CastObject インスタンスを作成します。</span>
		 * <span lang="en">Creates a new CastObject object.</span>
		 * 
		 * @param target
		 * <span lang="ja">コントロール対象となる DisplayObject です。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function CastObject( target:DisplayObject, initObject:Object = null ) {
			// クラスをコンパイルに含める
			nium_internal;
			progression_internal;
			
			// クラス名を取得する
			_classNameObj = ClassUtil.nium_internal::$getClassString( this );
			
			// 引数を設定する
			_target = target;
			
			// EventDispatcher を作成する
			_dispatcher = new EventDispatcher( this );
			
			// 親クラスを初期化する
			super();
			
			// コレクションに登録する
			ExMovieClip.nium_internal::$collection.addInstance( this );
			_instances[target] = this;
			
			// 初期化する
			ObjectUtil.setProperties( this, initObject );
			
			// イベントリスナーを登録する
			_dispatcher.addEventListener( CastEvent.CAST_ADDED, _castEvent, false, 0, true );
			_dispatcher.addEventListener( CastEvent.CAST_REMOVED, _castEvent, false, 0, true );
			target.addEventListener( Event.ADDED_TO_STAGE, _addedToStage, false, int.MAX_VALUE, true );
			target.addEventListener( Event.REMOVED_FROM_STAGE, _removedFromStage, false, int.MAX_VALUE, true );
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
			var manageable:IManageable = _parent as IManageable;
			_manager = manageable ? manageable.manager : null;
			
			// 変更されていなければ終了する
			if ( _manager == oldManager ) { return Boolean( !!_manager ); }
			
			// イベントを送出する
			_dispatcher.dispatchEvent( new ManagerEvent( _manager ? ManagerEvent.MANAGER_ACTIVATE : ManagerEvent.MANAGER_DEACTIVATE, false, false, _manager ) );
			
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
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		public function dispose():void {
			if ( _target.parent ) {
				_target.parent.removeChild( _target );
			}
			
			ExMovieClip.nium_internal::$collection.registerId( this, null );
			ExMovieClip.nium_internal::$collection.registerGroup( this, null );
			
			delete _instances[_target];
			
			_id = null;
			_group = null;
			
			_onCastAdded = null;
			_onCastRemoved = null;
		}
		
		
		/**
		 * <span lang="ja">インスタンスに対して、複数のプロパティを一括設定します。</span>
		 * <span lang="en">Setup the several instance properties.</span>
		 * 
		 * @param parameters
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en">The object that contains the property to setup.</span>
		 * @return
		 * <span lang="ja">自身の参照です。</span>
		 * <span lang="en"></span>
		 */
		public function setProperties( parameters:Object ):CastObject {
			ObjectUtil.setProperties( this, parameters );
			return this;
		}
		
		/**
		 * <span lang="ja">指定されたオブジェクトのストリング表現を返します。</span>
		 * <span lang="en">Returns the string representation of the specified object.</span>
		 * 
		 * @return
		 * <span lang="ja">オブジェクトのストリング表現です。</span>
		 * <span lang="en">A string representation of the object.</span>
		 */
		public function toString():String {
			return ObjectUtil.formatToString( this, _classNameObj.toString(), _id ? "id" : null );
		}
		
		/**
		 * <span lang="ja">イベントリスナーオブジェクトを EventIntegrator インスタンスに登録し、リスナーがイベントの通知を受け取るようにします。
		 * このメソッドを使用して登録されたリスナーを removeEventListener() メソッドで削除した場合には、restoreRemovedListeners() メソッドで再登録させることができます。</span>
		 * <span lang="en">Register the event listener object into the EventIntegrator instance to get the event notification.
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
		public function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void {
			_dispatcher.addEventListener( type, listener, useCapture, priority );
		}
		
		/**
		 * <span lang="ja">EventIntegrator インスタンスからリスナーを削除します。
		 * このメソッドを使用して削除されたリスナーは、restoreRemovedListeners() メソッドで再登録させることができます。</span>
		 * <span lang="en">Remove the listener from EventIntegrator instance.
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
		public function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ):void {
			_dispatcher.removeEventListener( type, listener, useCapture );
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
		public function dispatchEvent( event:Event ):Boolean {
			return _dispatcher.dispatchEvent( event );
		}
		
		/**
		 * <span lang="ja">EventIntegrator インスタンスに、特定のイベントタイプに対して登録されたリスナーがあるかどうかを確認します。</span>
		 * <span lang="en">Checks whether the EventDispatcher object has any listeners registered for a specific type of event.</span>
		 * 
		 * @param event
		 * <span lang="ja">イベントのタイプです。</span>
		 * <span lang="en">The type of event.</span>
		 * @return
		 * <span lang="ja">指定したタイプのリスナーが登録されている場合は true に、それ以外の場合は false になります。</span>
		 * <span lang="en">A value of true if a listener of the specified type is registered; false otherwise.</span>
		 */
		public function hasEventListener( type:String ):Boolean {
			return _dispatcher.hasEventListener( type );
		}
		
		/**
		 * <span lang="ja">指定されたイベントタイプについて、この EventIntegrator インスタンスまたはその祖先にイベントリスナーが登録されているかどうかを確認します。</span>
		 * <span lang="en">Checks whether an event listener is registered with this EventDispatcher object or any of its ancestors for the specified event type.</span>
		 * 
		 * @param event
		 * <span lang="ja">イベントのタイプです。</span>
		 * <span lang="en">The type of event.</span>
		 * @return
		 * <span lang="ja">指定したタイプのリスナーがトリガされた場合は true に、それ以外の場合は false になります。</span>
		 * <span lang="en">A value of true if a listener of the specified type will be triggered; false otherwise.</span>
		 */
		public function willTrigger( type:String ):Boolean {
			return _dispatcher.willTrigger( type );
		}
		
		/**
		 * @private
		 */
		override flash_proxy function callProperty( methodName:*, ... args:Array ):* {
			var func:Function = _target[methodName] as Function;
			
			if ( func != null ) {
				return func.apply( null, args );
			}
			
			return null;
		}
		
		/**
		 * @private
		 */
		override flash_proxy function getProperty( name:* ):* {
			return _target[name];
		}
		
		/**
		 * @private
		 */
		override flash_proxy function setProperty( name:*, value:* ):void {
			_target[name] = value;
		}
		
		/**
		 * @private
		 */
		override flash_proxy function deleteProperty( name:* ):Boolean {
			return delete _target[name];
		}
		
		/**
		 * @private
		 */
		override flash_proxy function hasProperty( name:* ):Boolean {
			return name in _target;
		}
		
		/**
		 * @private
		 */
		override flash_proxy function nextNameIndex( index:int ):int {
			index;
			return -1;
		}
		
		/**
		 * @private
		 */
		override flash_proxy function nextName( index:int ):String {
			index;
			return null;
		}
		
		/**
		 * @private
		 */
		override flash_proxy function nextValue( index:int ):* {
			index;
			return null;
		}
		
		
		
		
		
		private static function _addedToStage( e:Event ):void {
			if ( e.eventPhase != EventPhase.AT_TARGET ) { return; }
			
			// 実装する
			var target:DisplayObject = e.target as DisplayObject;
			var cast:CastObject = _instances[target] as CastObject;
			cast._parent = target.parent;
			cast._executor = ExecutorObject.progression_internal::$equip( cast, target.parent );
			
			// イベントリスナーを登録する
			if ( target.parent ) {
				target.parent.addEventListener( ManagerEvent.MANAGER_ACTIVATE, cast._managerActivateDeactivate, false, int.MAX_VALUE );
				target.parent.addEventListener( ManagerEvent.MANAGER_DEACTIVATE, cast._managerActivateDeactivate, false, int.MAX_VALUE );
			}
		}
		
		/**
		 * 表示オブジェクトが、直接、または表示オブジェクトを含むサブツリーの削除により、表示リストから削除されようとしているときに送出されます。
		 */
		private static function _removedFromStage( e:Event ):void {
			if ( e.eventPhase != EventPhase.AT_TARGET ) { return; }
			
			// 実装を解除する
			var target:DisplayObject = e.target as DisplayObject;
			var cast:CastObject = _instances[target] as CastObject;
			cast._parent = null;
			cast._executor = ExecutorObject.progression_internal::$unequip( cast );
			
			// イベントリスナーを解除する
			if ( target.parent ) {
				target.parent.removeEventListener( ManagerEvent.MANAGER_ACTIVATE, cast._managerActivateDeactivate );
				target.parent.removeEventListener( ManagerEvent.MANAGER_DEACTIVATE, cast._managerActivateDeactivate );
			}
		}
		
		/**
		 * CastEvent イベントの発生時に送出されます。
		 */
		private static function _castEvent( e:CastEvent ):void {
			if ( e.eventPhase != EventPhase.AT_TARGET ) { return; }
			
			// 対象を取得する
			var target:CastObject = e.target as CastObject;
			
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
