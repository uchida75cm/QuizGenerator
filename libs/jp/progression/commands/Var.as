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
package jp.progression.commands {
	import jp.nium.utils.ObjectUtil;
	
	/**
	 * <span lang="ja">Var クラスは、指定されたタイミングで変数を設定するコマンドクラスです。
	 * 設定された変数は Func インスタンスの getVar() メソッドで取得することができます。
	 * 特に for 文使用時のインクリメントされる変数値などを、SerialList 内などの非同期処理中に使用した場合などに有効です。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // SerialList を作成する
	 * var list:SerialList = new SerialList();
	 * 
	 * // この文字列を一文字づつ時間差で出力する
	 * var words:Array = "出力される文字列".split( "" );
	 * 
	 * var l:int = words.length;
	 * for ( var i:int = 0; i &lt; l; i++ ) {
	 * 	// SerialList に登録する
	 *	list.addCommand(
	 * 		// 遅延を発生させる
	 *		new Wait( 1 ),
	 * 		
	 * 		// コマンド作成時に変数を設定しておくことで、正しく i の値が渡される
	 * 		// 渡された値はコマンドが実行されたタイミングで、変数値としてセットされる
	 *		new Var( "i", i ),
	 * 		
	 * 		// セットされた変数値から値を取得する
	 *		new Func( function():void {
	 *			trace( words[ this.getVar( "i" ) ] );
	 *		} )
	 *	);
	 * }
	 * 
	 * // コマンドを実行する
	 * list.execute();
	 * </listing>
	 */
	public class Var extends Command {
		
		/**
		 * <span lang="ja">値を格納したい変数名を取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public function get varName():String { return _varName; }
		public function set varName( value:String ):void { _varName = value; }
		private var _varName:String;
		
		/**
		 * <span lang="ja">格納したい値を取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public function get data():* { return _data; }
		public function set data( value:* ):void { _data = value; }
		private var _data:*;
		
		
		
		
		/**
		 * <span lang="ja">新しい Var インスタンスを作成します。</span>
		 * <span lang="en">Creates a new Var object.</span>
		 * 
		 * @param varName
		 * <span lang="ja">値を格納したい変数名です。</span>
		 * <span lang="en"></span>
		 * @param data
		 * <span lang="ja">格納したい値です。</span>
		 * <span lang="en"></span>
		 */
		public function Var( varName:String, data:* ) {
			// 引数を設定する
			_varName = varName;
			_data = data;
			
			// 親クラスを初期化する
			super( _executeFunction, null );
		}
		
		
		
		
		
		/**
		 * 実行されるコマンドの実装です。
		 */
		private function _executeFunction():void {
			// 値を設定する
			Func._variables[_varName] = _data;
			
			// 終了する
			super.executeComplete();
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 親のメソッドを実行する
			super.dispose();
			
			_varName = null;
			_data = null;
		}
		
		/**
		 * <span lang="ja">Var インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an Var subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい Var インスタンスです。</span>
		 * <span lang="en">A new Var object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new Var( _varName, _data );
		}
		
		/**
		 * <span lang="ja">指定されたオブジェクトのストリング表現を返します。</span>
		 * <span lang="en">Returns the string representation of the specified object.</span>
		 * 
		 * @return
		 * <span lang="ja">オブジェクトのストリング表現です。</span>
		 * <span lang="en">A string representation of the object.</span>
		 */
		override public function toString():String {
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "varName", "data" );
		}
	}
}
