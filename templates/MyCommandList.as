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
	public class MyCommandList extends SerialList {
		
		/**
		 * 新しい MyCommandList インスタンスを作成します。
		 */
		public function MyCommandList( initObject:Object = null ) {
			// 親クラスを初期化します。
			super( initObject );
			
			// 実行したいコマンド群を登録します。
			addCommand(
			);
		}
		
		/**
		 * インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。
		 */
		override public function clone():Command {
			return new MyCommandList( this );
		}
	}
}
