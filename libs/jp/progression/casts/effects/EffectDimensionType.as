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
	 * <span lang="ja">EffectDimensionType クラスは、dimension プロパティの値を提供します。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.casts.effects.BlindsEffect
	 * @see jp.progression.casts.effects.SqueezeEffect
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public final class EffectDimensionType {
		
		/**
		 * <span lang="ja">エフェクトを垂直方向に適用するよう指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const VERTICAL:int = 0;
		
		/**
		 * <span lang="ja">エフェクトを水平方向に適用するよう指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const HORIZONTAL:int = 1;
		
		
		
		
		
		/**
		 * @private
		 */
		public function EffectDimensionType() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
	}
}
