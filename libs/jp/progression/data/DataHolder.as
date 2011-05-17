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
package jp.progression.data {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.progression.core.impls.IDisposable;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.events.DataProvideEvent;
	import jp.progression.scenes.SceneObject;
	
	/**
	 * <span lang="ja">管理するデータが更新された場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.DataProvideEvent.DATA_UPDATE
	 */
	[Event( name="dataUpdate", type="jp.progression.events.DataProvideEvent" )]
	
	/**
	 * <span lang="ja">DataHolder クラスは、シーンに対して汎用的なデータ管理機能を提供します。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public dynamic class DataHolder extends EventDispatcher implements IDisposable {
		
		/**
		 * <span lang="ja">関連付けられている SceneObject インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get target():SceneObject { return _target; }
		private var _target:SceneObject;
		
		/**
		 * <span lang="ja">保持しているデータを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get data():Object { return _data; }
		private var _data:Object;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい DataHolder インスタンスを作成します。</span>
		 * <span lang="en">Creates a new DataHolder object.</span>
		 * 
		 * @param target
		 * <span lang="ja">関連付けたい SceneObject インスタンスです。</span>
		 * <span lang="en"></span>
		 */
		public function DataHolder( target:SceneObject ) {
			// クラスをコンパイルに含める
			progression_internal;
			
			// 引数を設定する
			_target = target;
			
			// 更新する
			update();
		}
		
		
		
		
		
		/**
		 * <span lang="ja">保持しているデータを更新します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #data
		 */
		public function update():void {
			var oldData:* = _data;
			
			// データを更新する
			_data = SceneObject.progression_internal::$providingData;
			SceneObject.progression_internal::$providingData = null;
			
			if ( oldData != _data ) {
				// イベントを送出する
				super.dispatchEvent( new DataProvideEvent( DataProvideEvent.DATA_UPDATE, false, false, oldData, _data ) );
			}
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		public function dispose():void {
			// 破棄する
			_data = null;
			_target = null;
		}
		
		/**
		 * @private
		 */
		override public function dispatchEvent( event:Event ):Boolean {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "dispatchEvent" ) );
		}
	}
}
