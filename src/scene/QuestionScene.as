﻿package scene {
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
	public class QuestionScene extends BaseScene {
		
		public var req: URLRequest;
		public var ldr: Loader;
		private var quizImage: Sprite;
		private var soundChannel: SoundChannel;
		
		/**
		 * 新しい IndexScene インスタンスを作成します。
		 */
		public function QuestionScene( name:String = null, initObject:Object = null ) {
			// 親クラスを初期化する
			super( name, initObject );
			
			quizImage = new Sprite();
			
			req = new URLRequest( initObject.quiz );
			ldr = new Loader();
			ldr.contentLoaderInfo.addEventListener( Event.COMPLETE, loadingQuiz );
			ldr.load( req );
		}
		
		private function loadingQuiz( event: Event ): void {
			quizImage.addChild( ldr );
		}
		
		/**
		 * シーン移動時に目的地がシーンオブジェクト自身もしくは子階層だった場合に、階層が変更された直後に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneLoad():void {
			addCommand(
				new AddChild( (manager.root as IndexScene).myContainer, quizImage )
			);
		}
		
		/**
		 * シーンオブジェクト自身が目的地だった場合に、到達した瞬間に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneInit():void {
			super.atSceneInit();
			//Sounds.question.play();
			//soundChannel = Sounds.thinking.play();
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
			//soundChannel.stop();
		}
		
		/**
		 * シーン移動時に目的地がシーンオブジェクト自身もしくは親階層だった場合に、階層が変更される直前に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneUnload():void {
			addCommand(
				new RemoveChild( (manager.root as IndexScene).myContainer, quizImage )
			);
		}
	}
}
