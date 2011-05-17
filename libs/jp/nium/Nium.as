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
package jp.nium {
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ClassUtil;
	
	/**
	 * <span lang="ja">jp.nium Classes パッケージの基本情報を保持したクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * trace( Nium.NAME );
	 * trace( Nium.VERSION );
	 * trace( Nium.AUTHOR );
	 * trace( Nium.URL );
	 * </listing>
	 */
	public final class Nium {
		
		/**
		 * <span lang="ja">パッケージの名前を取得します。</span>
		 * <span lang="en"></span>
		 */
		public static const NAME:String = "jp.nium Classes";
		
		/**
		 * <span lang="ja">パッケージのバージョン情報を取得します。</span>
		 * <span lang="en"></span>
		 */
		public static const VERSION:String = "4.0.22";
		
		/**
		 * <span lang="ja">パッケージの制作者を取得します。</span>
		 * <span lang="en"></span>
		 */
		public static const AUTHOR:String = "Copyright (C) 2007-2010 taka:nium.jp, All Rights Reserved.";
		
		/**
		 * <span lang="ja">パッケージの URL を取得します。</span>
		 * <span lang="en"></span>
		 */
		public static const URL:String = "http://classes.nium.jp/";
		
		
		
		
		
		/**
		 * @private
		 */
		public function Nium() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
	}
}
