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
	 * <span lang="ja">ExImageLoaderRatio クラスは、ExImageLoader クラスの画像比率の処理方法を示す値を提供します。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.nium.display.ExImageLoader#adjustWidth
	 * @see jp.nium.display.ExImageLoader#adjustHeight
	 * @see jp.nium.display.ExImageLoader#ratio
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public final class ExImageLoaderRatio {
		
		/**
		 * <span lang="ja">イメージの比率を保持せずに指定された調整サイズに変形するよう指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const NONE:int = 0;
		
		/**
		 * <span lang="ja">縦または横のいずれか短い辺が、指定された調整サイズと一致させながら変形するよう指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const OVERFLOW:int = 1;
		
		/**
		 * <span lang="ja">縦または横のいずれか長い辺が、指定された調整サイズと一致させながら変形するよう指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const SQUEEZE:int = 2;
		
		
		
		
		
		/**
		 * @private
		 */
		public function ExImageLoaderRatio() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
	}
}
