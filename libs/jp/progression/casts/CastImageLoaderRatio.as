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
	import jp.nium.utils.ClassUtil;
	
	/**
	 * <span lang="ja">CastImageLoaderRatio クラスは、CastImageLoader クラスの画像比率の処理方法を示す値を提供します。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.casts.CastImageLoader#adjustWidth
	 * @see jp.progression.casts.CastImageLoader#adjustHeight
	 * @see jp.progression.casts.CastImageLoader#ratio
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public final class CastImageLoaderRatio {
		
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
		public function CastImageLoaderRatio() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
	}
}
