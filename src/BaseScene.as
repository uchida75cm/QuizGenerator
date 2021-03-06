﻿package {
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
	import jp.progression.loader.*;
	import jp.progression.*;
	import jp.progression.scenes.*;
	
	import flash.events.*;
	import flash.display.Sprite;
	import scene.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BaseScene extends SceneObject {
		
		private var nextCommand: Command;
		private var nextFunc: Function;
		private var previewCommand: Command;
		private var previewFunc: Function;
		private var keyCodes: Object = new Object();
		private var keyFuncs: Object = new Object();
		protected var page: Sprite = new Sprite();
		
		/**
		 * 新しい MySceneObject インスタンスを作成します。
		 */
		public function BaseScene( name:String = null, initObject:Object = null ) {
			// 親クラスを初期化する
			super( name, initObject );
		}
		
		public function setNext( nextPath: String, synchronize: Function = null ): void {
			nextCommand = new Goto( new SceneId( nextPath ) );
			nextFunc = synchronize;
		}
		
		public function setPreview( previewPath: String, synchronize: Function = null ): void {
			previewCommand = new Goto( new SceneId( previewPath ) );
			previewFunc = synchronize;
		}
		
		public function setKey( keyCode: int, locationPath: String, synchronize: Function = null ): void {
			keyCodes[keyCode] = new Goto( new SceneId( locationPath ) );
			keyFuncs[keyCode] = synchronize;
		}
		
		protected function keyDownHandler( event: KeyboardEvent ):void {
			if( event.keyCode == 39 && nextCommand != null ) {
				if( nextFunc != null ) {
					nextFunc();
				}
				nextCommand.execute();
			} else
			if( event.keyCode == 37 && previewCommand != null ) {
				if( previewFunc != null ) {
					previewFunc();
				}
				previewCommand.execute();
			} else
			if( event.keyCode == 67 ) {
				new Goto( new SceneId( "/index/" ) ).execute();
			} else
			if( keyCodes.hasOwnProperty( event.keyCode ) ) {
				if( keyFuncs[event.keyCode] != null ) {
					keyFuncs[event.keyCode]();
				}
				keyCodes[event.keyCode].execute();
			}
		}
		
		/**
		 * シーン移動時に目的地がシーンオブジェクト自身もしくは子階層だった場合に、階層が変更された直後に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneLoad():void {
		}
		
		/**
		 * シーンオブジェクト自身が目的地だった場合に、到達した瞬間に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneInit():void {
			stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler );
			addCommand( 
				new AddChild( ( manager.root as IndexScene ).myContainer, page )
				);
		}
		
		/**
		 * シーンオブジェクト自身が出発地だった場合に、移動を開始した瞬間に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneGoto():void {
			stage.removeEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler );
			addCommand(
				new RemoveChild( ( manager.root as IndexScene ).myContainer, page )
				);
		}
		
		/**
		 * シーン移動時に目的地がシーンオブジェクト自身もしくは親階層だった場合に、階層が変更される直前に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneUnload():void {
		}
	}
}
