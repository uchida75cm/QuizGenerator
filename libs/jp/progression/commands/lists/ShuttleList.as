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
package jp.progression.commands.lists {
	import jp.nium.utils.ObjectUtil;
	import jp.progression.commands.Command;
	import jp.progression.events.ExecuteEvent;
	
	/**
	 * <span lang="ja">ShuttleList クラスは、登録された複数のコマンドを 1 つづつ順番に実行する処理を、指定された回数往復しながら実行していくコマンドリストクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // ShuttleList インスタンスを作成する
	 * var list:ShuttleList = new ShuttleList();
	 * 
	 * // コマンドを実行する
	 * list.execute();
	 * </listing>
	 */
	public class ShuttleList extends SerialList implements IRepeatable {
		
		/**
		 * <span lang="ja">実行したいループ処理数を取得または設定します。
		 * この値が 0 に設定されている場合には、stop() メソッドで終了させるまで処理し続けます。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #count
		 * @see #stop()
		 */
		public function get repeatCount():int { return _repeatCount; }
		public function set repeatCount( value:int ):void { _repeatCount = value; }
		private var _repeatCount:int = 0;
		
		/**
		 * <span lang="ja">現在のループ処理回数を取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #repeatCount
		 * @see #stop()
		 */
		public function get count():int { return _count; }
		private var _count:int = 0;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい ShuttleList インスタンスを作成します。</span>
		 * <span lang="en">Creates a new ShuttleList object.</span>
		 * 
		 * @param repeatCount
		 * <span lang="ja">実行したいループ処理数です。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 * @param commands
		 * <span lang="ja">登録したいコマンドインスタンス、関数、数値、配列などを含む配列です。</span>
		 * <span lang="en"></span>
		 */
		public function ShuttleList( repeatCount:int = 0, initObject:Object = null, ... commands:Array ) {
			// 引数を設定する
			_repeatCount = repeatCount;
			
			// 親クラスを初期化する
			super( initObject );
			
			// コマンドリストに登録する
			super.addCommand.apply( null, commands );
			
			// イベントリスナーを登録する
			super.addEventListener( ExecuteEvent.EXECUTE_START, _executeStart, false, int.MAX_VALUE, true );
		}
		
		
		
		
		
		/**
		 * @private
		 */
		override protected function executeFunction():void {
			// 指定回数実行していれば
			if ( _repeatCount && position == super.numCommands && _count == _repeatCount - 1 ) {
				// カウントアップする
				_count++;
				
				// 処理を終了する
				super.executeComplete();
				return;
			}
			
			// 次が存在しなければ
			if ( !super.hasNextCommand() ) {
				// カウントアップする
				_count++;
				
				// 親のメソッドを実行する
				super.reset();
				
				// 現在のコマンドを逆順で取得する
				var coms:Array = super.commands.reverse();
				
				// コマンドを入れ替える
				super.clearCommand( true );
				super.addCommand.apply( null, coms );
			}
			
			// 親のメソッドを実行する
			super.executeFunction();
		}
		
		/**
		 * <span lang="ja">実行中のループ処理を停止させます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #count
		 * @see #repeatCount
		 */
		public function stop():void {
			// 処理を終了する
			super.executeComplete();
		}
		
		/**
		 * <span lang="ja">コマンドの処理位置を最初に戻します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #count
		 */
		override protected function reset():void {
			_count = 0;
			
			super.reset();
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 親のメソッドを実行する
			super.dispose();
			
			_repeatCount = 0;
		}
		
		/**
		 * <span lang="ja">ShuttleList インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an ShuttleList subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい ShuttleList インスタンスです。</span>
		 * <span lang="en">A new ShuttleList object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new ShuttleList( _repeatCount, this );
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
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "repeatCount", "count" );
		}
		
		
		
		
		
		/**
		 * 
		 */
		private function _executeStart( e:ExecuteEvent ):void {
			// カウントを初期化する
			_count = 0;
		}
	}
}
