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
package jp.progression.ui {
	import jp.progression.Progression;
	
	/**
	 * <span lang="ja">IKeyboardMapper インターフェイスは、対象にキーボードショートカット機能を実装します。</span>
	 * <span lang="en"></span>
	 */
	public interface IKeyboardMapper {
		
		/**
		 * <span lang="ja">関連付けられている Progression インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		function get target():Progression;
	}
}
