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
package jp.progression.events {
	import flash.events.Event;
	import jp.progression.scenes.SceneObject;
	
	/**
	 * <span lang="ja">SceneManager オブジェクトが処理を実行、完了、中断、等を行った場合に ProcessEvent オブジェクトが送出されます。
	 * 通常は、Progression オブジェクトを経由してイベントを受け取ります。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // ProcessEvent インスタンスを作成する
	 * var event:ProcessEvent = new ProcessEvent();
	 * </listing>
	 */
	public class ProcessEvent extends Event {
		
		/**
		 * <span lang="ja">processStart イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ProcessEvent.PROCESS_START constant defines the value of the type property of an processStart event object.</span>
		 * 
		 * @see jp.progression.Progression#event:processStart
		 */
		public static const PROCESS_START:String = "processStart";
		
		/**
		 * <span lang="ja">processScene イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ProcessEvent.PROCESS_SCENE constant defines the value of the type property of an processScene event object.</span>
		 * 
		 * @see jp.progression.Progression#event:processScene
		 */
		public static const PROCESS_SCENE:String = "processScene";
		
		/**
		 * <span lang="ja">processEvent イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ProcessEvent.PROCESS_EVENT constant defines the value of the type property of an processEvent event object.</span>
		 * 
		 * @see jp.progression.Progression#event:processEvent
		 */
		public static const PROCESS_EVENT:String = "processEvent";
		
		/**
		 * <span lang="ja">processChange イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ProcessEvent.PROCESS_CHANGE constant defines the value of the type property of an processChange event object.</span>
		 * 
		 * @see jp.progression.Progression#event:processChange
		 */
		public static const PROCESS_CHANGE:String = "processChange";
		
		/**
		 * <span lang="ja">processComplete イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ProcessEvent.PROCESS_COMPLETE constant defines the value of the type property of an processComplete event object.</span>
		 * 
		 * @see jp.progression.Progression#event:processComplete
		 */
		public static const PROCESS_COMPLETE:String = "processComplete";
		
		/**
		 * <span lang="ja">processStop イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ProcessEvent.PROCESS_STOP constant defines the value of the type property of an processStop event object.</span>
		 * 
		 * @see jp.progression.Progression#event:processStop
		 */
		public static const PROCESS_STOP:String = "processStop";
		
		/**
		 * <span lang="ja">processError イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ProcessEvent.PROCESS_ERROR constant defines the value of the type property of an processError event object.</span>
		 * 
		 * @see jp.progression.Progression#event:processError
		 */
		public static const PROCESS_ERROR:String = "processError";
		
		
		
		
		
		/**
		 * <span lang="ja">イベント発生時のカレントシーンを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get targetScene():SceneObject { return _targetScene; }
		private var _targetScene:SceneObject;
		
		/**
		 * <span lang="ja">イベント発生時のカレントイベントタイプを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get targetEventType():String { return _targetEventType; }
		private var _targetEventType:String;
		
		/**
		 * <span lang="ja">例外が送出された際の対象オブジェクトを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get errorTarget():* { return _errorTarget; }
		private var _errorTarget:*;
		
		/**
		 * <span lang="ja">オブジェクトからスローされた例外を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get errorObject():Error { return _errorObject; }
		private var _errorObject:Error;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい ProcessEvent インスタンスを作成します。</span>
		 * <span lang="en">Creates a new ProcessEvent object.</span>
		 * 
		 * @param type
		 * <span lang="en">ProcessEvent.type としてアクセス可能なイベントタイプです。</span>
		 * <span lang="en">The type of the event, accessible as ProcessEvent.type.</span>
		 * @param bubbles
		 * <span lang="en">ProcessEvent インスタンスがイベントフローのバブリング段階で処理されるかどうかを判断します。デフォルト値は false です。</span>
		 * <span lang="en">Determines whether the ProcessEvent object participates in the bubbling stage of the event flow. The default value is false.</span>
		 * @param cancelable
		 * <span lang="en">ProcessEvent インスタンスがキャンセル可能かどうかを判断します。デフォルト値は false です。</span>
		 * <span lang="en">Determines whether the ProcessEvent object can be canceled. The default values is false.</span>
		 * @param targetScene
		 * <span lang="ja">イベント発生時のカレントシーンです。</span>
		 * <span lang="en"></span>
		 * @param targetEventType
		 * <span lang="ja">イベント発生時のカレントイベントタイプです。</span>
		 * <span lang="en"></span>
		 * @param errorTarget
		 * <span lang="ja">例外が送出された際の対象オブジェクトです。</span>
		 * <span lang="en"></span>
		 * @param errorObject
		 * <span lang="ja">オブジェクトからスローされた例外です。</span>
		 * <span lang="en"></span>
		 */
		public function ProcessEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false, targetScene:SceneObject = null, targetEventType:String = null, errorTarget:* = null, errorObject:Error = null ) {
			// 親クラスを初期化する
			super( type, bubbles, cancelable );
			
			// 引数を設定する
			_targetScene = targetScene;
			_targetEventType = targetEventType;
			_errorTarget = errorTarget;
			_errorObject = errorObject;
		}
		
		
		
		
		
		/**
		 * <span lang="ja">ProcessEvent インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an ProcessEvent subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい ProcessEvent インスタンスです。</span>
		 * <span lang="en">A new ProcessEvent object that is identical to the original.</span>
		 */
		override public function clone():Event {
			return new ProcessEvent( super.type, super.bubbles, super.cancelable, _targetScene, _targetEventType, _errorTarget, _errorObject );
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
			return super.formatToString( "ProcessEvent", "type", "bubbles", "cancelable", "targetScene", "targetEventType", "errorTarget", "errorObject" );
		}
	}
}
