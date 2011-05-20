package scene {
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
	import jp.progression.executors.*;
	import jp.progression.scenes.*;
	
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.net.URLLoader;
	
	import fl.controls.TextInput;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import flash.media.SoundChannel;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class IndexScene extends BaseScene {
		
		//シーン
		private var openning: OpenningScene;
		private var ending: EndingScene;
		private var quizList: Array;
		
		//ビュー
		private var commonParts: Sprite;
		public var myContainer: Sprite;
		private var entryPanel: EntryPanel;
		
		//xml読み込み
		private var request: URLRequest;
		private var urlLoader: URLLoader;
		private var xml: XML;
		
		public var playerList: Array;
		public var hitPlayer: int;
		public static var windowWidth = 1024;
		public static var windowHeight = 768;
		
		/**
		 * 新しい IndexScene インスタンスを作成します。
		 */
		public function IndexScene() {
			// シーンタイトルを設定します。
			title = "index";
			playerList = new Array("", "", "", "");
			hitPlayer = 0;
			
			//コンテナを初期化
			myContainer = new Sprite();
			container.addChild( myContainer );
			commonParts = new Sprite();
			container.addChild( commonParts );
			
			//共通パーツを設定
			var header: Header = new Header();
			var footer: Footer = new Footer();
			footer.y = 768 - footer.height;
			commonParts.addChild( header );
			commonParts.addChild( footer );
			commonParts.width = windowWidth;
			commonParts.height = windowHeight;
			
			//エントリーページのパーツ
			entryPanel = new EntryPanel();
			entryPanel.y = windowHeight/2 - entryPanel.height/2;
			entryPanel.x = windowWidth/2 - entryPanel.width/2;
			for( var i: int = 0; i < 4; i++ ) {
				entryPanel["name" + i].text = playerList[i];
			}
			
			//xmlを読み込み開始
			request = new URLRequest( "./quiz.xml" );
			urlLoader = new URLLoader( request );
			urlLoader.addEventListener( Event.COMPLETE, init );
		}
		
		private function init( e: Event ) {
			xml = new XML( e.target.data );
			quizList = new Array();
			
			//シーンの生成
			openning = new OpenningScene( "openning", {} );
			addScene( openning );
			var i: int = 0;
			for each( var item: XML in xml.children() ) {
				var quiz = new QuizScene( "quiz"+i, {xml: item, no: i});
				quizList[i] = quiz;
				addScene( quiz );
				i++;
			}
			ending = new EndingScene( "ending", {} );
			addScene( ending );
			
			//遷移先の指定
			//(各quizシーンについては,setNextのoverrideにて
			//クイズ内末尾のシーンに次シーンを割り当て)
			setNext( "/index/openning", setPlayerName );
			openning.setPreview( "/index/" );
			openning.setNext( "/index/quiz0" );
			for( var j: int = 0; j < quizList.length; j++ ) {
				if( j == 0 ) {
					quizList[j].setPreview( "/index/openning" );
					quizList[j].setNext( "/index/quiz" + (j+1) );
				} else if( j == quizList.length-1 ) {
					quizList[j].setPreview( "/index/quiz" + (j-1) + "/answer" );
					quizList[j].setNext( "/index/ending" );
				} else {
					quizList[j].setPreview( "/index/quiz" + (j-1) + "/answer" );
					quizList[j].setNext( "/index/quiz" + (j+1) );
				}
			}
			ending.setPreview( "/index/quiz" + (quizList.length-1) + "/answer" );
		}
		
		private function setPlayerName() {
			for( var i: int = 0; i < 4; i++ ) {
				playerList[i] = entryPanel["name" + i].text;
			}
		}
		
		
		/**
		 * シーン移動時に目的地がシーンオブジェクト自身もしくは子階層だった場合に、階層が変更された直後に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneLoad():void {
			addCommand(
			);
		}
		
		/**
		 * シーンオブジェクト自身が目的地だった場合に、到達した瞬間に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneInit():void {
			super.atSceneInit();
			addCommand(
				new AddChild( page, entryPanel )
			);
		}
		
		/**
		 * シーンオブジェクト自身が出発地だった場合に、移動を開始した瞬間に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneGoto():void {
			super.atSceneGoto();
			addCommand(
			);
		}
		
		/**
		 * シーン移動時に目的地がシーンオブジェクト自身もしくは親階層だった場合に、階層が変更される直前に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneUnload():void {
			addCommand(
			);
		}
	}
}
