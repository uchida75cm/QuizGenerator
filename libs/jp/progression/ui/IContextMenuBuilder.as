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
	import flash.display.InteractiveObject;
	import jp.progression.core.impls.IDisposable;
	
	/**
	 * <span lang="ja">IContextMenuBuilder インターフェイスは、対象にコンテクストメニュー機能を実装します。</span>
	 * <span lang="en"></span>
	 */
	public interface IContextMenuBuilder extends IDisposable {
		
		/**
		 * <span lang="ja">関連付けられている InteractiveObject インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		function get target():InteractiveObject;
	}
}
