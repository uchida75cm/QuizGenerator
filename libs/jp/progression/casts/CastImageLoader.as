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
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventPhase;
	import jp.nium.core.debug.Logger;
	import jp.nium.display.ExImageLoader;
	import jp.progression.core.impls.ICastObject;
	import jp.progression.core.impls.IManageable;
	import jp.progression.core.L10N.L10NProgressionMsg;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.core.PackageInfo;
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
	 * <span lang="ja">CastImageLoader クラスは、ExImageLoader クラスの基本機能を拡張し、イベントフローとの連携機能を実装した jp.progression パッケージで使用される基本的な表示オブジェクトクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.casts#getInstanceById()
	 * @see jp.progression.casts#getInstancesByGroup()
	 * 
	 * @example <listing version="3.0">
	 * // CastImageLoader インスタンスを作成する
	 * var cast:CastImageLoader = new CastImageLoader();
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
	public class CastImageLoader extends ExImageLoader implements ICastObject, IManageable {
		
		/**
		 * <span lang="ja">自身の参照を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get self():CastImageLoader { return CastImageLoader( this ); }
		
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
		 * <span lang="ja">新しい CastImageLoader インスタンスを作成します。</span>
		 * <span lang="en">Creates a new CastImageLoader object.</span>
		 * 
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function CastImageLoader( initObject:Object = null ) {
			// クラスをコンパイルに含める
			progression_internal;
			
			// 親クラスを初期化する
			super( initObject );
			
			// イベントリスナーを登録する
			super.addEventListener( CastEvent.CAST_ADDED, _castEvent, false, 0, true );
			super.addEventListener( CastEvent.CAST_REMOVED, _castEvent, false, 0, true );
			super.addEventListener( Event.ADDED_TO_STAGE, _addedToStage, false, int.MAX_VALUE, true );
			super.addEventListener( Event.REMOVED_FROM_STAGE, _removedFromStage, false, int.MAX_VALUE, true );
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
			if ( super.parent ) {
				super.parent.removeChild( this );
			}
			
			super.id = null;
			super.group = null;
			
			_onCastAdded = null;
			_onCastRemoved = null;
		}
		
		
		
		
		
		/**
		 * 表示オブジェクトが、直接、または表示オブジェクトを含むサブツリーの追加により、ステージ上の表示リストに追加されたときに送出されます。
		 */
		private static function _addedToStage( e:Event ):void {
			if ( e.eventPhase != EventPhase.AT_TARGET ) { return; }
			
			// 実装する
			var target:CastImageLoader = e.target as CastImageLoader;
			target._parent = target.parent;
			target._executor = ExecutorObject.progression_internal::$equip( target, target.parent );
			
			// イベントリスナーを登録する
			if ( target.parent ) {
				target.parent.addEventListener( ManagerEvent.MANAGER_ACTIVATE, target._managerActivateDeactivate, false, int.MAX_VALUE );
				target.parent.addEventListener( ManagerEvent.MANAGER_DEACTIVATE, target._managerActivateDeactivate, false, int.MAX_VALUE );
			}
			
			// コンテクストメニューを設定する
			target["_contextMenuBuilder"] = Progression.config.contextMenuBuilder;
		}
		
		/**
		 * 表示オブジェクトが、直接、または表示オブジェクトを含むサブツリーの削除により、表示リストから削除されようとしているときに送出されます。
		 */
		private static function _removedFromStage( e:Event ):void {
			if ( e.eventPhase != EventPhase.AT_TARGET ) { return; }
			
			// 実装を解除する
			var target:CastImageLoader = e.target as CastImageLoader;
			target._parent = null;
			target._executor = ExecutorObject.progression_internal::$unequip( target );
			
			// イベントリスナーを解除する
			if ( target.parent ) {
				target.parent.removeEventListener( ManagerEvent.MANAGER_ACTIVATE, target._managerActivateDeactivate );
				target.parent.removeEventListener( ManagerEvent.MANAGER_DEACTIVATE, target._managerActivateDeactivate );
			}
			
			// コンテクストメニューを破棄する
			target["_contextMenuBuilder"] = null;
		}
		
		/**
		 * CastEvent イベントの発生時に送出されます。
		 */
		private static function _castEvent( e:CastEvent ):void {
			if ( e.eventPhase != EventPhase.AT_TARGET ) { return; }
			
			// 対象を取得する
			var target:CastImageLoader = e.target as CastImageLoader;
			
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
		
		
		
		
		
		/**
		 * 外部 ActionScript ファイルを取り込む
		 */
		include "../core/includes/CastObject_contextMenu.inc"
	}
}
