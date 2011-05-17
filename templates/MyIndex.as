package {
	import jp.progression.casts.*;
	import jp.progression.commands.display.*;
	import jp.progression.commands.lists.*;
	import jp.progression.commands.managers.*;
	import jp.progression.commands.media.*;
	import jp.progression.commands.net.*;
	import jp.progression.commands.tweens.*;
	import jp.progression.commands.*;
	import jp.progression.config.*;
	import jp.progression.data.*;
	import jp.progression.debug.*;
	import jp.progression.events.*;
	import jp.progression.scenes.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MyIndex extends CastDocument {
		
		/**
		 * 新しい MyIndex インスタンスを作成します。
		 */
		public function MyIndex() {
			// 自動的に作成される Progression インスタンスの初期設定を行います。
			// 生成されたインスタンスにアクセスする場合には manager プロパティを参照してください。
			super( "index", null, new BasicAppConfig() );
		}
		
		/**
		 * SWF ファイルの読み込みが完了し、stage 及び loaderInfo にアクセス可能になった場合に送出されます。
		 */
		override protected function atReady():void {
			// 開発者用に Progression の動作状況を出力します。
			Debugger.addTarget( manager );
			
			// 外部同期機能を有効化します。
			//manager.sync = true;
			
			// 最初のシーンに移動します。
			manager.goto( manager.syncedSceneId );
		}
	}
}
