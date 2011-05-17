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
package jp.nium.collections {
	
	/**
	 * <span lang="ja">IIdGroup インターフェイスは、インスタンスに識別子や所属を与える基本的なプロパティを実装します。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public interface IIdGroup {
		
		/**
		 * <span lang="ja">インスタンスの識別子を取得または設定します。</span>
		 * <span lang="en">Indicates the instance id.</span>
		 */
		function get id():String;
		function set id( value:String ):void;
		
		/**
		 * <span lang="ja">インスタンスのグループ名を取得または設定します。</span>
		 * <span lang="en">Indicates the instance group.</span>
		 */
		function get group():String;
		function set group( value:String ):void;
	}
}
