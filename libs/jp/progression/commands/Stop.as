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
	import jp.nium.core.debug.Logger;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.commands.lists.IRepeatable;
	import jp.progression.core.L10N.L10NCommandMsg;
	
	/**
	 * <span lang="ja">Stop クラスは、親のループ処理を停止させるコマンドクラスです。
	 * このコマンドを使用するためには LoopList コマンド、または ShuttleList コマンドの子として実行させる必要があります。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // LoopList インスタンスを作成する
	 * var list:LoopList = new LoopList();
	 * 
	 * // コマンドを登録する
	 * list.addCommand(
	 * 	new Trace( "実行します" ),
	 * 	new Wait( 1 ),
	 * 	// このループの 5 周のこの位置で停止させる
	 * 	new Stop( 5 )
	 * );
	 * 
	 * // コマンドを実行する
	 * list.execute();
	 * </listing>
	 */
	public class Stop extends Command {
		
		/**
		 * <span lang="ja">親のループ処理を停止させる条件となるループ処理回数を取得または設定します。
		 * この値が 0 に設定されている場合には、無条件にループ処理を停止させます。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #count
		 * @see #stop()
		 */
		public function get stopCount():int { return _stopCount; }
		public function set stopCount( value:int ):void { _stopCount = value; }
		private var _stopCount:int = 0;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい Stop インスタンスを作成します。</span>
		 * <span lang="en">Creates a new Stop object.</span>
		 * 
		 * @param count
		 * <span lang="ja">親のループ処理を停止させる条件となるループ回数です。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function Stop( stopCount:int = 0, initObject:Object = null ) {
			// 引数を設定する
			_stopCount = stopCount;
			
			// 親クラスを初期化する
			super( _execute, null, initObject );
		}
		
		
		
		
		
		/**
		 * 実行されるコマンドの実装です。
		 */
		private function _execute():void {
			var repeatable:IRepeatable = super.parent as IRepeatable;
			
			// 対象が IRepeatable インターフェイスを実装していなければ例外をスローする
			if ( !repeatable ) { super.throwError( this, new Error( Logger.getLog( L10NCommandMsg.getInstance().ERROR_000 ).toString() ) ); }
			
			// 条件に合致しなければ終了する
			if ( _stopCount > 0 && repeatable.count < _stopCount ) {
				super.executeComplete();
				return;
			}
			
			// 親のループ処理を停止する
			repeatable.stop();
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 親のメソッドを実行する
			super.dispose();
			
			_stopCount = 0;
		}
		
		/**
		 * <span lang="ja">Stop インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an Stop subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい Stop インスタンスです。</span>
		 * <span lang="en">A new Stop object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new Stop( _stopCount, this );
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
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "stopCount" );
		}
	}
}
