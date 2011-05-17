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
package jp.progression.core.events {
	import flash.events.Event;
	
	/**
	 * @private
	 */
	public class ComponentEvent extends Event {
		
		/**
		 * <span lang="ja">componentAdded イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ComponentEvent.COMPONENT_ADDED constant defines the value of the type property of an componentAdded event object.</span>
		 */
		public static const COMPONENT_ADDED:String = "componentAdded";
		
		/**
		 * <span lang="ja">componentRemoved イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ComponentEvent.COMPONENT_REMOVED constant defines the value of the type property of an componentRemoved event object.</span>
		 */
		public static const COMPONENT_REMOVED:String = "componentRemoved";
		
		/**
		 * <span lang="ja">componentUpdate イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ComponentEvent.COMPONENT_UPDATE constant defines the value of the type property of an componentUpdate event object.</span>
		 */
		public static const COMPONENT_UPDATE:String = "componentUpdate";
		
		/**
		 * <span lang="ja">componentLoaderActivate イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ComponentEvent.COMPONENT_LOADER_ACTIVATE constant defines the value of the type property of an componentLoaderActivate event object.</span>
		 */
		public static const COMPONENT_LOADER_ACTIVATE:String = "componentLoaderActivate";
		
		/**
		 * <span lang="ja">componentLoaderDeactivate イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ComponentEvent.COMPONENT_DELOADER_ACTIVATE constant defines the value of the type property of an componentLoaderDeactivate event object.</span>
		 */
		public static const COMPONENT_LOADER_DEACTIVATE:String = "componentLoaderDeactivate";
		
		/**
		 * <span lang="ja">componentButtonActivate イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ComponentEvent.COMPONENT_BUTTON_ACTIVATE constant defines the value of the type property of an componentButtonActivate event object.</span>
		 */
		public static const COMPONENT_BUTTON_ACTIVATE:String = "componentButtonActivate";
		
		/**
		 * <span lang="ja">componentButtonDeactivate イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ComponentEvent.COMPONENT_BUTTON_DEACTIVATE constant defines the value of the type property of an componentButtonDeactivate event object.</span>
		 */
		public static const COMPONENT_BUTTON_DEACTIVATE:String = "componentButtonDeactivate";
		
		
		
		
		
		/**
		 * <span lang="ja">新しい ComponentEvent インスタンスを作成します。</span>
		 * <span lang="en">Creates a new ComponentEvent object.</span>
		 * 
		 * @param type
		 * <span lang="en">ComponentEvent.type としてアクセス可能なイベントタイプです。</span>
		 * <span lang="en">The type of the event, accessible as ComponentEvent.type.</span>
		 * @param bubbles
		 * <span lang="en">ComponentEvent インスタンスがイベントフローのバブリング段階で処理されるかどうかを判断します。デフォルト値は false です。</span>
		 * <span lang="en">Determines whether the ComponentEvent object participates in the bubbling stage of the event flow. The default value is false.</span>
		 * @param cancelable
		 * <span lang="en">ComponentEvent インスタンスがキャンセル可能かどうかを判断します。デフォルト値は false です。</span>
		 * <span lang="en">Determines whether the ComponentEvent object can be canceled. The default values is false.</span>
		 */
		public function ComponentEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
			// 親クラスを初期化する
			super( type, bubbles, cancelable );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">ComponentEvent インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an ComponentEvent subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい ComponentEvent インスタンスです。</span>
		 * <span lang="en">A new ComponentEvent object that is identical to the original.</span>
		 */
		override public function clone():Event {
			return new ComponentEvent( super.type, super.bubbles, super.cancelable );
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
			return super.formatToString( "ComponentEvent", "type", "bubbles", "cancelable", "eventPhase" );
		}
	}
}
