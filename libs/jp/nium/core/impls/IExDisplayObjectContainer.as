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
package jp.nium.core.impls {
	import flash.display.DisplayObject;
	
	/**
	 * @private
	 */
	public interface IExDisplayObjectContainer extends IExDisplayObject {
		
		/**
		 * <span lang="ja">子ディスプレイオブジェクトが保存されている配列です。
		 * インデックス値が断続的に指定可能であるため、getChildAt() ではなくこのプロパティを使用して子ディスプレイオブジェクト走査を行います。
		 * この配列を操作することで元の配列を変更することはできません。</span>
		 * <span lang="en">The array that saves child display objects.
		 * Because the index value can specify intermittently, it scans the child display object by not using getChildAt() but using this property.
		 * It can not change the original array by operating this array.</span>
		 */
		function get children():Array;
		
		/**
		 * <span lang="ja"></span>
		 * <span lang="en"></span>
		 */
		function get useChildIndexer():Boolean;
		
		
		
		
		
		/**
		 * <span lang="ja">この DisplayObjectContainer インスタンスの指定されたインデックス位置に子 DisplayObject インスタンスを追加します。</span>
		 * <span lang="en">Adds a child DisplayObject instance to this DisplayObjectContainer instance.</span>
		 * 
		 * @param child
		 * <span lang="ja">対象の DisplayObjectContainer インスタンスの子として追加する DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance to add as a child of this DisplayObjectContainer instance.</span>
		 * @param index
		 * <span lang="ja">子を追加するインデックス位置です。</span>
		 * <span lang="en">The index position to which the child is added. If you specify a currently occupied index position, the child object that exists at that position and all higher positions are moved up one position in the child list.</span>
		 * @return
		 * <span lang="en">child パラメータで渡す DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance that you pass in the child parameter.</span>
		 */
		function addChildAtAbove( child:DisplayObject, index:int ):DisplayObject;
		
		/**
		 * <span lang="ja">DisplayObjectContainer に追加されている全ての子 DisplayObject インスタンスを削除します。</span>
		 * <span lang="en">Removes the whole child DisplayObject instance added to the DisplayObjectContainer.</span>
		 */
		function removeAllChildren():void;
		
		/**
		 * <span lang="ja">表示オブジェクトコンテナの既存の子の位置を変更します。</span>
		 * <span lang="en">Changes the position of an existing child in the display object container.</span>
		 * 
		 * @param child
		 * <span lang="ja">インデックス番号を変更する子 DisplayObject インスタンスです。</span>
		 * <span lang="en">The child DisplayObject instance for which you want to change the index number.</span>
		 * @param index
		 * <span lang="en">child インスタンスの結果のインデックス番号です。</span>
		 * <span lang="en">The resulting index number for the child display object.</span>
		 */
		function setChildIndexAbove( child:DisplayObject, index:int ):void ;
	}
}
