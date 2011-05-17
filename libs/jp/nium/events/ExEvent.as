/**
 * jp.nium Classes
 * 
 * @author Copyright (C) 2007-2010 taka:nium.jp, All Rights Reserved.
 * @version 4.0.22
 * @see http://classes.nium.jp/
 * 
 * jp.nium Classes is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 */
package jp.nium.events {
	import flash.events.Event;
	
	/**
	 * <span lang="ja">ExEvent クラスは、jp.nium パッケージで使用される基本的な Event クラスとして使用されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // ExEvent インスタンスを作成する
	 * var event:ExEvent = new ExEvent();
	 * </listing>
	 */
	public class ExEvent extends Event {
		
		/**
		 * <span lang="ja">ready イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ExEvent.EX_READY constant defines the value of the type property of an ready event object.</span>
		 * 
		 * @see jp.nium.display.ExDocument#event:exReady
		 */
		public static const EX_READY:String = "exReady";
		
		/**
		 * <span lang="ja">resizeStart イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ExEvent.EX_RESIZE_START constant defines the value of the type property of an resizeStart event object.</span>
		 * 
		 * @see flash.display.Stage#event:exResizeStart
		 */
		public static const EX_RESIZE_START:String = "exResizeStart";
		
		/**
		 * <span lang="ja">resizeProgress イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ExEvent.EX_RESIZE_PROGRESS constant defines the value of the type property of an resizeProgress event object.</span>
		 * 
		 * @see flash.display.Stage#event:exResizeProgress
		 */
		public static const EX_RESIZE_PROGRESS:String = "exResizeProgress";
		
		/**
		 * <span lang="ja">resizeComplete イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ExEvent.EX_RESIZE_COMPLETE constant defines the value of the type property of an resizeComplete event object.</span>
		 * 
		 * @see flash.display.Stage#event:exResizeComplete
		 */
		public static const EX_RESIZE_COMPLETE:String = "exResizeComplete";
		
		
		
		
		
		/**
		 * <span lang="ja">新しい ExEvent インスタンスを作成します。</span>
		 * <span lang="en">Creates a new ExEvent object.</span>
		 * 
		 * @param type
		 * <span lang="en">ExEvent.type としてアクセス可能なイベントタイプです。</span>
		 * <span lang="en">The type of the event, accessible as ExEvent.type.</span>
		 * @param bubbles
		 * <span lang="en">ExEvent インスタンスがイベントフローのバブリング段階で処理されるかどうかを判断します。デフォルト値は false です。</span>
		 * <span lang="en">Determines whether the ExEvent object participates in the bubbling stage of the event flow. The default value is false.</span>
		 * @param cancelable
		 * <span lang="en">ExEvent インスタンスがキャンセル可能かどうかを判断します。デフォルト値は false です。</span>
		 * <span lang="en">Determines whether the ExEvent object can be canceled. The default values is false.</span>
		 */
		public function ExEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
			// 親クラスを初期化する
			super( type, bubbles, cancelable );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">ExEvent インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an ExEvent subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい ExEvent インスタンスです。</span>
		 * <span lang="en">A new ExEvent object that is identical to the original.</span>
		 */
		override public function clone():Event {
			return new ExEvent( super.type, super.bubbles, super.cancelable );
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
			return super.formatToString( "ExEvent", "type", "bubbles", "cancelable" );
		}
	}
}
