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
	import jp.progression.Progression;
	
	/**
	 * @private
	 */
	public interface IHistoryManager {
		
		/**
		 * <span lang="ja">関連付けられている Progression インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		function get target():Progression;
		
		/**
		 * <span lang="ja">履歴として登録されているシーン識別子を含んだ配列を取得します。</span>
		 * <span lang="en"></span>
		 */
		function get items():Array;
		
		/**
		 * <span lang="ja">現在の履歴位置を取得します。</span>
		 * <span lang="en"></span>
		 */
		function get position():int;
		
		/**
		 * <span lang="ja">履歴を一つ次に進みます。</span>
		 * <span lang="en"></span>
		 */
		function forward():void;
		
		/**
		 * <span lang="ja">履歴を一つ前に戻ります。</span>
		 * <span lang="en"></span>
		 */
		function back():void;
		
		/**
		 * <span lang="ja">履歴を特定の位置に移動します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param position
		 * <span lang="ja">移動位置を示す数値です。</span>
		 * <span lang="en"></span>
		 */
		function go( position:int ):void;
	}
}
