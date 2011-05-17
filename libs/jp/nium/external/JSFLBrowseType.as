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
package jp.nium.external {
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ClassUtil;
	
	/**
	 * <span lang="ja">JSFLBrowseType クラスは、JSFL クラスの browseForFileURL() メソッドを使用した際のファイルの参照操作の種類を示す値を提供します。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.nium.external.JSFL#browseForFileURL()
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public final class JSFLBrowseType {
		
		/**
		 * <span lang="ja">browseForFileURL() メソッドに対してファイルを開くように指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const OPEN:String = "open";
		
		/**
		 * <span lang="ja">browseForFileURL() メソッドに対してファイルを選択するように指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const SELECT:String = "select";
		
		/**
		 * <span lang="ja">browseForFileURL() メソッドに対してファイルを保存するように指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const SAVE:String = "save";
		
		
		
		
		
		/**
		 * @private
		 */
		public function JSFLBrowseType() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
	}
}
