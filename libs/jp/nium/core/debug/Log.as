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
package jp.nium.core.debug {
	
	/**
	 * @private
	 */
	public final class Log {
		
		/**
		 * <span lang="ja">インスタンスを表すユニークな識別子を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get id():String { return _id; }
		private var _id:String;
		
		/**
		 * <span lang="ja">ログ内容を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get message():String { return _message; }
		private var _message:String;
		
		
		
		
		/**
		 * <span lang="ja">新しい Log インスタンスを作成します。</span>
		 * <span lang="en">Creates a new Log object.</span>
		 * 
		 * @param id
		 * <span lang="ja">ログの識別子です。</span>
		 * <span lang="en"></span>
		 * @param message
		 * <span lang="ja">ログ内容です。</span>
		 * <span lang="en"></span>
		 */
		public function Log( id:String, message:String ) {
			// 引数を設定する
			_id = id;
			_message = message;
		}
		
		
		
		
		
		/**
		 * <span lang="ja">指定されたオブジェクトのストリング表現を返します。</span>
		 * <span lang="en">Returns the string representation of the specified object.</span>
		 * 
		 * @param replaces
		 * <span lang="ja">特定のコードを置換する文字列です。</span>
		 * <span lang="en">The string to replace the perticular code.</span>
		 * @return
		 * <span lang="ja">オブジェクトのストリング表現です。</span>
		 * <span lang="en">A string representation of the object.</span>
		 */
		public function toString( ... replaces:Array ):String {
			var message:String = _message;
			
			// 特定のコードを置換する
			for ( var i:int = 0, l:int = replaces.length; i < l; i++ ) {
				message = message.replace( new RegExp( "%" + i, "g" ), replaces[i] );
			}
			
			return message;
		}
	}
}
