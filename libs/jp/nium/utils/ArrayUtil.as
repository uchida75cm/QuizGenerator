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
package jp.nium.utils {
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	
	/**
	 * <span lang="ja">ArrayUtil クラスは、配列操作のためのユーティリティクラスです。</span>
	 * <span lang="en">The ArrayUtil class is an utility class for array operation.</span>
	 */
	public final class ArrayUtil {
		
		/**
		 * @private
		 */
		public function ArrayUtil() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
		
		
		
		
		
		/**
		 * <span lang="ja"></span>
		 * <span lang="en"></span>
		 * 
		 * @param array
		 * <span lang="ja"></span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja"></span>
		 * <span lang="en"></span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function intersect( array1:Array, array2:Array ):Array {
			var results:Array = [];
			
			for ( var i:int = 0, l:int = array1.length; i < l; i++ ) {
				var item1:* = array1[i];
				
				for ( var ii:int = 0, ll:int = array2.length; ii < ll; ii++ ) {
					var item2:* = array2[ii];
					
					if ( item1 == item2 ) {
						results.push( item1 );
						break;
					}
				}
			}
			
			return results;
		}
		
		/**
		 * <span lang="ja"></span>
		 * <span lang="en"></span>
		 * 
		 * @param array
		 * <span lang="ja"></span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja"></span>
		 * <span lang="en"></span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function subtract( array1:Array, array2:Array ):Array {
			var results:Array = [];
			
			for ( var i:int = 0, l:int = array1.length; i < l; i++ ) {
				var item1:* = array1[i];
				var exist:Boolean = false;
				
				for ( var ii:int = 0, ll:int = array2.length; ii < ll; ii++ ) {
					var item2:* = array2[ii];
					
					if ( item1 == item2 ) {
						exist = true;
						break;
					}
				}
				
				if ( exist ) { continue; }
				
				results.push( item1 );
			}
			
			return results;
		}
		
		/**
		 * <span lang="ja">対象の配列に含まれる undefined や null などを破棄して、圧縮された配列を作成します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param array
		 * <span lang="ja">圧縮したい配列です。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">圧縮後の配列です。</span>
		 * <span lang="en"></span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function compress( array:Array ):Array {
			var result:Array = [];
			
			for ( var i:int = 0, l:int = array.length; i < l; i++ ) {
				var item:* = array[i];
				
				switch ( item ) {
					case undefined	:
					case null		:
					case ""			: { continue; }
				}
				
				result.push( item );
			}
			
			return result;
		}
		
		/**
		 * <span lang="ja">指定された配列に含まれるアイテムのインデックス値を返します。</span>
		 * <span lang="en">Returns the index value of the item included in specified array.</span>
		 * 
		 * @param array
		 * <span lang="ja">検索対象の配列です。</span>
		 * <span lang="en">The array to search the object.</span>
		 * @param item
		 * <span lang="ja">検索されるアイテムです。</span>
		 * <span lang="en">The item to be searched.</span>
		 * @return
		 * <span lang="ja">指定されたアイテムのインデックス値、または -1 （指定されたアイテムが見つからない場合）です。</span>
		 * <span lang="en">The index value of the specified item or -1 (In case, the specified item could not find).</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function getItemIndex( array:Array, item:* ):int {
			for ( var i:int = 0, l:int = array.length; i < l; i++ ) {
				if ( array[i] == item ) { return i; }
			}
			
			return -1;
		}
		
		/**
		 * <span lang="ja">配列が保持している全てのアイテムの型が指定されたものと合致するかどうかを返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param array
		 * <span lang="ja">対象の配列です。</span>
		 * <span lang="en"></span>
		 * @param cls
		 * <span lang="ja">比較するクラスです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">全てのアイテムが合致すれば true を、そうでなければ false を返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function validateItems( array:Array, cls:Class ):Boolean {
			for ( var i:int = 0, l:int = array.length; i < l; i++ ) {
				if ( array[i] is cls ) { continue; }
				return false;
			}
			
			return true;
		}
		
		/**
		 * <span lang="ja">指定された配列の内容が同一のものであるかどうかを比較し、結果を返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param array1
		 * <span lang="ja">先頭の配列です。</span>
		 * <span lang="en">The first array object.</span>
		 * @param array2
		 * <span lang="ja">2 番目の配列です。</span>
		 * <span lang="en">The second array object.</span>
		 * @return
		 * <span lang="ja">同一であれば true を、そうでなければ false を返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function equals( array1:Array, array2:Array ):Boolean {
			if ( array1.length != array2.length ) { return false; }
			
			for ( var i:int = 0, l:int = array1.length; i < l; i++ ) {
				if ( array1[i] !== array2[i] ) { return false; }
			}
			
			return true;
		}
		
		/**
		 * <span lang="ja">新しい配列に再配置します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param args
		 * <span lang="ja">再配置したい配列です。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">再配置後の配列です。</span>
		 * <span lang="en"></span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function toArray( args:Array ):Array {
			var list:Array = [];
			
			for ( var i:int = 0, l:int = args.length; i < l; i++ ) {
				list.push( args[i] );
			}
			
			return list;
		}
		
		/**
		 * <span lang="ja">指定された配列のストリング表現を返します。</span>
		 * <span lang="en">Returns the string expression of the specified array.</span>
		 * 
		 * @param array
		 * <span lang="ja">対象の配列です。</span>
		 * <span lang="en">The array to process.</span>
		 * @return
		 * <span lang="ja">配列のストリング表現です。</span>
		 * <span lang="en">The string expression of the array.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function toString( array:Array ):String {
			var str:String = "[";
			
			for ( var i:int = 0, l:int = array.length; i < l; i++ ) {
				var item:* = array[i];
				
				switch ( true ) {
					case item is Array		: { str += ArrayUtil.toString( item ); break; }
					case item is Boolean	:
					case item is Number		:
					case item is int		:
					case item is uint		: { str += item; break; }
					case item is String		: { str += '"' + item.replace( new RegExp( '"', "gi" ), '\\"' ) + '"'; break; }
					default					: { str += ObjectUtil.toString( item ); }
				}
				
				str += ", ";
			}
			
			// 1 度でもループを処理していれば最後の , を削除する
			if ( i > 0 ) {
				str = str.slice( 0, -2 );
			}
			
			str += "]";
			
			return str;
		}
	}
}
