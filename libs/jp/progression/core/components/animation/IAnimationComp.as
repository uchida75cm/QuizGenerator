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
package jp.progression.core.components.animation {
	import jp.progression.core.components.ICoreComp;
	import jp.progression.core.display.AnimationBase;
	
	/**
	 * @private
	 */
	public interface IAnimationComp extends ICoreComp {
		
		/**
		 * <span lang="ja">アニメーション処理実装の基本となるインスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		function get base():AnimationBase;
	}
}
