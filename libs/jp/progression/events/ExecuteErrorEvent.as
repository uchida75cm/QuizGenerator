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
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	/**
	 * <span lang="ja">非同期処理中にエラーが発生した場合に ExecuteErrorEvent オブジェクトが送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // ExecuteErrorEvent インスタンスを作成する
	 * var event:ExecuteErrorEvent = new ExecuteErrorEvent();
	 * </listing>
	 */
	public class ExecuteErrorEvent extends ErrorEvent {
		
		/**
		 * <span lang="ja">error イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ExecuteErrorEvent.EXECUTE_ERROR constant defines the value of the type property of an error event object.</span>
		 * 
		 * @see jp.progression.casts.CastBitmap#event:executeError
		 * @see jp.progression.casts.CastButton#event:executeError
		 * @see jp.progression.casts.CastImageLoader#event:executeError
		 * @see jp.progression.casts.CastLoader#event:executeError
		 * @see jp.progression.casts.CastMovieClip#event:executeError
		 * @see jp.progression.casts.CastObject#event:executeError
		 * @see jp.progression.casts.CastSprite#event:executeError
		 * @see jp.progression.casts.CastTextField#event:executeError
		 * @see jp.progression.commands.Command#event:executeError
		 * @see jp.progression.executors.ExecutorObject#event:executeError
		 * @see jp.progression.scenes.SceneObject#event:executeError
		 */
		public static const EXECUTE_ERROR:String = "executeError";
		
		
		
		
		
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
		 * <span lang="ja">新しい ExecuteErrorEvent インスタンスを作成します。</span>
		 * <span lang="en">Creates a new ExecuteErrorEvent object.</span>
		 * 
		 * @param type
		 * <span lang="en">ExecuteErrorEvent.type としてアクセス可能なイベントタイプです。</span>
		 * <span lang="en">The type of the event, accessible as ExecuteErrorEvent.type.</span>
		 * @param bubbles
		 * <span lang="en">ExecuteErrorEvent インスタンスがイベントフローのバブリング段階で処理されるかどうかを判断します。デフォルト値は false です。</span>
		 * <span lang="en">Determines whether the ExecuteErrorEvent object participates in the bubbling stage of the event flow. The default value is false.</span>
		 * @param cancelable
		 * <span lang="en">ExecuteErrorEvent インスタンスがキャンセル可能かどうかを判断します。デフォルト値は false です。</span>
		 * <span lang="en">Determines whether the ExecuteErrorEvent object can be canceled. The default values is false.</span>
		 * @param errorTarget
		 * <span lang="ja">例外が送出された際の対象オブジェクトです。</span>
		 * <span lang="en"></span>
		 * @param errorObject
		 * <span lang="ja">オブジェクトからスローされた例外です。</span>
		 * <span lang="en"></span>
		 */
		public function ExecuteErrorEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false, errorTarget:* = null, errorObject:Error = null ) {
			// 親クラスを初期化する
			super( type, bubbles, cancelable );
			
			// 引数を設定する
			_errorTarget = errorTarget;
			_errorObject = errorObject;
		}
		
		
		
		
		
		/**
		 * <span lang="ja">ExecuteErrorEvent インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an ExecuteErrorEvent subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい ExecuteErrorEvent インスタンスです。</span>
		 * <span lang="en">A new ExecuteErrorEvent object that is identical to the original.</span>
		 */
		override public function clone():Event {
			return new ExecuteErrorEvent( super.type, super.bubbles, super.cancelable, _errorTarget, _errorObject );
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
			return super.formatToString( "ExecuteErrorEvent", "type", "bubbles", "cancelable", "errorTarget", "errorObject" );
		}
	}
}
