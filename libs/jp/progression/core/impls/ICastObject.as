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
package jp.progression.core.impls {
	import jp.nium.collections.IIdGroup;
	
	/**
	 * @private
	 */
	public interface ICastObject extends IIdGroup, IExecutable, IDisposable {
		
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
		function get onCastAdded():Function;
		function set onCastAdded( value:Function ):void;
		
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
		function get onCastRemoved():Function;
		function set onCastRemoved( value:Function ):void;
	}
}
