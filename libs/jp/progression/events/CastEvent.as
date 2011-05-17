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
	 * <span lang="ja">IExecutable インターフェイスを実装したオブジェクトが AddChild コマンドや RemoveChild コマンドなどによって表示リストに追加された場合などに CastEvent オブジェクトが送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // CastEvent インスタンスを作成する
	 * var event:CastEvent = new CastEvent();
	 * </listing>
	 */
	public class CastEvent extends Event {
		
		/**
		 * <span lang="ja">castAdded イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The CastEvent.CAST_ADDED constant defines the value of the type property of an castAdded event object.</span>
		 * 
		 * @see jp.progression.casts.CastBitmap#event:castAdded
		 * @see jp.progression.casts.CastButton#event:castAdded
		 * @see jp.progression.casts.CastImageLoader#event:castAdded
		 * @see jp.progression.casts.CastLoader#event:castAdded
		 * @see jp.progression.casts.CastMovieClip#event:castAdded
		 * @see jp.progression.casts.CastObject#event:castAdded
		 * @see jp.progression.casts.CastSprite#event:castAdded
		 * @see jp.progression.casts.CastTextField#event:castAdded
		 */
		public static const CAST_ADDED:String = "castAdded";
		
		/**
		 * <span lang="ja">castAddedComplete イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The CastEvent.CAST_ADDED_COMPLETE constant defines the value of the type property of an castAddedComplete event object.</span>
		 * 
		 * @see jp.progression.casts.CastBitmap#event:castAddedComplete
		 * @see jp.progression.casts.CastButton#event:castAddedComplete
		 * @see jp.progression.casts.CastImageLoader#event:castAddedComplete
		 * @see jp.progression.casts.CastLoader#event:castAddedComplete
		 * @see jp.progression.casts.CastMovieClip#event:castAddedComplete
		 * @see jp.progression.casts.CastObject#event:castAddedComplete
		 * @see jp.progression.casts.CastSprite#event:castAddedComplete
		 * @see jp.progression.casts.CastTextField#event:castAddedComplete
		 */
		public static const CAST_ADDED_COMPLETE:String = "castAddedComplete";
		
		/**
		 * <span lang="ja">castRemoved イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The CastEvent.CAST_REMOVED constant defines the value of the type property of an castRemoved event object.</span>
		 * 
		 * @see jp.progression.casts.CastBitmap#event:castRemoved
		 * @see jp.progression.casts.CastButton#event:castRemoved
		 * @see jp.progression.casts.CastImageLoader#event:castRemoved
		 * @see jp.progression.casts.CastLoader#event:castRemoved
		 * @see jp.progression.casts.CastMovieClip#event:castRemoved
		 * @see jp.progression.casts.CastObject#event:castRemoved
		 * @see jp.progression.casts.CastSprite#event:castRemoved
		 * @see jp.progression.casts.CastTextField#event:castRemoved
		 */
		public static const CAST_REMOVED:String = "castRemoved";
		
		/**
		 * <span lang="ja">castRemovedComplete イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The CastEvent.CAST_REMOVED_COMPLETE constant defines the value of the type property of an castRemovedComplete event object.</span>
		 * 
		 * @see jp.progression.casts.CastBitmap#event:castRemovedComplete
		 * @see jp.progression.casts.CastButton#event:castRemovedComplete
		 * @see jp.progression.casts.CastImageLoader#event:castRemovedComplete
		 * @see jp.progression.casts.CastLoader#event:castRemovedComplete
		 * @see jp.progression.casts.CastMovieClip#event:castRemovedComplete
		 * @see jp.progression.casts.CastObject#event:castRemovedComplete
		 * @see jp.progression.casts.CastSprite#event:castRemovedComplete
		 * @see jp.progression.casts.CastTextField#event:castRemovedComplete
		 */
		public static const CAST_REMOVED_COMPLETE:String = "castRemovedComplete";
		
		/**
		 * <span lang="ja">castLoadStart イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The CastEvent.CAST_LOAD_START constant defines the value of the type property of an castLoadStart event object.</span>
		 * 
		 * @see jp.progression.casts.CastPreloader#event:castLoadStart
		 */
		public static const CAST_LOAD_START:String = "castLoadStart";
		
		/**
		 * <span lang="ja">castLoadComplete イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The CastEvent.CAST_LOAD_COMPLETE constant defines the value of the type property of an castLoadComplete event object.</span>
		 * 
		 * @see jp.progression.casts.CastPreloader#event:castLoadComplete
		 */
		public static const CAST_LOAD_COMPLETE:String = "castLoadComplete";
		
		
		
		
		
		/**
		 * <span lang="ja">新しい CastEvent インスタンスを作成します。</span>
		 * <span lang="en">Creates a new CastEvent object.</span>
		 * 
		 * @param type
		 * <span lang="en">CastEvent.type としてアクセス可能なイベントタイプです。</span>
		 * <span lang="en">The type of the event, accessible as CastEvent.type.</span>
		 * @param bubbles
		 * <span lang="en">CastEvent インスタンスがイベントフローのバブリング段階で処理されるかどうかを判断します。デフォルト値は false です。</span>
		 * <span lang="en">Determines whether the CastEvent object participates in the bubbling stage of the event flow. The default value is false.</span>
		 * @param cancelable
		 * <span lang="en">CastEvent インスタンスがキャンセル可能かどうかを判断します。デフォルト値は false です。</span>
		 * <span lang="en">Determines whether the CastEvent object can be canceled. The default values is false.</span>
		 */
		public function CastEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
			// 親クラスを初期化する
			super( type, bubbles, cancelable );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">CastEvent インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an CastEvent subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい CastEvent インスタンスです。</span>
		 * <span lang="en">A new CastEvent object that is identical to the original.</span>
		 */
		override public function clone():Event {
			return new CastEvent( super.type, super.bubbles, super.cancelable );
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
			return super.formatToString( "CastEvent", "type", "bubbles", "cancelable", "eventPhase" );
		}
	}
}
