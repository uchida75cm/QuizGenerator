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
	 * <span lang="ja">EffectDirectionType クラスは、directionType プロパティの値を提供します。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.casts.effects.BlindsEffect
	 * @see jp.progression.casts.effects.FadeEffect
	 * @see jp.progression.casts.effects.FlyEffect
	 * @see jp.progression.casts.effects.IrisEffect
	 * @see jp.progression.casts.effects.PhotoEffect
	 * @see jp.progression.casts.effects.PixelDissolveEffect
	 * @see jp.progression.casts.effects.RotateEffect
	 * @see jp.progression.casts.effects.SqueezeEffect
	 * @see jp.progression.casts.effects.WipeEffect
	 * @see jp.progression.casts.effects.ZoomEffect
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public final class EffectDirectionType {
		
		/**
		 * <span lang="ja">エフェクトが開始方向のイージングをするよう指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const IN:String = "in";
		
		/**
		 * <span lang="ja">エフェクトが終了方向のイージングをするよう指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const OUT:String = "out";
		
		/**
		 * <span lang="ja">エフェクトが開始・終了方向のイージングをするよう指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const IN_OUT:String = "inOut";
		
		
		
		
		
		/**
		 * @private
		 */
		public function EffectDirectionType() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
	}
}
