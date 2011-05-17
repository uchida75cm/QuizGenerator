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
package jp.nium.impls {
	
	/**
	 * <span lang="ja">IInteractiveObject インターフェイスは、対象に対して InteractiveObject として必要となる機能を実装します。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public interface IInteractiveObject extends IDisplayObject {
		
		/**
		 * <span lang="ja">オブジェクトが doubleClick イベントを受け取るかどうかを指定します。</span>
		 * <span lang="en">Specifies whether the object receives doubleClick events.</span>
		 */
		function get doubleClickEnabled():Boolean;
		function set doubleClickEnabled( value:Boolean ):void;
		
		/**
		 * <span lang="ja">このオブジェクトがフォーカス矩形を表示するかどうかを指定します。</span>
		 * <span lang="en">Specifies whether this object displays a focus rectangle.</span>
		 */
		function get focusRect():Object;
		function set focusRect( value:Object ):void;
		
		/**
		 * <span lang="ja">このオブジェクトがマウスメッセージを受け取るかどうかを指定します。</span>
		 * <span lang="en">Specifies whether this object receives mouse messages.</span>
		 */
		function get mouseEnabled():Boolean;
		function set mouseEnabled( value:Boolean ):void;
		
		/**
		 * <span lang="ja">このオブジェクトがタブ順序に含まれるかどうかを指定します。</span>
		 * <span lang="en">Specifies whether this object is in the tab order.</span>
		 */
		function get tabEnabled():Boolean;
		function set tabEnabled( value:Boolean ):void;
		
		/**
		 * <span lang="ja">SWF ファイル内のオブジェクトのタブ順序を指定します。</span>
		 * <span lang="en">Specifies the tab ordering of objects in a SWF file.</span>
		 */
		function get tabIndex():int;
		function set tabIndex( value:int ):void;
		
		
		
		
		
		/**
		 * 外部 ActionScript ファイルを取り込む
		 */
		include "../core/includes/IInteractiveObject_contextMenu.inc"
	}
}
