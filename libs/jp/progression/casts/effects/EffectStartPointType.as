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
package jp.progression.casts.effects {
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ClassUtil;
	
	/**
	 * <span lang="ja">EffectStartPointType クラスは、startPoint プロパティの値を提供します。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.casts.effects.FlyEffect
	 * @see jp.progression.casts.effects.IrisEffect
	 * @see jp.progression.casts.effects.WipeEffect
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public final class EffectStartPointType {
		
		/**
		 * <span lang="ja">エフェクトを左上の隅から開始するよう指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const TOP_LEFT:int = 1;
		
		/**
		 * <span lang="ja">エフェクトを上から開始するよう指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const TOP:int = 2;
		
		/**
		 * <span lang="ja">エフェクトを右上の隅から開始するよう指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const TOP_RIGHT:int = 3;
		
		/**
		 * <span lang="ja">エフェクトを左から開始するよう指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const LEFT:int = 4;
		
		/**
		 * <span lang="ja">エフェクトを中央から開始するよう指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const CENTER:int = 5;
		
		/**
		 * <span lang="ja">エフェクトを右から開始するよう指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const RIGHT:int = 6;
		
		/**
		 * <span lang="ja">エフェクトを左下の隅から開始するよう指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const BOTTOM_LEFT:int = 7;
		
		/**
		 * <span lang="ja">エフェクトを下から開始するよう指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const BOTTOM:int = 8;
		
		/**
		 * <span lang="ja">エフェクトを右下の隅から開始するよう指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const BOTTOM_RIGHT:int = 9;
		
		
		
		
		
		/**
		 * @private
		 */
		public function EffectStartPointType() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
	}
}
