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
	import jp.nium.utils.ArrayUtil;
	import jp.nium.utils.ClassUtil;
	import jp.nium.utils.ObjectUtil;
	
	/**
	 * <span lang="ja">Trace クラスは、trace() メソッドを実行するコマンドクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // Trace インスタンスを作成する
	 * var com:Trace = new Trace( "この文字列を出力します" );
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * 
	 * // Trace インスタンスを作成する
	 * com = new Trace( [ "配列の", "場合も", "正しく出力されます" ] );
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * 
	 * // Trace インスタンスを作成する
	 * com = new Trace( { aaa:"オブジェクトの場合", bbb:"中身が構造的に", ccc:"出力されます" } );
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * 
	 * // Trace インスタンスを作成する
	 * com = new Trace( function():String {
	 * 	return "関数の場合は実行結果の戻り値が出力されます";
	 * } );
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * </listing>
	 */
	public class Trace extends Command {
		
		/**
		 * コピー元となる Trace インスタンスです。
		 */
		private static var _target:Trace;
		
		
		
		
		
		/**
		 * <span lang="ja">出力したい内容を取得または設定します。
		 * この値に関数を設定した場合、実行結果を出力します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get output():* { return _output; }
		public function set output( value:* ):void { _output = value; }
		private var _output:*;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい Trace インスタンスを作成します。</span>
		 * <span lang="en">Creates a new Trace object.</span>
		 * 
		 * @param outputs
		 * <span lang="ja">出力したい内容です。</span>
		 * <span lang="en"></span>
		 */
		public function Trace( ... outputs:Array ) {
			// 引数を設定する
			if ( outputs.length > 1 ) {
				_output = outputs;
			}
			else {
				_output = outputs[0];
			}
			
			// コピー元が設定されていれば
			if ( _target ) {
				_output = _target._output;
			}
			
			// 親クラスを初期化する
			super( _executeFunction, null, _target );
			
			// 破棄する
			_target = null;
		}
		
		
		
		
		
		/**
		 * 実行されるコマンドの実装です。
		 */
		private function _executeFunction():void {
			var outputs:Array;;
			
			// 配列に変換する
			if ( _output is Array ) {
				outputs = _output.slice();
			}
			else {
				outputs = [ _output ];
			}
			
			// 内容を String に変換する
			for ( var i:int = 0, l:int = outputs.length; i < l; i++ ) {
				var output:* = outputs[i];
				switch ( true ) {
					case output is Function								: { outputs[i] = String( outputs[i]() ); break; }
					case output is Array								: { outputs[i] = ArrayUtil.toString( outputs[i] ); break; }
					case ClassUtil.getClassName( output ) == "Object"	: { outputs[i] = ObjectUtil.toString( outputs[i] ); break; }
					default												: { outputs[i] = String( outputs[i] ); }
				}
			}
			
			// 出力する
			trace( outputs.join( " " ) );
			
			// 処理を終了する
			super.executeComplete();
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 親のメソッドを実行する
			super.dispose();
			
			_output = null;
		}
		
		/**
		 * <span lang="ja">Trace インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an Trace subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい Trace インスタンスです。</span>
		 * <span lang="en">A new Trace object that is identical to the original.</span>
		 */
		override public function clone():Command {
			_target = this;
			return new Trace();
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
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "output" );
		}
	}
}
