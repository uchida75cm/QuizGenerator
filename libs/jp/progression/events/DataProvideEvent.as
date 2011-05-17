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
	 * <span lang="ja">DataHolder インスタンスが管理するデータに対して各種操作が行われた場合に DataProvideEvent オブジェクトが送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // DataProvideEvent インスタンスを作成する
	 * var event:DataProvideEvent = new DataProvideEvent();
	 * </listing>
	 */
	public class DataProvideEvent extends Event {
		
		/**
		 * <span lang="ja">dataUpdate イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The DataProvideEvent.DATA_UPDATE constant defines the value of the type property of an dataUpdate event object.</span>
		 * 
		 * @see jp.progression.data.DataHolder#event:dataUpdate
		 */
		public static const DATA_UPDATE:String = "dataUpdate";
		
		
		
		
		
		/**
		 * <span lang="ja">以前に設定されていた古いデータを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get oldData():* { return _oldData; }
		private var _oldData:*;
		
		/**
		 * <span lang="ja">新しく設定されるデータを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get newData():* { return _newData; }
		private var _newData:*;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい DataProvideEvent インスタンスを作成します。</span>
		 * <span lang="en">Creates a new DataProvideEvent object.</span>
		 * 
		 * @param type
		 * <span lang="en">DataProvideEvent.type としてアクセス可能なイベントタイプです。</span>
		 * <span lang="en">The type of the event, accessible as DataProvideEvent.type.</span>
		 * @param bubbles
		 * <span lang="en">DataProvideEvent インスタンスがイベントフローのバブリング段階で処理されるかどうかを判断します。デフォルト値は false です。</span>
		 * <span lang="en">Determines whether the DataProvideEvent object participates in the bubbling stage of the event flow. The default value is false.</span>
		 * @param cancelable
		 * <span lang="en">DataProvideEvent インスタンスがキャンセル可能かどうかを判断します。デフォルト値は false です。</span>
		 * <span lang="en">Determines whether the DataProvideEvent object can be canceled. The default values is false.</span>
		 * @param oldData
		 * <span lang="ja">以前に設定されていた古いデータです。</span>
		 * <span lang="en"></span>
		 * @param newData
		 * <span lang="ja">新しく設定されるデータです。</span>
		 * <span lang="en"></span>
		 */
		public function DataProvideEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false, oldData:* = null, newData:* = null ) {
			// 親クラスを初期化する
			super( type, bubbles, cancelable );
			
			// 引数を設定する
			_oldData = oldData;
			_newData = newData;
		}
		
		
		
		
		
		/**
		 * <span lang="ja">DataProvideEvent インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an DataProvideEvent subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい DataProvideEvent インスタンスです。</span>
		 * <span lang="en">A new DataProvideEvent object that is identical to the original.</span>
		 */
		override public function clone():Event {
			return new DataProvideEvent( super.type, super.bubbles, super.cancelable, _oldData, _newData );
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
			return super.formatToString( "DataProvideEvent", "type", "bubbles", "cancelable", "oldData", "newData" );
		}
	}
}
