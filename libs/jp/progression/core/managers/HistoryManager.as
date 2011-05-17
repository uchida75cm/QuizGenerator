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
package jp.progression.core.managers {
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.events.ProcessEvent;
	import jp.progression.Progression;
	
	/**
	 * <span lang="ja">HistoryManager クラスは、Progression の動作履歴を管理するためのマネージャークラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public class HistoryManager implements IHistoryManager {
		
		/**
		 * <span lang="ja">関連付けられている Progression インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get target():Progression { return _target; }
		private var _target:Progression;
		
		/**
		 * <span lang="ja">履歴として登録されているシーン識別子を含んだ配列を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get items():Array { return _items.concat(); }
		private var _items:Array;
		
		/**
		 * <span lang="ja">現在の履歴位置を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get position():int { return _position; }
		private var _position:int = 0;
		
		/**
		 * 履歴追加がロックされているかどうかを取得します。
		 */
		private static var _lock:Boolean = false;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい HistoryManager インスタンスを作成します。</span>
		 * <span lang="en">Creates a new HistoryManager object.</span>
		 * 
		 * @param target
		 * <span lang="ja">関連付けたい Progression インスタンスです。</span>
		 * <span lang="en"></span>
		 */
		public function HistoryManager( target:Progression ) {
			// クラスをコンパイルに含める
			progression_internal;
			
			// 引数を設定する
			_target = target;
			
			// 初期化する
			_items = [];
			
			// イベントリスナーを登録する
			_target.addEventListener( ProcessEvent.PROCESS_START, _processStart );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">履歴を一つ次に進みます。</span>
		 * <span lang="en"></span>
		 */
		public function forward():void {
			// 値を更新する
			_position = Math.min( _position + 1, _items.length - 1 );
			
			// 移動する
			_lock = true;
			_target.goto( _items[_position] );
			_lock = false;
		}
		
		/**
		 * <span lang="ja">履歴を一つ前に戻ります。</span>
		 * <span lang="en"></span>
		 */
		public function back():void {
			// 値を更新する
			_position = Math.max( 0, _position - 1 );
			
			// 移動する
			_lock = true;
			_target.goto( _items[_position] );
			_lock = false;
		}
		
		/**
		 * <span lang="ja">履歴を特定の位置に移動します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param position
		 * <span lang="ja">移動位置を示す数値です。</span>
		 * <span lang="en"></span>
		 */
		public function go( position:int ):void {
			// 範囲を超えていたら例外をスローする
			if ( position < 0 || _items.length - 1 < position ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_004 ).toString() ); }
			
			// 移動する
			_lock = true;
			_target.goto( _items[position] );
			_lock = false;
		}
		
		/**
		 * @private
		 */
		progression_internal function $dispose():void {
			// イベントリスナーを解除する
			_target.removeEventListener( ProcessEvent.PROCESS_START, _processStart );
			
			// 破棄する
			_target = null;
			_items = null;
		}
		
		
		
		
		
		/**
		 * シーン移動処理が開始された場合に送出されます。
		 */
		private function _processStart( e:ProcessEvent ):void {
			// ロックされていたら終了する
			if ( _lock ) { return; }
			
			// 現在位置から後の履歴を削除して、新しく追加する
			_items.splice( _position + 1, _items.length, _target.destinedSceneId );
			
			// 現在位置を移動する
			_position = _items.length - 1;
		}
	}
}
