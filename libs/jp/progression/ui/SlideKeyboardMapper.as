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
package jp.progression.ui {
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import jp.progression.Progression;
	import jp.progression.scenes.SceneObject;
	
	/**
	 * <span lang="ja">実行中のブラウザの標準的なキーボードショートカットに対応するように、キーボードイベントをマッピングします。</span>
	 * <div lang="ja" class="appendix">
	 * <br />
	 * <strong>キーボード対応表</strong>
	 * <table class="innertable">
	 * 	<tr>
	 * 		<th>キー</th>
	 * 		<th>説明</th>
	 * 	</tr>
	 * 	<tr>
	 * 		<td>上向き矢印キー</td>
	 * 		<td rowspan="2">前のシーンに移動する</td>
	 * 	</tr>
	 * 	<tr>
	 * 		<td>左向き矢印キー</td>
	 * 	</tr>
	 * 	<tr>
	 * 		<td>下向き矢印キー</td>
	 * 		<td rowspan="2">次のシーンに移動する</td>
	 * 	</tr>
	 * 	<tr>
	 * 		<td>右向き矢印キー</td>
	 * 	</tr>
	 * 	<tr>
	 * 		<td>F11 キー</td>
	 * 		<td>フルスクリーンで表示する</td>
	 * 	</tr>
	 * 	<tr>
	 * 		<td>テンキー</td>
	 * 		<td>番号入力で指定されたスライドに移動する</td>
	 * 	</tr>
	 * </table>
	 * </div>
	 * 
	 * <span lang="en"></span>
	 * <div lang="en" class="appendix">
	 * <br />
	 * <strong>Keyboard inputs table</strong>
	 * <table class="innertable">
	 * 	<tr>
	 * 		<th>Key</th>
	 * 		<th>Description</th>
	 * 	</tr>
	 * 	<tr>
	 * 		<td>Up Arrow key</td>
	 * 		<td rowspan="2">undefined</td>
	 * 	</tr>
	 * 	<tr>
	 * 		<td>Left Arrow key</td>
	 * 	</tr>
	 * 	<tr>
	 * 		<td>Down Arrow key</td>
	 * 		<td rowspan="2">undefined</td>
	 * 	</tr>
	 * 	<tr>
	 * 		<td>Right Arrow key</td>
	 * 	</tr>
	 * 	<tr>
	 * 		<td>F11 key</td>
	 * 		<td>undefined</td>
	 * 	</tr>
	 * 	<tr>
	 * 		<td>Numeric key</td>
	 * 		<td>undefined</td>
	 * 	</tr>
	 * </table>
	 * </div>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public class SlideKeyboardMapper implements IKeyboardMapper {
		
		/**
		 * <span lang="ja">関連付けられている Progression インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get target():Progression { return _target; }
		private var _target:Progression;
		
		/**
		 * 
		 */
		private var _inputs:Array;
		
		/**
		 * Timer インスタンスを取得します。
		 */
		private var _timer:Timer;
		
		/**
		 * Stage インスタンスを取得します。
		 */
		private var _stage:Stage;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい SlideKeyboardMapper インスタンスを作成します。</span>
		 * <span lang="en">Creates a new SlideKeyboardMapper object.</span>
		 * 
		 * @param target
		 * <span lang="ja">関連付けたい Progression インスタンスです。</span>
		 * <span lang="en"></span>
		 */
		public function SlideKeyboardMapper( target:Progression ) {
			// 引数を設定する
			_target = target;
			_stage = _target.stage;
			
			// 初期化する
			_inputs = [];
			
			// Timer を作成する
			_timer = new Timer( 500, 1 );
			_timer.addEventListener( TimerEvent.TIMER_COMPLETE, _timerComplete );
			
			// イベントリスナーを登録する
			_stage.addEventListener( KeyboardEvent.KEY_DOWN, _keyDown );
		}
		
		
		
		
		
		/**
		 * ユーザーがキーを離したときに送出されます。
		 */
		private function _keyDown( e:KeyboardEvent ):void {
			// フォーカスが TextField に存在している場合は終了する
			if ( _stage.focus is TextField ) { return; }
			
			// 入力されたキーによって処理を振り分ける
			switch ( e.keyCode ) {
				case Keyboard.NUMPAD_0	:
				case Keyboard.NUMPAD_1	:
				case Keyboard.NUMPAD_2	:
				case Keyboard.NUMPAD_3	:
				case Keyboard.NUMPAD_4	:
				case Keyboard.NUMPAD_5	:
				case Keyboard.NUMPAD_6	:
				case Keyboard.NUMPAD_7	:
				case Keyboard.NUMPAD_8	:
				case Keyboard.NUMPAD_9	: {
					_inputs.push( e.keyCode - Keyboard.NUMPAD_0 );
					
					_timer.reset();
					_timer.start();
					return;
				}
				case Keyboard.UP		:
				case Keyboard.DOWN		:
				case Keyboard.LEFT		:
				case Keyboard.RIGHT		: {
					if ( e.shiftKey || e.ctrlKey ) { break; }
					
					// 現在のシーンを取得する
					var current:SceneObject = _target.current;
					
					switch ( e.keyCode ) {
						case Keyboard.UP	:
						case Keyboard.LEFT	: {
							if ( current.previous ) {
								_target.goto( current.previous.sceneId );
							}
							else if ( current.parent ) {
								_target.goto( current.parent.getSceneAt( current.parent.numScenes - 1 ).sceneId );
							}
							break;
						}
						case Keyboard.DOWN	:
						case Keyboard.RIGHT	: {
							if ( current.next ) {
								_target.goto( current.next.sceneId );
							}
							else if ( current.parent ) {
								_target.goto( current.parent.getSceneAt( 0 ).sceneId );
							}
							break;
						}
					}
					
					break;
				}
				// フルスクリーンで表示する（F11 キー）
				case Keyboard.F11		: {
					if ( e.shiftKey || e.ctrlKey ) { break; }
					
					try {
						_stage.displayState = StageDisplayState.FULL_SCREEN;
					}
					catch ( err:Error ) {}
					
					break;
				}
			}
			
			// キー入力をクリアする
			_inputs = [];
			_timer.stop();
		}
		
		/**
		 * Timer.repeatCount で設定された数の要求が完了するたびに送出されます。
		 */
		private function _timerComplete( e:TimerEvent ):void {
			var num:int = parseInt( _inputs.join( "" ) ) - 1;
			_inputs = [];
			
			if ( -1 < num && num < _target.root.numScenes ) {
				var target:SceneObject = _target.root.getSceneAt( num );
				_target.goto( target.sceneId );
			}
		}
	}
}
