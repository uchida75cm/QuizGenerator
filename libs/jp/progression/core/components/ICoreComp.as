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
package jp.progression.core.components {
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;
	
	/**
	 * @private
	 */
	public interface ICoreComp extends IEventDispatcher {
		
		/**
		 * <span lang="ja">コンポーネント効果を適用する対象 MovieClip インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		function get target():MovieClip;
		
		/**
		 * <span lang="ja">コンポーネントが有効化されているかどうかを取得します。</span>
		 * <span lang="en"></span>
		 */
		function get enabled():Boolean;
	}
}
