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
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	
	/**
	 * <span lang="ja">重複する値の登録を許可しないリストオブジェクトです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * var item1:Object = {};
	 * var item2:Object = {};
	 * 
	 * var list:UniqueList = new UniqueList();
	 * 
	 * list.addItem( item1 );
	 * list.addItem( item2 );
	 * list.addItem( item1 );
	 * 
	 * trace( list.numItems == 2 ); // true
	 * trace( list.getItemAt( 1 ) == item1 ); // true
	 * </listing>
	 */
	public class UniqueList {
		
		/**
		 * <span lang="ja">子アイテムとして登録されているオブジェクト数を取得します。</span>
		 * <span lang="en">Returns the number of children of this Item.</span>
		 */
		public function get numItems():int { return _items.length; }
		
		/**
		 * 子アイテムを保持している配列を取得します。
		 */
		private var _items:Array;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい UniqueList インスタンスを作成します。</span>
		 * <span lang="en">Creates a new UniqueList object.</span>
		 * 
		 * @param items
		 * <span lang="ja">登録したいオブジェクトを含む配列です。</span>
		 * <span lang="en"></span>
		 */
		public function UniqueList( ... items:Array ) {
			// 引数を設定する
			_items = [];
			
			// 追加する
			for ( var i:int = 0, l:int = items.length; i < l; i++ ) {
				_addItemAt( items[i], _items.length );
			}
		}
		
		
		
		
		
		/**
		 * <span lang="ja">子アイテムとして登録します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param item
		 * <span lang="ja">登録したいオブジェクトです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="en">item パラメータで渡すオブジェクトです。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #addItemAt()
		 */
		public function addItem( item:* ):* {
			return _addItemAt( item, _items.length );
		}
		
		/**
		 * <span lang="ja">指定されたインデックス位置に子アイテムとして登録します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param item
		 * <span lang="ja">登録したいオブジェクトです。</span>
		 * <span lang="en"></span>
		 * @param index
		 * <span lang="ja">子を追加するインデックス位置です。既にオブジェクトが置かれているインデックス位置を指定すると、その位置にあるオブジェクトとその上に位置するすべてのオブジェクトが、子リスト内で 1 つ上の位置に移動します。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="en">item パラメータで渡すオブジェクトです。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #addItem()
		 */
		public function addItemAt( item:*, index:int ):* {
			return _addItemAt( item, index );
		}
		
		/**
		 * 指定されたインデックス位置に子アイテムとして登録します。
		 */
		private function _addItemAt( item:*, index:int ):* {
			// インデックスの範囲を超えていれば例外をスローする
			if ( index < 0 || _items.length < index ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_004 ).toString() ); }
			
			// すでに登録されていれば
			var index2:int = _getItemIndex( item );
			if ( index2 > -1 ) {
				_removeItemAt( index2 );
			}
			
			// 登録する
			_items.splice( index, 0, item );
			
			return item;
		}
		
		/**
		 * <span lang="ja">子アイテムを削除します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param item
		 * <span lang="ja">削除したいオブジェクトです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="en">item パラメータで渡すオブジェクトです。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #removeItemAt()
		 */
		public function removeItem( item:* ):* {
			var index:int = getItemIndex( item );
			
			if ( index < 0 ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_011 ).toString( item ) ); }
			
			return _removeItemAt( index );
		}
		
		/**
		 * <span lang="ja">指定されたインデックス位置にある子アイテムを削除します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param index
		 * <span lang="ja">削除したいオブジェクトのインデックス位置です。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">削除されたオブジェクトです。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #removeItem()
		 */
		public function removeItemAt( index:int ):* {
			return _removeItemAt( index );
		}
		
		/**
		 * 指定されたインデックス位置にある子アイテムを削除します。
		 */
		private function _removeItemAt( index:int ):* {
			// インデックスの範囲を超えていれば例外をスローする
			if ( index < 0 || _items.length < index ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_004 ).toString() ); }
			
			// 登録を解除する
			return _items.splice( index, 1 ) as Object;
		}
		
		/**
		 * <span lang="ja">指定されたオブジェクトが登録されているかどうかを返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param item
		 * <span lang="ja">テストする子オブジェクトです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">登録されていれば true を、それ以外では false です。</span>
		 * <span lang="en"></span>
		 */
		public function contains( item:* ):Boolean {
			for ( var i:int = 0, l:int = _items.length; i < l; i++ ) {
				if ( _items[i] == item ) { return true; }
			}
			
			return false;
		}
		
		/**
		 * <span lang="ja">指定されたインデックス位置にある子アイテムを返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param index
		 * <span lang="ja">子アイテムのインデックス位置です。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">指定されたインデックス位置にある子アイテムです。</span>
		 * <span lang="en"></span>
		 */
		public function getItemAt( index:int ):* {
			return _getItemAt( index );
		}
		
		/**
		 * 指定されたインデックス位置にある子アイテムを返します。
		 */
		private function _getItemAt( index:int ):* {
			// インデックスが範囲外であれば例外をスローする
			if ( index < 0 || numItems < index ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_004 ).toString() ); }
			
			return _items[index] as Object;
		}
		
		/**
		 * <span lang="ja">子アイテムの登録されているインデックス位置を返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param item
		 * <span lang="ja">特定するアイテムです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">特定するアイテムのインデックス位置です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #setItemIndex()
		 */
		public function getItemIndex( item:* ):int {
			return _getItemIndex( item );
		}
		
		/**
		 * 子アイテムの登録されているインデックス位置を返します。
		 */
		private function _getItemIndex( item:* ):int {
			for ( var i:int = 0, l:int = _items.length; i < l; i++ ) {
				if ( _items[i] == item ) { return i; }
			}
			
			return -1;
		}
		
		/**
		 * <span lang="ja">既存の子アイテムのインデックス位置を変更します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param item
		 * <span lang="ja">インデックス番号を変更する子アイテムです。</span>
		 * <span lang="en"></span>
		 * @param index
		 * <span lang="en">item オブジェクトの結果のインデックス番号です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #getItemIndex()
		 */
		public function setItemIndex( item:*, index:int ):void {
			var index1:int = _getItemIndex( item );
			var index2:int = index;
			
			// 位置が範囲外であれば例外をスローする
			if ( index1 < 0 ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_004 ).toString() ); }
			
			_items.splice( index1, 1 );
			_items.splice( index2, 0, item );
		}
		
		/**
		 * <span lang="ja">指定された 2 つの子オブジェクトの z 順序（重ね順）を入れ替えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @param item1
		 * <span lang="ja">先頭の子オブジェクトです。</span>
		 * <span lang="en"></span>
		 * @param item2
		 * <span lang="ja">2 番目の子オブジェクトです。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #swapItemsAt()
		 */
		public function swapItems( item1:*, item2:* ):void {
			_swapItemsAt( _getItemIndex( item1 ), _getItemIndex( item2 ) );
		}
		
		/**
		 * <span lang="ja">子リスト内の指定されたインデックス位置に該当する 2 つの子オブジェクトの z 順序（重ね順）を入れ替えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @param index1
		 * <span lang="ja">最初の子オブジェクトのインデックス位置です。</span>
		 * <span lang="en"></span>
		 * @param index2
		 * <span lang="ja">2 番目の子オブジェクトのインデックス位置です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #swapItems()
		 */
		public function swapItemsAt( index1:int, index2:int ):void {
			_swapItemsAt( index1, index2 );
		}
		
		/**
		 * 子リスト内の指定されたインデックス位置に該当する 2 つの子オブジェクトの z 順序（重ね順）を入れ替えます。
		 */
		private function _swapItemsAt( index1:int, index2:int ):void {
			// 子アイテムを取得する
			var item1:* = _getItemAt( index1 );
			var item2:* = _getItemAt( index2 );
			
			// 対象が子アイテムとして登録されていなければ例外をスローする
			if ( !item1 || !item2 ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_004 ).toString() ); }
			
			// インデックスの数値によって入れ替える
			if ( index1 < index2 ) {
				var tmpItem:* = item1;
				var tmpIndex:int = index1;
				item1 = item2;
				item2 = tmpItem;
				index1 = index2;
				index2 = tmpIndex;
			}
			
			// 子アイテムの位置を移動する
			_items.splice( index1, 1, item2 );
			_items.splice( index2, 1, item1 );
		}
		
		/**
		 * <span lang="ja">保持しているデータを破棄します。</span>
		 * <span lang="en"></span>
		 */
		public function dispose():void {
			_items = [];
		}
		
		/**
		 * <span lang="ja">UniqueList インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an UniqueList subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい UniqueList インスタンスです。</span>
		 * <span lang="en">A new UniqueList object that is identical to the original.</span>
		 */
		public function clone():UniqueList {
			var list:UniqueList = new UniqueList();
			list._items = _items.slice();
			return list;
		}
		
		/**
		 * <span lang="ja">指定されたオブジェクトの配列表現を返します。</span>
		 * <span lang="en">Returns the array representation of the specified object.</span>
		 * 
		 * @return
		 * <span lang="ja">オブジェクトの配列表現です。</span>
		 * <span lang="en">A array representation of the object.</span>
		 */
		public function toArray():Array {
			return _items.slice();
		}
	}
}
