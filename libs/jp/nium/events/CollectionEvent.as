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
	 * <span lang="ja">コレクションに対して各種操作が行われた場合に CollectionEvent オブジェクトが送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // CollectionEvent インスタンスを作成する
	 * var event:CollectionEvent = new CollectionEvent();
	 * </listing>
	 */
	public class CollectionEvent extends Event {
		
		/**
		 * <span lang="ja">collectionUpdate イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The CollectionEvent.COLLECTION_UPDATE constant defines the value of the type property of an collectionUpdate event object.</span>
		 * 
		 * @see jp.nium.collections.IdGroupCollection#event:collectionUpdate
		 */
		public static const COLLECTION_UPDATE:String = "collectionUpdate";
		
		
		
		
		
		/**
		 * <span lang="ja">イベント発生対象となるコレクションを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get collectionTarget():* { return _collectionTarget; }
		private var _collectionTarget:*;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい CollectionEvent インスタンスを作成します。</span>
		 * <span lang="en">Creates a new CollectionEvent object.</span>
		 * 
		 * @param type
		 * <span lang="en">CollectionEvent.type としてアクセス可能なイベントタイプです。</span>
		 * <span lang="en">The type of the event, accessible as CollectionEvent.type.</span>
		 * @param bubbles
		 * <span lang="en">CollectionEvent インスタンスがイベントフローのバブリング段階で処理されるかどうかを判断します。デフォルト値は false です。</span>
		 * <span lang="en">Determines whether the CollectionEvent object participates in the bubbling stage of the event flow. The default value is false.</span>
		 * @param cancelable
		 * <span lang="en">CollectionEvent インスタンスがキャンセル可能かどうかを判断します。デフォルト値は false です。</span>
		 * <span lang="en">Determines whether the CollectionEvent object can be canceled. The default values is false.</span>
		 * @param collectionTarget
		 * <span lang="ja">イベント発生対象となるコレクションです。</span>
		 * <span lang="en"></span>
		 */
		public function CollectionEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false, collectionTarget:* = null ) {
			// 親クラスを初期化する
			super( type, bubbles, cancelable );
			
			// 引数を設定する
			_collectionTarget = collectionTarget;
		}
		
		
		
		
		
		/**
		 * <span lang="ja">CollectionEvent インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an CollectionEvent subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい CollectionEvent インスタンスです。</span>
		 * <span lang="en">A new CollectionEvent object that is identical to the original.</span>
		 */
		override public function clone():Event {
			return new CollectionEvent( super.type, super.bubbles, super.cancelable, _collectionTarget );
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
			return super.formatToString( "CollectionEvent", "type", "bubbles", "cancelable", "eventPhase", "collectionTarget" );
		}
	}
}
