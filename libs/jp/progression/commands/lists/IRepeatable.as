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
package jp.progression.commands.lists {
	import flash.events.IEventDispatcher;
	
	/**
	 * <span lang="ja">IRepeatable インターフェイスは、対象のコマンドに対してループ処理操作を実装します。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public interface IRepeatable extends IEventDispatcher {
		
		/**
		 * <span lang="ja">実行したいループ処理数を取得または設定します。
		 * この値が 0 に設定されている場合には、stop() メソッドで終了させるまで処理し続けます。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #count
		 * @see #stop()
		 */
		function get repeatCount():int;
		function set repeatCount( value:int ):void;
		
		/**
		 * <span lang="ja">現在のループ処理回数を取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #repeatCount
		 * @see #stop()
		 */
		function get count():int;
		
		/**
		 * <span lang="ja">実行中のループ処理を停止させます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #count
		 * @see #repeatCount
		 */
		function stop():void;
	}
}
