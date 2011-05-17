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
package jp.progression.casts {
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.display.ExImageLoaderAlign;
	import jp.nium.utils.ClassUtil;
	
	/**
	 * <span lang="ja">CastImageLoaderAlign クラスは、CastImageLoader クラスの画像の基準点となる値を提供します。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.casts.CastImageLoader#align
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public final class CastImageLoaderAlign {
		
		/**
		 * <span lang="ja">イメージを左上の隅に揃えるよう指定します。</span>
		 * <span lang="en">Set the image to align to top-left.</span>
		 */
		public static const TOP_LEFT:int = ExImageLoaderAlign.TOP_LEFT;
		
		/**
		 * <span lang="ja">ステージを上揃えにするよう指定します。</span>
		 * <span lang="en">Set the stage to align to top.</span>
		 */
		public static const TOP:int = ExImageLoaderAlign.TOP;
		
		/**
		 * <span lang="ja">イメージを右上の隅に揃えるよう指定します。</span>
		 * <span lang="en">Set the image to align to top-right.</span>
		 */
		public static const TOP_RIGHT:int = ExImageLoaderAlign.TOP_RIGHT;
		
		/**
		 * <span lang="ja">イメージを左揃えにするよう指定します。</span>
		 * <span lang="en">Set the image to align to left.</span>
		 */
		public static const LEFT:int = ExImageLoaderAlign.LEFT;
		
		/**
		 * <span lang="ja">イメージを中央に揃えるよう指定します。</span>
		 * <span lang="en">Set the image to align to center.</span>
		 */
		public static const CENTER:int = ExImageLoaderAlign.CENTER;
		
		/**
		 * <span lang="ja">イメージを右揃えにするよう指定します。</span>
		 * <span lang="en">Set the image to align to right.</span>
		 */
		public static const RIGHT:int = ExImageLoaderAlign.RIGHT;
		
		/**
		 * <span lang="ja">イメージを左下の隅に揃えるよう指定します。</span>
		 * <span lang="en">Set the image to align to bottom-left.</span>
		 */
		public static const BOTTOM_LEFT:int = ExImageLoaderAlign.BOTTOM_LEFT;
		
		/**
		 * <span lang="ja">イメージを下揃えにするよう指定します。</span>
		 * <span lang="en">Set the image to align to bottom.</span>
		 */
		public static const BOTTOM:int = ExImageLoaderAlign.BOTTOM;
		
		/**
		 * <span lang="ja">イメージを右下の隅に揃えるよう指定します。</span>
		 * <span lang="en">Set the image to align to bottom-right.</span>
		 */
		public static const BOTTOM_RIGHT:int = ExImageLoaderAlign.BOTTOM_RIGHT;
		
		
		
		
		
		/**
		 * @private
		 */
		public function CastImageLoaderAlign() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
	}
}
