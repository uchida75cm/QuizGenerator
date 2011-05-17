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
package jp.progression {
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ClassUtil;
	
	/**
	 * <span lang="ja">ActivatedLicenseType クラスは、Progression ライブラリに対して、ライセンスに応じた適切な挙動を設定する値を提供します。
	 * 適用可能なライセンスは使用者の有している権利の範囲内に限ります。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.config
	 * 
	 * @example <listing version="3.0">
	 * // Progression のライセンスを「Progression™ Library License Basic」として設定する
	 * Progression.initialize( new BasicAppConfig( ActivatedLicenseType.PLL_BASIC ) );
	 * </listing>
	 */
	public final class ActivatedLicenseType {
		
		/**
		 * <span lang="ja">ライセンスを「Progression™ Library License Basic」として指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const PLL_BASIC:String = "PLL Basic";
		
		/**
		 * <span lang="ja">ライセンスを「Progression™ Library License Web」として指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const PLL_WEB:String = "PLL Web";
		
		/**
		 * <span lang="ja">ライセンスを「Progression™ Library License Application」として指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const PLL_APPLICATION:String = "PLL Application";
		
		/**
		 * <span lang="ja">ライセンスを「GPL」として指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const GPL:String = "GPL";
		
		
		
		
		
		/**
		 * @private
		 */
		public function ActivatedLicenseType() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
	}
}
