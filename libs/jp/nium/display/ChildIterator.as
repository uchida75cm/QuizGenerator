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
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import jp.nium.core.impls.IExDisplayObjectContainer;
	
	/**
	 * <span lang="ja">ChildIterator クラスは、IExDisplayObjectContainer インターフェイスを実装しているクラスと実装していないクラスを同じ構文で走査するためのイテレータクラスです。</span>
	 * <span lang="en">ChildIterator class is an iterator class to scan the class which implements or does not implement the IExDsiplayObjectContainer interface, with same syntax.</span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public class ChildIterator {
		
		/**
		 * インデックスを整理する対象コンテナを取得します。
		 */
		private var _container:DisplayObjectContainer;
		
		/**
		 * 現在のインデックス位置を取得します。
		 */
		private var _index:int = 0;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい ChildIterator インスタンスを作成します。</span>
		 * <span lang="en">Creates a new ChildIterator object.</span>
		 * 
		 * @param container
		 * <span lang="ja">関連付けたい DisplayObjectContainer インスタンスです。</span>
		 * <span lang="en">The DisplayObjectContainer instance that want to relate.</span>
		 */
		public function ChildIterator( container:DisplayObjectContainer ) {
			// 引数を保存する
			_container = container;
		}
		
		
		
		
		
		/**
		 * <span lang="ja">現在の対象を返して、次の対象にインデックスを進めます。</span>
		 * <span lang="en">Returns the current object and move the index to the next object.</span>
		 * 
		 * @return
		 * <span lang="ja">現在の対象である DisplayObject インスタンスです。</span>
		 * <span lang="en">The current DisplayObject instance.</span>
		 */
		public function next():DisplayObject {
			// 存在しなければ null を返す
			if ( !_container ) { return null; }
			
			// 次へ進める
			var index:int = _index++;
			
			
			var container:IExDisplayObjectContainer = _container as IExDisplayObjectContainer;
			
			// IExDisplayObjectContainer を実装していれば
			if ( container && container.useChildIndexer ) {
				return IExDisplayObjectContainer( _container ).children[index] as DisplayObject;
			}
			
			return ( index < _container.numChildren ) ? _container.getChildAt( index ) : null;
		}
		
		/**
		 * <span lang="ja">現在のインデックス位置に対象が存在するかどうかを返します。</span>
		 * <span lang="en">Returns if the object exists in the current index position.</span>
		 * 
		 * @return
		 * <span lang="ja">対象が存在すれば true を、存在しなければ false です。</span>
		 * <span lang="en">Returns true if the object exists and returns false if not.</span>
		 */
		public function hasNext():Boolean {
			if ( !_container ) { return false; }
			
			var result:Boolean = ( _index < _container.numChildren );
			
			if ( !result ) {
				_container = null;
			}
			
			return result;
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
			return "[object ChildIterator]";
		}
	}
}
