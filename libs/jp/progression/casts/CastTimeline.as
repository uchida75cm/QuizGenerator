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
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.display.ExDocument;
	import jp.nium.events.CollectionEvent;
	import jp.progression.core.impls.ICastObject;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.executors.ExecutorObject;
	import jp.progression.Progression;
	
	include "../core/includes/CastTimeline_import.inc"
	
	/**
	 * <span lang="ja">CastDocument クラスは、ExDocument クラスの基本機能を拡張し、Flash IDE でタイムラインをベースとして開発する際のドキュメント専用クラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.casts#getInstanceById()
	 * @see jp.progression.casts#getInstancesByGroup()
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public dynamic class CastTimeline extends ExDocument implements ICastObject {
		
		/**
		 * <span lang="ja">関連付けられている ExecutorObject インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get executor():ExecutorObject { return null; }
		
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
		 * <span lang="ja">新しい CastTimeline インスタンスを作成します。</span>
		 * <span lang="en">Creates a new CastTimeline object.</span>
		 */
		public function CastTimeline() {
			// クラスをコンパイルに含める
			progression_internal;
			
			// 親クラスを初期化する
			super();
			
			// イベントリスナーを登録する
			super.addEventListener( Event.ADDED_TO_STAGE, _addedToStage, false, int.MAX_VALUE, true );
			super.addEventListener( Event.REMOVED_FROM_STAGE, _removedFromStage, false, int.MAX_VALUE, true );
			Progression.progression_internal::$collection.addEventListener( CollectionEvent.COLLECTION_UPDATE, _collectionUpdate, false, 0, true );
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
		 * @private
		 */
		public function dispose():void {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "dispose" ) );
		}
		
		
		
		
		
		/**
		 * コレクションに対して、インスタンスが追加された場合に送出されます。
		 */
		private function _collectionUpdate( e:CollectionEvent ):void {
			// 更新する
			_addedToStage( null );
		}
		
		/**
		 * 表示オブジェクトが、直接、または表示オブジェクトを含むサブツリーの追加により、ステージ上の表示リストに追加されたときに送出されます。
		 */
		private function _addedToStage( e:Event ):void {
			// ステージ設定を初期化します。
			if ( super.stage.align == "" ) {
				super.stage.align = StageAlign.TOP_LEFT;
			}
			super.stage.quality = StageQuality.HIGH;
			super.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// コンテクストメニューを設定する
			if ( Progression.config ) {
				_contextMenuBuilder = Progression.config.contextMenuBuilder;
			}
		}
		
		/**
		 * 表示オブジェクトが、直接、または表示オブジェクトを含むサブツリーの削除により、表示リストから削除されようとしているときに送出されます。
		 */
		private function _removedFromStage( e:Event ):void {
			// コンテクストメニューを破棄する
			_contextMenuBuilder = null;
		}
		
		
		
		
		
		/**
		 * 外部 ActionScript ファイルを取り込む
		 */
		include "../core/includes/CastObject_contextMenu.inc"
	}
}
