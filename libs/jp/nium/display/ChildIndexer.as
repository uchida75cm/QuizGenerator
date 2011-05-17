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
	
	/**
	 * <span lang="ja"></span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public class ChildIndexer {
		
		/**
		 * <span lang="ja">ChildIndexer 機能が無効化されているかどうかを取得します。</span>
		 * <span lang="en"></span>
		 */
		public static function get enabled():Boolean { return _enabled; }
		private static var _enabled:Boolean = true;
		
		
		
		
		
		/**
		 * @private
		 */
		public function ChildIndexer() {
		}
		
		
		
		
		
		/**
		 * <span lang="ja">ChildIndexer 機能を無効化します。</span>
		 * <span lang="en"></span>
		 */
		public static function disable():void {
			_enabled = false;
		}
	}
}
