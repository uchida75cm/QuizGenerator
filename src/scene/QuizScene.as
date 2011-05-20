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
	public class QuizScene extends BaseScene {
		
		private var question: QuestionScene;
		private var raise: RaiseScene;
		private var trues: TrueScene;
		private var falses: FalseScene;
		private var answer: AnswerScene;
		
		private var no: int;
		private var xml: XML;
		private var titleDisplay: TextField;
		
		/**
		 * 新しい IndexScene インスタンスを作成します。
		 */
		public function QuizScene( name:String = null, initObject:Object = null ) {
			// 親クラスを初期化する
			super( name, initObject );
			no = initObject.no;
			xml = initObject.xml;
			title = "quiz" + no;
			
			question = new QuestionScene( "question", {quiz: xml.child("quiz").toString() } );
			raise = new RaiseScene( "raise", {} );
			trues = new TrueScene( "trues", {} );
			falses = new FalseScene( "falses", {} );
			answer = new AnswerScene( "answer", {ans: xml.child("ans").toString() } );
			
			addScene( question );
			question.addScene( raise );
			addScene( trues );
			addScene( falses );
			addScene( answer );
			
			question.setPreview( "/index/quiz" + no );
			question.setKey( 96, "/index/quiz" + no + "/question/raise", setHitPlayer(0) );
			question.setKey( 48, "/index/quiz" + no + "/question/raise", setHitPlayer(0) );
			question.setKey( 98, "/index/quiz" + no + "/question/raise", setHitPlayer(1) );
			question.setKey( 50, "/index/quiz" + no + "/question/raise", setHitPlayer(1) );
			question.setKey( 100, "/index/quiz" + no + "/question/raise", setHitPlayer(2) );
			question.setKey( 52, "/index/quiz" + no + "/question/raise", setHitPlayer(2) );
			question.setKey( 105, "/index/quiz" + no + "/question/raise", setHitPlayer(3) );
			question.setKey( 57, "/index/quiz" + no + "/question/raise", setHitPlayer(3) );
			raise.setPreview( "/index/quiz" + no + "/question" );
			raise.setKey( 79, "/index/quiz" + no + "/trues" );
			raise.setKey( 88, "/index/quiz" + no + "/falses" );
			trues.setPreview( "/index/quiz" + no + "/question/raise" );
			trues.setNext( "/index/quiz" + no + "/answer" );
			falses.setPreview( "/index/quiz" + no + "/question/raise" );
			falses.setNext( "/index/quiz" + no + "/question" );
			answer.setPreview( "/index/quiz" + no + "/trues" );
			
			titleDisplay = new TextField();
			titleDisplay.defaultTextFormat = Utils.getTitleFormat();
			titleDisplay.autoSize = TextFieldAutoSize.LEFT;
			titleDisplay.appendText( xml.child(	"title" ).toString() );
			titleDisplay.x = IndexScene.windowWidth/2 - titleDisplay.width/2;
			titleDisplay.y = IndexScene.windowHeight/2 - titleDisplay.height/2;
			page.addChild( titleDisplay );
		}
		
		private function setHitPlayer( playerNo: int ): Function {
			var myfunc = function() {
				var myno = playerNo;
				(manager.root as IndexScene).hitPlayer = myno;
			}
			return myfunc;
		}
		
		override public function setNext( nextPath: String, synchronize: Function = null ): void {
			super.setNext( "/index/quiz" + no + "/question" );
			answer.setNext( nextPath );
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
