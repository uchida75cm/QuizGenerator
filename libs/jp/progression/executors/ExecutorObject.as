/**
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
package jp.progression.executors {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import jp.nium.collections.UniqueList;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.core.ns.nium_internal;
	import jp.nium.core.primitives.StringObject;
	import jp.nium.events.EventAggregater;
	import jp.nium.utils.ClassUtil;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.core.impls.IDisposable;
	import jp.progression.core.impls.IExecutable;
	import jp.progression.core.L10N.L10NExecuteMsg;
	import jp.progression.core.L10N.L10NProgressionMsg;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.core.PackageInfo;
	import jp.progression.events.ExecuteErrorEvent;
	import jp.progression.events.ExecuteEvent;
	
	/**
	 * <span lang="ja">処理が開始された場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.ExecuteEvent.EXECUTE_START
	 */
	[Event( name="executeStart", type="jp.progression.events.ExecuteEvent" )]
	
	/**
	 * <span lang="ja">処理が完了した場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.ExecuteEvent.EXECUTE_COMPLETE
	 */
	[Event( name="executeComplete", type="jp.progression.events.ExecuteEvent" )]
	
	/**
	 * <span lang="ja">処理が中断された場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.ExecuteEvent.EXECUTE_INTERRUPT
	 */
	[Event( name="executeInterrupt", type="jp.progression.events.ExecuteEvent" )]
	
	/**
	 * <span lang="ja">処理の途中でエラーが発生した場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.ExecuteErrorEvent.EXECUTE_ERROR
	 */
	[Event( name="executeError", type="jp.progression.events.ExecuteErrorEvent" )]
	
	/**
	 * <span lang="ja">ExecutorObject クラスは、非同期処理を実装するための汎用的な実行クラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public class ExecutorObject extends EventDispatcher implements IDisposable {
		
		/**
		 * 実行中の ExecutorObject インスタンスがガベージコレクションされないように参照を保存します。
		 */
		private static var _runningExecutors:UniqueList = new UniqueList();
		
		
		
		
		
		/**
		 * <span lang="ja">インスタンスのクラス名を取得します。</span>
		 * <span lang="en">Indicates the instance className of the SceneObject.</span>
		 */
		public function get className():String { return _classNameObj ? _classNameObj.toString() : ClassUtil.nium_internal::$DEFAULT_CLASS_NAME; }
		private var _classNameObj:StringObject;
		
		/**
		 * <span lang="ja">IEventDispatcher インターフェイスを実装したインスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get target():IEventDispatcher { return _target; }
		private var _target:IEventDispatcher;
		
		/**
		 * <span lang="ja">この ExecutorObject オブジェクトを含む ExecutorObject オブジェクトを示します。</span>
		 * <span lang="en">Indicates the ExecutorObject object that contains this ExecutorObject object.</span>
		 * 
		 * @see #root
		 * @see #next
		 * @see #previous
		 */
		public function get parent():ExecutorObject { return _parent; }
		private var _parent:ExecutorObject;
		
		/**
		 * <span lang="ja">ExecutorObject ツリー構造の一番上に位置する ExecutorObject インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #parent
		 * @see #next
		 * @see #previous
		 */
		public function get root():ExecutorObject { return _parent ? _parent.root : this; }
		
		/**
		 * <span lang="ja">子 ExecutorObject オブジェクトが保存されている配列です。
		 * この配列を操作することで元の配列を変更することはできません。</span>
		 */
		public function get executors():Array { return _executors ? _executors.toArray() : []; }
		private var _executors:UniqueList;
		
		/**
		 * <span lang="ja">登録されている ExecutorObject インスタンス数を取得します。</span>
		 * <span lang="en">Returns the number of children of this ExecutorObject.</span>
		 */
		public function get numExecutors():int { return _executors ? _executors.numItems : 0; }
		
		/**
		 * <span lang="ja">ExecutorObject インスタンスツリー構造上での自身の深度を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get depth():int { return _parent ? _parent.depth + 1 : 0; }
		
		/**
		 * <span lang="ja">現在のイベントタイプを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get eventType():String { return _event ? _event.type : null; }
		
		/**
		 * <span lang="ja">イベントが送出状態であるかどうかを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get dispatching():Boolean { return _dispatching; }
		private var _dispatching:Boolean = false;
		
		/**
		 * <span lang="ja">現在の処理状態を取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #execute()
		 * @see #interrupt()
		 * @see jp.progression.executors.ExecutorObjectState
		 */
		public function get state():int { return _state; }
		private var _state:int = 0;
		
		/**
		 * <span lang="ja">ExecutorObject インスタンスの実行処理、または中断処理の開始時に指定されているリレーオブジェクトを取得または設定します。
		 * この ExecutorObject インスタンスが親の ExecutorObject インスタンスによって実行されている場合には、親のリレーオブジェクトを順々に引き継ぎます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #execute()
		 * @see #interrupt()
		 */
		public function get extra():Object { return _extra; }
		public function set extra( value:Object ):void { _extra = value; }
		private var _extra:Object;
		
		/**
		 * 実行処理関数を取得します。
		 */
		private var _executeFunction:Function;
		
		/**
		 * 中断処理関数を取得します。
		 */
		private var _interruptFunction:Function;
		
		/**
		 * Event インスタンスを取得します。
		 */
		private var _event:Event;
		
		/**
		 * 
		 */
		private var _preRegistration:Boolean;
		
		/**
		 * EventAggregater インスタンスを取得します。
		 */
		private var _aggregater:EventAggregater;
		
		/**
		 * 実行予定の ExecutorObject を保持した配列を取得します。
		 */
		private var _executeExecutors:Array;
		
		/**
		 * 実行中の ExecutorObject を保持した配列を取得します。
		 */
		private var _executingExecutors:Array;
		
		
		
		
		/**
		 * <span lang="ja">新しい ExecutorObject インスタンスを作成します。</span>
		 * <span lang="en">Creates a new ExecutorObject object.</span>
		 * 
		 * @param target
		 * <span lang="ja">関連付けたい IEventDispatcher インスタンスです。</span>
		 * <span lang="en"></span>
		 * @param executeFunction
		 * <span lang="ja">実行関数です。</span>
		 * <span lang="en"></span>
		 * @param interruptFunction
		 * <span lang="ja">中断関数です。</span>
		 * <span lang="en"></span>
		 */
		public function ExecutorObject( target:IEventDispatcher, executeFunction:Function = null, interruptFunction:Function = null ) {
			// クラスをコンパイルに含める
			nium_internal;
			progression_internal;
			
			// クラス名を取得する
			_classNameObj = ClassUtil.nium_internal::$getClassString( this );
			
			// 親クラスを初期化する
			super();
			
			// 引数を設定する
			_target = target;
			_executeFunction = executeFunction;
			_interruptFunction = interruptFunction;
		}
		
		
		
		
		
		/**
		 * @private
		 */
		progression_internal static function $equip( child:*, parent:* ):ExecutorObject {
			// Progression インスタンスとの関連付けを更新する
			child.updateManager();
			
			try {
				// ExecutorObject を作成する
				var classRef:Class = Object( PackageInfo.managerClassRef ).config.executor;
				var executor:ExecutorObject = new classRef( child );
				
				// 親が IExecutable であれば
				var executable:IExecutable = parent as IExecutable;
				if ( executable && executable.executor ) {
					executable.executor.addExecutor( executor );
				}
			}
			catch ( err:Error ) {
				if ( PackageInfo.hasDebugger ) {
					Logger.warn( Logger.getLog( L10NProgressionMsg.getInstance().WARN_003 ).toString( child, "executor" ) );
				}
			}
			
			return executor;
		}
		
		/**
		 * @private
		 */
		progression_internal static function $unequip( child:* ):ExecutorObject {
			// Progression インスタンスとの関連付けを更新する
			child.updateManager();
			
			// ExecutorObject が存在すれば
			var executable:IExecutable = child as IExecutable;
			if ( executable && executable.executor ) {
				// 登録済みであれば解除する
				if ( executable.executor.parent ) {
					executable.executor.parent.removeExecutor( executable.executor );
				}
				
				// ExecutorObject を破棄する
				executable.executor.dispose();
			}
			
			return null;
		}
		
		/**
		 * @private
		 */
		progression_internal static function $addCommand( executor:ExecutorObject, commands:Array ):void {
			if ( !executor ) { throw new Error( Logger.getLog( L10NExecuteMsg.getInstance().ERROR_009 ).toString( "addCommand" ) ); }
			if ( !( "addCommand" in executor ) ) { throw new Error( Logger.getLog( L10NExecuteMsg.getInstance().ERROR_001 ).toString( "addCommand", "CommandExecutor" ) ); }
			
			Object( executor ).addCommand.apply( null, commands );
		}
		
		/**
		 * @private
		 */
		progression_internal static function $insertCommand( executor:ExecutorObject, commands:Array ):void {
			if ( !executor ) { throw new Error( Logger.getLog( L10NExecuteMsg.getInstance().ERROR_009 ).toString( "insertCommand" ) ); }
			if ( !( "insertCommand" in executor ) ) { throw new Error( Logger.getLog( L10NExecuteMsg.getInstance().ERROR_001 ).toString( "insertCommand", "CommandExecutor" ) ); }
			
			Object( executor ).insertCommand.apply( null, commands );
		}
		
		/**
		 * @private
		 */
		progression_internal static function $clearCommand( executor:ExecutorObject, completely:Boolean ):void {
			if ( !executor ) { throw new Error( Logger.getLog( L10NExecuteMsg.getInstance().ERROR_009 ).toString( "clearCommand" ) ); }
			if ( !( "clearCommand" in executor ) ) { throw new Error( Logger.getLog( L10NExecuteMsg.getInstance().ERROR_001 ).toString( "clearCommand", "CommandExecutor" ) ); }
			
			Object( executor ).clearCommand( completely );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">処理を実行します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param event
		 * <span lang="en">ExecutorObject に登録された対象に対して送出するトリガーイベントです。</span>
		 * <span lang="en"></span>
		 * @param extra
		 * <span lang="ja">実行時に設定されるリレーオブジェクトです。</span>
		 * <span lang="en"></span>
		 * @param preRegistration
		 * <span lang="ja">実行対象の ExecutorObject を処理を行う前に登録するようにするかどうかです。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #state
		 * @see #extra
		 * @see #executeComplete()
		 * @see #interrupt()
		 */
		public function execute( event:Event, extra:Object = null, preRegistration:Boolean = true ):void {
			// 実行中であれば例外をスローする
			if ( _state > 0 ) { throw new Error( Logger.getLog( L10NExecuteMsg.getInstance().ERROR_002 ).toString( _classNameObj.toString() ) ); }
			
			// 引数を保存する
			_event = event;
			_extra = extra;
			_preRegistration = preRegistration;
			
			// 実行リストに追加する
			_runningExecutors.addItem( this );
			
			// イベントを送出する
			super.dispatchEvent( new ExecuteEvent( ExecuteEvent.EXECUTE_START, false, false, this ) );
			
			// 実行予定の ExecutorObject を取得します。
			if ( _preRegistration ) {
				_executeExecutors = _executors ? _executors.toArray() : [];
			}
			
			// 状態を変更する
			_state = 2;
			
			// 状態を変更する
			_dispatching = true;
			
			// イベントを送出する
			_target.dispatchEvent( _event );
			
			// 状態を変更する
			_dispatching = false;
			
			// 処理を実行する
			if ( _executeFunction != null ) {
				_executeFunction();
			}
			else {
				_executeComplete();
			}
		}
		
		/**
		 * <span lang="ja">実行中の処理が完了したことを通知します。
		 * このメソッドを実行するためには、事前に execute() メソッドが実行されている必要があります。</span>
		 * <span lang="en"></span>
		 */
		protected function executeComplete():void {
			// 実行中でなければ例外をスローする
			if ( _state < 1 ) { throw new Error( Logger.getLog( L10NExecuteMsg.getInstance().ERROR_003 ).toString( _classNameObj.toString() ) ); }
			
			// 処理を完了する
			_executeComplete();
		}
		
		/**
		 * 完了処理を行います。
		 */
		private function _executeComplete():void {
			// 処理を実行する
			if ( numExecutors > 0 ) {
				_executeChildren();
			}
			else {
				// 破棄する
				_destroy();
				
				// イベントを送出する
				super.dispatchEvent( new ExecuteEvent( ExecuteEvent.EXECUTE_COMPLETE, false, false, this ) );
			}
		}
		
		/**
		 * 子の ExecutorObject を実行する
		 */
		private function _executeChildren():void {
			// 初期化する
			_executingExecutors = [];
			
			// EventAggregater を作成する
			_aggregater = new EventAggregater();
			_aggregater.addEventListener( Event.COMPLETE, _complete );
			
			// 実行予定の ExecutorObject を取得します。
			_executeExecutors ||= _executors ? _executors.toArray() : [];
			
			// 子 ExecutorObject を登録します。
			for ( var i:int = 0, l:int = _executeExecutors.length; i < l; i++ ) {
				var executor:ExecutorObject = ExecutorObject( _executeExecutors[i] );
				
				// イベント待ち対象に登録する
				_aggregater.addEventDispatcher( executor, ExecuteEvent.EXECUTE_COMPLETE );
				
				// イベントリスナーを登録する
				executor.addEventListener( ExecuteEvent.EXECUTE_INTERRUPT, _executeInterrupt );
				executor.addEventListener( ExecuteErrorEvent.EXECUTE_ERROR, super.dispatchEvent );
				
				// 登録する
				_executingExecutors.push( executor );
			}
			
			// 実行中の ExecutorObject が存在しなければ
			if ( _executingExecutors.length == 0 ) {
				_complete( null );
				return;
			}
			
			// 子 ExecutorObject を実行します。
			for ( i = 0, l = _executingExecutors.length; i < l; i++ ) {
				executor = ExecutorObject( _executingExecutors[i] );
				
				if ( !executor ) { continue; }
				
				// すでに実行中であれば中断する
				if ( executor.state > 0 ) {
					executor.interrupt();
				}
				
				// 実行する
				if ( _event ) {
					executor.execute( _event, _extra, _preRegistration );
				}
			}
		}
		
		/**
		 * <span lang="ja">処理を中断します。
		 * このメソッドを実行するためには、事前に execute() メソッドが実行されている必要があります。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #state
		 * @see #execute()
		 */
		public function interrupt():void {
			// 実行中でなければ例外をスローする
			if ( _state < 1 ) { throw new Error( Logger.getLog( L10NExecuteMsg.getInstance().ERROR_003 ).toString( _classNameObj.toString() ) ); }
			
			// 状態を変更する
			_state = 3;
			
			// 中断処理を実行する
			if ( _interruptFunction != null ) {
				_interruptFunction();
			}
			
			// 中断処理中であれば
			if ( _state == 3 ) {
				// 破棄処理を実行する
				_destroy();
				
				// イベントを送出する
				super.dispatchEvent( new ExecuteEvent( ExecuteEvent.EXECUTE_INTERRUPT, false, false, this ) );
			}
		}
		
		/**
		 * <span lang="ja">この ExecutorObject インスタンスに子 ExecutorObject インスタンスを追加します。</span>
		 * <span lang="en">Adds a child ExecutorObject instance to this ExecutorObject instance.</span>
		 * 
		 * @param executor
		 * <span lang="ja">対象の ExecutorObject インスタンスの子として追加する ExecutorObject インスタンスです。</span>
		 * <span lang="en">The ExecutorObject instance to add as a executor of this ExecutorObject instance.</span>
		 * @return
		 * <span lang="en">executor パラメータで渡す ExecutorObject インスタンスです。</span>
		 * <span lang="en">The ExecutorObject instance that you pass in the executor parameter.</span>
		 */
		public function addExecutor( executor:ExecutorObject ):ExecutorObject {
			// すでに親が存在していれば解除する
			var parent:ExecutorObject = executor.parent;
			if ( parent ) {
				parent.removeExecutor( executor );
			}
			
			// 存在しなければ作成する
			_executors ||= new UniqueList();
			
			// 登録する
			_executors.addItem( executor );
			executor._parent = this;
			
			return executor;
		}
		
		/**
		 * <span lang="ja">ExecutorObject インスタンスの子リストから指定の ExecutorObject インスタンスを削除します。</span>
		 * <span lang="en">Removes the specified child ExecutorObject instance from the executor list of the ExecutorObject instance.</span>
		 * 
		 * @param executor
		 * <span lang="ja">対象の ExecutorObject インスタンスの子から削除する ExecutorObject インスタンスです。</span>
		 * <span lang="en">The ExecutorObject instance to remove.</span>
		 * @return
		 * <span lang="en">executor パラメータで渡す ExecutorObject インスタンスです。</span>
		 * <span lang="en">The ExecutorObject instance that you pass in the executor parameter.</span>
		 */
		public function removeExecutor( executor:ExecutorObject ):ExecutorObject {
			if ( !_executors ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_011 ).toString( executor ) ); }
			
			// 登録を解除する
			_executors.removeItem( executor );
			executor._parent = null;
			
			// 登録情報が存在しなければ
			if ( _executors.numItems < 1 ) {
				_executors.dispose();
				_executors = null;
			}
			
			return executor;
		}
		
		/**
		 * <span lang="ja">ExecutorObject に追加されている全ての子 ExecutorObject インスタンスを削除します。</span>
		 * <span lang="en"></span>
		 */
		public function removeAllExecutors():void {
			while ( numExecutors > 0 ) {
				removeExecutor( _executors.getItemAt( 0 ) as ExecutorObject );
			}
		}
		
		/**
		 * <span lang="ja">指定された ExecutorObject インスタンスが ExecutorObject インスタンスの子であるか、オブジェクト自体であるかを指定します。</span>
		 * <span lang="en">Determines whether the specified ExecutorObject is a executor of the ExecutorObject instance or the instance itself.</span>
		 * 
		 * @param executor
		 * <span lang="ja">テストする子 ExecutorObject インスタンスです。</span>
		 * <span lang="en">The executor object to test.</span>
		 * @return
		 * <span lang="en">executor インスタンスが ExecutorObject の子であるか、コンテナ自体である場合は true となります。そうでない場合は false となります。</span>
		 * <span lang="en">true if the executor object is a executor of the ExecutorObject or the container itself; otherwise false.</span>
		 */
		public function contains( executor:ExecutorObject ):Boolean {
			// 自身であれば true を返す
			if ( executor == this ) { return true; }
			
			// 子または孫に存在すれば true を返す
			for ( var i:int = 0, l:int = numExecutors; i < l; i++ ) {
				if ( _executors.contains( executor ) ) { return true; }
				if ( ExecutorObject( _executors.getItemAt( i ) ).contains( executor ) ) { return true; }
			}
			
			return false;
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		public function dispose():void {
			// 親が存在すれば削除する
			if ( _parent ) {
				_parent.removeExecutor( this );
			}
			
			// 破棄する
			_target = null;
		}
		
		/**
		 * 破棄します。
		 */
		private function _destroy():void {
			// EventAggregater が存在したら破棄する
			if ( _aggregater ) {
				for ( var i:int = 0, l:int = _executingExecutors.length; i < l; i++ ) {
					var executor:ExecutorObject = ExecutorObject( _executingExecutors[i] );
					
					_aggregater.removeEventDispatcher( executor, ExecuteEvent.EXECUTE_COMPLETE );
					
					executor.removeEventListener( ExecuteEvent.EXECUTE_INTERRUPT, _executeInterrupt );
					executor.removeEventListener( ExecuteErrorEvent.EXECUTE_ERROR, super.dispatchEvent );
				}
				
				_aggregater.removeEventListener( Event.COMPLETE, _complete );
				_aggregater = null;
				
				_executingExecutors = [];
			}
			
			// 破棄する
			_event = null;
			_extra = null;
			_executeExecutors = null;
			
			// 状態を変更する
			_state = 0;
			
			// 実行リストから削除する
			_runningExecutors.removeItem( this );
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
			return ObjectUtil.formatToString( this, _classNameObj.toString() );
		}
		
		
		
		
		
		/**
		 * 登録されている全ての EventDispatcher インスタンスがイベントを送出した場合に送出されます。
		 */
		private function _complete( e:Event ):void {
			// 破棄する
			_destroy();
			
			// イベントを送出する
			super.dispatchEvent( new ExecuteEvent( ExecuteEvent.EXECUTE_COMPLETE, false, false, this ) );
		}
		
		/**
		 * 処理が中断された場合に送出されます。
		 */
		private function _executeInterrupt( e:ExecuteEvent ):void {
			// 中断する
			interrupt();
		}
	}
}

