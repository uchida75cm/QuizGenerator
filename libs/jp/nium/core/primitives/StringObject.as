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
package jp.nium.core.primitives {
	
	/**
	 * @private
	 */
	public final class StringObject {
		
		/**
		 * プリミティブな文字列を取得します。
		 */
		private var _str:String;
		
		
		
		
		
		/**
		 * @private
		 */
		public function StringObject( str:String ) {
			// 引数を設定する
			_str = str;
		}
		
		
		
		
		
		/**
		 * <span lang="ja">指定されたオブジェクトのストリング表現を返します。</span>
		 * <span lang="en">Returns the string representation of the specified object.</span>
		 * 
		 * @return
		 * <span lang="ja">オブジェクトのストリング表現です。</span>
		 * <span lang="en">A string representation of the object.</span>
		 */
		public function toString():String {
			return _str;
		}
	}
}
