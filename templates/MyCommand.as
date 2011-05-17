package {
	import jp.progression.casts.*;
	import jp.progression.commands.display.*;
	import jp.progression.commands.lists.*;
	import jp.progression.commands.managers.*;
	import jp.progression.commands.media.*;
	import jp.progression.commands.net.*;
	import jp.progression.commands.tweens.*;
	import jp.progression.commands.*;
	import jp.progression.data.*;
	import jp.progression.events.*;
	import jp.progression.scenes.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MyCommand extends Command {
		
		/**
		 * 新しい MyCommand インスタンスを作成します。
		 */
		public function MyCommand( initObject:Object = null ) {
			// 親クラスを初期化します。
			super( _execute, _interrupt, initObject );
		}
		
		/**
		 * 実行されるコマンドの実装です。
		 */
		private function _execute():void {
			// 
			executeComplete();
		}
		
		/**
		 * 中断されるコマンドの実装です。
		 */
		private function _interrupt():void {
		}
		
		/**
		 * インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。
		 */
		override public function clone():Command {
			return new MyCommand( this );
		}
	}
}
