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
	public class RaiseScene extends BaseScene {
		
		private var namePanel: NamePanel;
		private var textFormats: Array;
		
		/**
		 * 新しい IndexScene インスタンスを作成します。
		 */
		public function RaiseScene( name:String = null, initObject:Object = null ) {
			// 親クラスを初期化する
			super( name, initObject );
			
			textFormats = new Array(
							Utils.getOrangeFormat(),
							Utils.getBlueFormat(),
							Utils.getGreenFormat(),
							Utils.getYellowFormat()
							);
							
			
			namePanel = new NamePanel();
			namePanel.x = IndexScene.windowWidth/2;
			namePanel.y = IndexScene.windowHeight;
			page.addChild( namePanel );
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
			var hitPlayer: int = (manager.root as IndexScene).hitPlayer;
			namePanel.nameArea.defaultTextFormat = textFormats[hitPlayer];
			namePanel.nameArea.text = (manager.root as IndexScene).playerList[hitPlayer];
			super.atSceneInit();
			addCommand(
				new DoTweener( namePanel, {y: IndexScene.windowHeight-namePanel.height, time: 0.2} )
				);
			//Sounds.button.play();
		}
		
		/**
		 * シーンオブジェクト自身が出発地だった場合に、移動を開始した瞬間に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneGoto():void {
			addCommand(
				new DoTweener( namePanel, {y: IndexScene.windowHeight, time: 0.2} )
				);
			super.atSceneGoto();
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
