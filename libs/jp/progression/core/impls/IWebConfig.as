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
package jp.progression.core.impls {
	
	/**
	 * @private
	 */
	public interface IWebConfig {
		
		/**
		 * <span lang="ja">SWFWheel を有効化するかどうかを取得します。</span>
		 * <span lang="en"></span>
		 */
		function get useSWFWheel():Boolean;
		
		/**
		 * <span lang="ja">SWFSize を有効化するかどうかを取得します。</span>
		 * <span lang="en"></span>
		 */
		function get useSWFSize():Boolean;
		
		/**
		 * <span lang="ja">HTML インジェクション機能を有効化するかどうかを取得します。</span>
		 * <span lang="en"></span>
		 */
		function get useHTMLInjection():Boolean;
	}
}
