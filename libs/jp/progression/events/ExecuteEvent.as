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
	
	/**
	 * <span lang="ja">非同期処理を実行、完了、中断、等を行った場合に ExecuteEvent オブジェクトが送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // ExecuteEvent インスタンスを作成する
	 * var event:ExecuteEvent = new ExecuteEvent();
	 * </listing>
	 */
	public class ExecuteEvent extends Event {
		
		/**
		 * <span lang="ja">executeStart イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ExecuteEvent.EXECUTE_START constant defines the value of the type property of an executeStart event object.</span>
		 * 
		 * @see jp.progression.commands.Command#event:executeStart
		 * @see jp.progression.executors.ExecutorObject#event:executeStart
		 */
		public static const EXECUTE_START:String = "executeStart";
		
		/**
		 * <span lang="ja">executePosition イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ExecuteEvent.EXECUTE_POSITION constant defines the value of the type property of an executePosition event object.</span>
		 * 
		 * @see jp.progression.commands.lists.ParallelList#event:executePosition
		 * @see jp.progression.commands.lists.SerialList#event:executePosition
		 */
		public static const EXECUTE_POSITION:String = "executePosition";
		
		/**
		 * <span lang="ja">executeUpdate イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ExecuteEvent.EXECUTE_UPDATE constant defines the value of the type property of an executeUpdate event object.</span>
		 * 
		 * @see jp.progression.commands.lists.ParallelList#event:executeUpdate
		 * @see jp.progression.commands.tweens.DoTransition#event:executeUpdate
		 * @see jp.progression.commands.tweens.DoTween#event:executeUpdate
		 * @see jp.progression.commands.tweens.DoTweener#event:executeUpdate
		 * @see jp.progression.commands.tweens.DoTweenFrame#event:executeUpdate
		 */
		public static const EXECUTE_UPDATE:String = "executeUpdate";
		
		/**
		 * <span lang="ja">executeComplete イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ExecuteEvent.EXECUTE_COMPLETE constant defines the value of the type property of an executeComplete event object.</span>
		 * 
		 * @see jp.progression.commands.Command#event:executeComplete
		 * @see jp.progression.executors.ExecutorObject#event:executeComplete
		 */
		public static const EXECUTE_COMPLETE:String = "executeComplete";
		
		/**
		 * <span lang="ja">executeInterrupt イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ExecuteEvent.EXECUTE_INTERRUPT constant defines the value of the type property of an executeInterrupt event object.</span>
		 * 
		 * @see jp.progression.commands.Command#event:executeInterrupt
		 * @see jp.progression.executors.ExecutorObject#event:executeInterrupt
		 */
		public static const EXECUTE_INTERRUPT:String = "executeInterrupt";
		
		
		
		
		
		/**
		 * <span lang="ja">実行対象となるオブジェクトを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get executeTarget():Object { return _executeTarget; }
		private var _executeTarget:Object;
		
		/**
		 * <span lang="ja">強制中断であるかどうかを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get enforcedInterrupting():Boolean { return _enforcedInterrupting; }
		private var _enforcedInterrupting:Boolean = false;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい ExecuteEvent インスタンスを作成します。</span>
		 * <span lang="en">Creates a new ExecuteEvent object.</span>
		 * 
		 * @param type
		 * <span lang="en">ExecuteEvent.type としてアクセス可能なイベントタイプです。</span>
		 * <span lang="en">The type of the event, accessible as ExecuteEvent.type.</span>
		 * @param bubbles
		 * <span lang="en">ExecuteEvent インスタンスがイベントフローのバブリング段階で処理されるかどうかを判断します。デフォルト値は false です。</span>
		 * <span lang="en">Determines whether the ExecuteEvent object participates in the bubbling stage of the event flow. The default value is false.</span>
		 * @param cancelable
		 * <span lang="en">ExecuteEvent インスタンスがキャンセル可能かどうかを判断します。デフォルト値は false です。</span>
		 * <span lang="en">Determines whether the ExecuteEvent object can be canceled. The default values is false.</span>
		 * @param executeTarget
		 * <span lang="ja">実行対象となるオブジェクトです。</span>
		 * <span lang="en"></span>
		 * @param enforcedInterrupting
		 * <span lang="ja">強制中断であるかどうかです。</span>
		 * <span lang="en"></span>
		 */
		public function ExecuteEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false, executeTarget:Object = null, enforcedInterrupting:Boolean = false ) {
			// 親クラスを初期化する
			super( type, bubbles, cancelable );
			
			// 引数を設定する
			_executeTarget = executeTarget;
			_enforcedInterrupting = enforcedInterrupting;
		}
		
		
		
		
		
		/**
		 * <span lang="ja">ExecuteEvent インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an ExecuteEvent subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい ExecuteEvent インスタンスです。</span>
		 * <span lang="en">A new ExecuteEvent object that is identical to the original.</span>
		 */
		override public function clone():Event {
			return new ExecuteEvent( super.type, super.bubbles, super.cancelable, _executeTarget, _enforcedInterrupting );
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
			return super.formatToString( "ExecuteEvent", "type", "bubbles", "cancelable", "executeTarget", "enforcedInterrupting" );
		}
	}
}

