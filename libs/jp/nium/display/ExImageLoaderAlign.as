/**
 * jp.nium Classes
 * 
 * @author Copyright (C) 2007-2010 taka:nium.jp, All Rights Reserved.
 * @version 4.0.22
 * @see http://classes.nium.jp/
 * 
 * jp.nium Classes is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 */
package jp.nium.display {
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ClassUtil;
	
	/**
	 * <span lang="ja">ExImageLoaderAlign クラスは、ExImageLoader クラスの画像の基準点となる値を提供します。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.nium.display.ExImageLoader#align
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public final class ExImageLoaderAlign {
		
		/**
		 * <span lang="ja">イメージを左上の隅に揃えるよう指定します。</span>
		 * <span lang="en">Set the image to align to top-left.</span>
		 */
		public static const TOP_LEFT:int = 0;
		
		/**
		 * <span lang="ja">ステージを上揃えにするよう指定します。</span>
		 * <span lang="en">Set the stage to align to top.</span>
		 */
		public static const TOP:int = 1;
		
		/**
		 * <span lang="ja">イメージを右上の隅に揃えるよう指定します。</span>
		 * <span lang="en">Set the image to align to top-right.</span>
		 */
		public static const TOP_RIGHT:int = 2;
		
		/**
		 * <span lang="ja">イメージを左揃えにするよう指定します。</span>
		 * <span lang="en">Set the image to align to left.</span>
		 */
		public static const LEFT:int = 3;
		
		/**
		 * <span lang="ja">イメージを中央に揃えるよう指定します。</span>
		 * <span lang="en">Set the image to align to center.</span>
		 */
		public static const CENTER:int = 4;
		
		/**
		 * <span lang="ja">イメージを右揃えにするよう指定します。</span>
		 * <span lang="en">Set the image to align to right.</span>
		 */
		public static const RIGHT:int = 5;
		
		/**
		 * <span lang="ja">イメージを左下の隅に揃えるよう指定します。</span>
		 * <span lang="en">Set the image to align to bottom-left.</span>
		 */
		public static const BOTTOM_LEFT:int = 6;
		
		/**
		 * <span lang="ja">イメージを下揃えにするよう指定します。</span>
		 * <span lang="en">Set the image to align to bottom.</span>
		 */
		public static const BOTTOM:int = 7;
		
		/**
		 * <span lang="ja">イメージを右下の隅に揃えるよう指定します。</span>
		 * <span lang="en">Set the image to align to bottom-right.</span>
		 */
		public static const BOTTOM_RIGHT:int = 8;
		
		
		
		
		
		/**
		 * @private
		 */
		public function ExImageLoaderAlign() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
	}
}
