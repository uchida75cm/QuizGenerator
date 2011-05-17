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
	import flash.events.IEventDispatcher;
	import jp.progression.core.impls.IDisposable;
	import jp.progression.Progression;
	import jp.progression.scenes.SceneId;
	
	/**
	 * @private
	 */
	public interface ISynchronizer extends IEventDispatcher, IDisposable {
		
		/**
		 * <span lang="ja">関連付けられている Progression インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		function get target():Progression;
		
		/**
		 * <span lang="ja">現在同期中の Progression インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		function get syncedManager():Progression;
		
		/**
		 * <span lang="ja">起点となるシーン識別子を取得します。</span>
		 * <span lang="en"></span>
		 */
		function get sceneId():SceneId;
		
		/**
		 * <span lang="ja">同期機能が有効化されているかどうかを取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		function get enabled():Boolean;
		function set enabled( value:Boolean ):void;
		
		
		
		
		
		/**
		 * <span lang="ja">同期を開始します。</span>
		 * <span lang="en"></span>
		 */
		function start():void;
	}
}
