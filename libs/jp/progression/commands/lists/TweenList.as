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
	
	/**
	 * <span lang="ja">TweenList クラスは、登録された複数のコマンドを開始タイミングをずらしながら実行させるためのコマンドリストクラスです。
	 * TweenList は、登録された対象のコマンドの delay プロパティを操作するため、設定済みの delay プロパティの値は無視されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // TweenList インスタンスを作成する
	 * var list:TweenList = new TweenList();
	 * 
	 * // コマンドを実行する
	 * list.execute();
	 * </listing>
	 */
	public class TweenList extends ParallelList {
		
		/**
		 * <span lang="ja">処理の実行遅延時間を取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #easing
		 */
		public function get duration():Number { return _duration; }
		public function set duration( value:Number ):void { _duration = value; }
		private var _duration:Number = 0;
		
		/**
		 * <span lang="ja">遅延処理に使用するイージング関数を取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #duration
		 */
		public function get easing():Function { return _easing; }
		public function set easing( value:Function ):void { _easing = value; }
		private var _easing:Function;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい TweenList インスタンスを作成します。</span>
		 * <span lang="en">Creates a new TweenList object.</span>
		 * 
		 * @param duration
		 * <span lang="ja">処理の実行遅延時間です。</span>
		 * <span lang="en"></span>
		 * @param easing
		 * <span lang="ja">遅延処理に使用するイージング関数です。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 * @param commands
		 * <span lang="ja">登録したいコマンドインスタンス、関数、数値、配列などを含む配列です。</span>
		 * <span lang="en"></span>
		 */
		public function TweenList( duration:Number, easing:Function = null, initObject:Object = null, ... commands:Array ) {
			// 引数を設定する
			_duration = duration;
			_easing = easing;
			
			// 親クラスを初期化する
			super( initObject );
			
			// コマンドリストに登録する
			super.addCommand.apply( null, commands );
		}
		
		
		
		
		
		/**
		 * @private
		 */
		override protected function executeFunction():void {
			var easing:Function = _easing || _easeNone;
			
			// 現在登録されている全てのコマンドを取得する
			while ( super.hasNextCommand() ) {
				var max:int = Math.max( 1, super.numCommands - 1 );
				var time:Number = _duration * super.position / max;
				
				var com:Command = super.nextCommand();
				com.delay = _duration - easing( _duration - time, 0, _duration, _duration );
			}
			
			// 親のメソッドを実行する
			super.executeFunction();
		}
		
		/**
		 * 重み付けのされていないイージング関数を実行します。
		 */
		private function _easeNone( t:Number, b:Number, c:Number, d:Number ):Number {
			return c * t / d + b;
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 親のメソッドを実行する
			super.dispose();
			
			_duration = 0;
			_easing = null;
		}
		
		/**
		 * <span lang="ja">TweenList インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an TweenList subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい TweenList インスタンスです。</span>
		 * <span lang="en">A new TweenList object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new TweenList( _duration, _easing, this );
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
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "duration" );
		}
	}
}
