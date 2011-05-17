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
	 * <span lang="ja"></span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // DynamicEvent インスタンスを作成する
	 * var event:DynamicEvent = new DynamicEvent();
	 * </listing>
	 */
	public dynamic class DynamicEvent extends Event {
		
		/**
		 * <span lang="ja">新しい DynamicEvent インスタンスを作成します。</span>
		 * <span lang="en">Creates a new DynamicEvent object.</span>
		 * 
		 * @param type
		 * <span lang="en">DynamicEvent.type としてアクセス可能なイベントタイプです。</span>
		 * <span lang="en">The type of the event, accessible as DynamicEvent.type.</span>
		 * @param bubbles
		 * <span lang="en">DynamicEvent インスタンスがイベントフローのバブリング段階で処理されるかどうかを判断します。デフォルト値は false です。</span>
		 * <span lang="en">Determines whether the DynamicEvent object participates in the bubbling stage of the event flow. The default value is false.</span>
		 * @param cancelable
		 * <span lang="en">DynamicEvent インスタンスがキャンセル可能かどうかを判断します。デフォルト値は false です。</span>
		 * <span lang="en">Determines whether the DynamicEvent object can be canceled. The default values is false.</span>
		 */
		public function DynamicEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
			// 親クラスを初期化する
			super( type, bubbles, cancelable );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">DynamicEvent インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an DynamicEvent subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい DynamicEvent インスタンスです。</span>
		 * <span lang="en">A new DynamicEvent object that is identical to the original.</span>
		 */
		override public function clone():Event {
			return new DynamicEvent( super.type, super.bubbles, super.cancelable );
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
			return super.formatToString( "DynamicEvent", "type", "bubbles", "cancelable" );
		}
	}
}
