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
	
	/**
	 * <span lang="ja">Break クラスは、実行中の処理を強制的に中断するコマンドクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // SerialList インスタンスを作成する
	 * var com:SerialList = new SerialList();
	 * 
	 * // コマンドを登録する
	 * com.addCommand(
	 * 	new Trace( "親の SerialList を実行" ),
	 * 	new SerialList( null,
	 * 		new Trace( "子の SerialList を実行" ),
	 * 		new SerialList( null,
	 * 			new Trace( "孫の SerialList を実行" ),
	 * 			// ここで処理を中断する
	 * 			new Break(),
	 * 			new Trace( "このコマンドは実行されない" )
	 * 		),
	 * 		new Trace( "子の SerialList を終了" )
	 * 	),
	 * 	new Trace( "親の SerialList を終了" )
	 * );
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * </listing>
	 */
	public class Break extends Command {
		
		/**
		 * <span lang="ja">新しい Break インスタンスを作成します。</span>
		 * <span lang="en">Creates a new Break object.</span>
		 * 
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function Break( initObject:Object = null ) {
			// 親クラスを初期化する
			super( _execute, null, initObject );
		}
		
		
		
		
		
		/**
		 * 実行されるコマンドの実装です。
		 */
		private function _execute():void {
			// 処理を強制中断する
			super.interrupt();
		}
		
		/**
		 * <span lang="ja">Break インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an Break subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい Break インスタンスです。</span>
		 * <span lang="en">A new Break object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new Break( this );
		}
	}
}
