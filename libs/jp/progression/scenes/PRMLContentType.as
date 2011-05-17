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
package jp.progression.scenes {
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ClassUtil;
	
	/**
	 * <span lang="ja">PRMLContentType クラスは、PRML 形式のフォーマットを示す値を提供します。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public final class PRMLContentType {
		
		/**
		 * <span lang="ja">XML データがもっとも基本的な PRML 形式となるように指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const PLAIN:String = "text/prml.plain";
		
		/**
		 * <span lang="ja">XML データが EasyCasting 用に拡張された PRML 形式となるように指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const EASYCASTING:String = "text/prml.easycasting";
		
		
		
		
		
		/**
		 * @private
		 */
		public function PRMLContentType() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
	}
}
