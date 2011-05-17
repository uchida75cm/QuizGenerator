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
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.text.TextSnapshot;
	
	/**
	 * <span lang="ja">IDisplayObjectContainer インターフェイスは、対象に対して DisplayObjectContainer として必要となる機能を実装します。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public interface IDisplayObjectContainer extends IInteractiveObject {
		
		/**
		 * <span lang="ja">オブジェクトの子に対してマウスが有効かどうかを調べます。</span>
		 * <span lang="en">Determines whether or not the children of the object are mouse enabled.</span>
		 */
		function get mouseChildren():Boolean;
		function set mouseChildren( value:Boolean ):void;
		
		/**
		 * <span lang="ja">このオブジェクトの子の数を返します。</span>
		 * <span lang="en">Returns the number of children of this object.</span>
		 */
		function get numChildren():int;
		
		/**
		 * <span lang="ja">オブジェクトの子に対してタブが有効かどうかを調べます。</span>
		 * <span lang="en">Determines whether the children of the object are tab enabled.</span>
		 */
		function get tabChildren():Boolean;
		function set tabChildren( value:Boolean ):void;
		
		/**
		 * <span lang="ja">この DisplayObjectContainer インスタンスの TextSnapshot オブジェクトを返します。</span>
		 * <span lang="en">Returns a TextSnapshot object for this DisplayObjectContainer instance.</span>
		 */
		function get textSnapshot():TextSnapshot;
		
		
		
		
		
		/**
		 * <span lang="ja">この DisplayObjectContainer インスタンスに子 DisplayObject インスタンスを追加します。</span>
		 * <span lang="en">Adds a child DisplayObject instance to this DisplayObjectContainer instance.</span>
		 * 
		 * @param child
		 * <span lang="ja">対象の DisplayObjectContainer インスタンスの子として追加する DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance to add as a child of this DisplayObjectContainer instance.</span>
		 * @return
		 * <span lang="en">child パラメータで渡す DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance that you pass in the child parameter.</span>
		 */
		function addChild( child:DisplayObject ):DisplayObject;
		
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
		function addChildAt( child:DisplayObject, index:int ):DisplayObject;
		
		/**
		 * <span lang="ja">特定の point ポイントを指定して呼び出した DisplayObjectContainer.getObjectsUnderPoint() メソッドから返されたリストに、セキュリティ上の制約のために省略される表示オブジェクトがあるかどうかを示します。</span>
		 * <span lang="en">Indicates whether the security restrictions would cause any display objects to be omitted from the list returned by calling the DisplayObjectContainer.getObjectsUnderPoint() method with the specified point point.</span>
		 * 
		 * @param point
		 * <span lang="ja">注目するポイントです。</span>
		 * <span lang="en">The point under which to look.</span>
		 * @return
		 * <span lang="en">true は、そのポイントがセキュリティ上の制限のある子表示オブジェクトを含んでいることを示します。</span>
		 * <span lang="en">true if the point contains child display objects with security restrictions.</span>
		 */
		function areInaccessibleObjectsUnderPoint( point:Point ):Boolean;
		
		/**
		 * <span lang="ja">指定された表示オブジェクトが DisplayObjectContainer インスタンスの子であるか、オブジェクト自体であるかを指定します。</span>
		 * <span lang="en">Determines whether the specified display object is a child of the DisplayObjectContainer instance or the instance itself.</span>
		 * 
		 * @param child
		 * <span lang="ja">テストする子 DisplayObject インスタンスです。</span>
		 * <span lang="en">The child object to test.</span>
		 * @return
		 * <span lang="en">child インスタンスが DisplayObjectContainer の子であるか、コンテナ自体である場合は true となります。そうでない場合は false となります。</span>
		 * <span lang="en">true if the child object is a child of the DisplayObjectContainer or the container itself; otherwise false.</span>
		 */
		function contains( child:DisplayObject ):Boolean;
		
		/**
		 * <span lang="ja">指定のインデックス位置にある子表示オブジェクトオブジェクトを返します。</span>
		 * <span lang="en">Returns the child display object instance that exists at the specified index.</span>
		 * 
		 * @param index
		 * <span lang="ja">子 DisplayObject インスタンスのインデックス位置です。</span>
		 * <span lang="en">The index position of the child object.</span>
		 * @return
		 * <span lang="ja">指定されたインデックス位置にある子 DisplayObject インスタンスです。</span>
		 * <span lang="en">The child display object at the specified index position.</span>
		 */
		function getChildAt( index:int ):DisplayObject;
		
		/**
		 * <span lang="ja">指定された名前に一致する子表示オブジェクトを返します。</span>
		 * <span lang="en">Returns the child display object that exists with the specified name.</span>
		 * 
		 * @param name
		 * <span lang="ja">返される子 DisplayObject インスタンスの名前です。</span>
		 * <span lang="en">The name of the child to return.</span>
		 * @return
		 * <span lang="ja">指定された名前を持つ子 DisplayObject インスタンスです。</span>
		 * <span lang="en">The child display object with the specified name.</span>
		 */
		function getChildByName( name:String ):DisplayObject;
		
		/**
		 * <span lang="ja">子 DisplayObject インスタンスのインデックス位置を返します。</span>
		 * <span lang="en">Returns the index position of a child DisplayObject instance.</span>
		 * 
		 * @param child
		 * <span lang="ja">特定する子 DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance to identify.</span>
		 * @return
		 * <span lang="ja">特定する子 DisplayObject インスタンスのインデックス位置です。</span>
		 * <span lang="en">The index position of the child display object to identify.</span>
		 */
		function getChildIndex( child:DisplayObject ):int;
		
		/**
		 * <span lang="ja">指定されたポイントの下にあり、この DisplayObjectContainer インスタンスの子（または孫など）であるオブジェクトの配列を返します。</span>
		 * <span lang="en">Returns an array of objects that lie under the specified point and are children (or grandchildren, and so on) of this DisplayObjectContainer instance.</span>
		 * 
		 * @param point
		 * <span lang="ja">注目するポイントです。</span>
		 * <span lang="en">The point under which to look.</span>
		 * @return
		 * <span lang="ja">指定されたポイントの下にあり、この DisplayObjectContainer インスタンスの子または孫などであるオブジェクトの配列です。</span>
		 * <span lang="en">An array of objects that lie under the specified point and are children (or grandchildren, and so on) of this DisplayObjectContainer instance.</span>
		 */
		function getObjectsUnderPoint( point:Point ):Array;
		
		/**
		 * <span lang="ja">DisplayObjectContainer インスタンスの子リストから指定の DisplayObject インスタンスを削除します。</span>
		 * <span lang="en">Removes the specified child DisplayObject instance from the child list of the DisplayObjectContainer instance.</span>
		 * 
		 * @param child
		 * <span lang="ja">対象の DisplayObjectContainer インスタンスの子から削除する DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance to remove.</span>
		 * @return
		 * <span lang="en">child パラメータで渡す DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance that you pass in the child parameter.</span>
		 */
		function removeChild( child:DisplayObject ):DisplayObject;
		
		/**
		 * <span lang="ja">DisplayObjectContainer の子リストの指定されたインデックス位置から子 DisplayObject インスタンスを削除します。</span>
		 * <span lang="en">Removes a child DisplayObject from the specified index position in the child list of the DisplayObjectContainer.</span>
		 * 
		 * @param index
		 * <span lang="ja">削除する DisplayObject の子インデックスです。</span>
		 * <span lang="en">The child index of the DisplayObject to remove.</span>
		 * @return
		 * <span lang="ja">削除された DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance that was removed.</span>
		 */
		function removeChildAt( index:int ):DisplayObject;
		
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
		function setChildIndex( child:DisplayObject, index:int ):void;
		
		/**
		 * <span lang="ja">指定された 2 つの子オブジェクトの z 順序（重ね順）を入れ替えます。</span>
		 * <span lang="en">Swaps the z-order (front-to-back order) of the two specified child objects.</span>
		 * 
		 * @param child1
		 * <span lang="ja">先頭の子 DisplayObject インスタンスです。</span>
		 * <span lang="en">The first child object.</span>
		 * @param child2
		 * <span lang="ja">2 番目の子 DisplayObject インスタンスです。</span>
		 * <span lang="en">The second child object.</span>
		 */
		function swapChildren( child1:DisplayObject, child2:DisplayObject ):void;
		
		/**
		 * <span lang="ja">子リスト内の指定されたインデックス位置に該当する 2 つの子オブジェクトの z 順序（重ね順）を入れ替えます。</span>
		 * <span lang="en">Swaps the z-order (front-to-back order) of the child objects at the two specified index positions in the child list.</span>
		 * 
		 * @param index1
		 * <span lang="ja">最初の子 DisplayObject インスタンスのインデックス位置です。</span>
		 * <span lang="en">The index position of the first child object.</span>
		 * @param index2
		 * <span lang="ja">2 番目の子 DisplayObject インスタンスのインデックス位置です。</span>
		 * <span lang="en">The index position of the second child object.</span>
		 */
		function swapChildrenAt( index1:int, index2:int ):void;
	}
}
