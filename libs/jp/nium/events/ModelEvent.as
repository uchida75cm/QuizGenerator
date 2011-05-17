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
	import jp.nium.models.Model;
	
	/**
	 * <span lang="ja">ModelEvent クラスは、モデルオブジェクトの管理する値が状態が変更される直前や変更された直後に Model インスタンスによって送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // ModelEvent インスタンスを作成する
	 * var event:ModelEvent = new ModelEvent();
	 * </listing>
	 */
	public class ModelEvent extends Event {
		
		/**
		 * <span lang="ja">modelAdded イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ModelEvent.MODEL_ADDED constant defines the value of the type property of an modelAdded event object.</span>
		 * 
		 * @see jp.nium.models.Model#event:modelAdded
		 */
		public static const MODEL_ADDED:String = "modelAdded";
		
		/**
		 * <span lang="ja">modelRemoved イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ModelEvent.MODEL_REMOVED constant defines the value of the type property of an modelRemoved event object.</span>
		 * 
		 * @see jp.nium.models.Model#event:modelRemoved
		 */
		public static const MODEL_REMOVED:String = "modelRemoved";
		
		/**
		 * <span lang="ja">modelUpdateBefore イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ModelEvent.MODEL_UPDATE_BEFORE constant defines the value of the type property of an modelUpdateBefore event object.</span>
		 * 
		 * @see jp.nium.models.Model#event:modelUpdateBefore
		 */
		public static const MODEL_UPDATE_BEFORE:String = "modelUpdateBefore";
		
		/**
		 * <span lang="ja">modelUpdateSuccess イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ModelEvent.MODEL_UPDATE_SUCCESS constant defines the value of the type property of an modelUpdateSuccess event object.</span>
		 * 
		 * @see jp.nium.models.Model#event:modelUpdateSuccess
		 */
		public static const MODEL_UPDATE_SUCCESS:String = "modelUpdateSuccess";
		
		/**
		 * <span lang="ja">modelUpdateFailure イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ModelEvent.MODEL_UPDATE_FAILURE constant defines the value of the type property of an modelUpdateFailure event object.</span>
		 * 
		 * @see jp.nium.models.Model#event:modelUpdateFailure
		 */
		public static const MODEL_UPDATE_FAILURE:String = "modelUpdateFailure";
		
		
		
		
		
		/**
		 * <span lang="ja">データ変更処理の対象となる Model インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get modelTarget():Model { return _modelTarget; }
		private var _modelTarget:Model;
		
		/**
		 * <span lang="ja">変更される Model インスタンスのプロパティ名を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get dataName():String { return _dataName; }
		private var _dataName:String;
		
		/**
		 * <span lang="ja">変更前のデータを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get oldData():* { return _oldData; }
		private var _oldData:*;
		
		/**
		 * <span lang="ja">変更後のデータを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get newData():* { return _newData; }
		private var _newData:*;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい ModelEvent インスタンスを作成します。</span>
		 * <span lang="en">Creates a new ModelEvent object.</span>
		 * 
		 * @param type
		 * <span lang="en">ModelEvent.type としてアクセス可能なイベントタイプです。</span>
		 * <span lang="en">The type of the event, accessible as ModelEvent.type.</span>
		 * @param bubbles
		 * <span lang="en">ModelEvent インスタンスがイベントフローのバブリング段階で処理されるかどうかを判断します。デフォルト値は false です。</span>
		 * <span lang="en">Determines whether the ModelEvent object participates in the bubbling stage of the event flow. The default value is false.</span>
		 * @param cancelable
		 * <span lang="en">ModelEvent インスタンスがキャンセル可能かどうかを判断します。デフォルト値は false です。</span>
		 * <span lang="en">Determines whether the ModelEvent object can be canceled. The default values is false.</span>
		 * @param modelTarget
		 * <span lang="ja">データ変更処理の対象となる Model インスタンスです。</span>
		 * <span lang="en"></span>
		 * @param dataName
		 * <span lang="ja">変更される Model インスタンスのプロパティ名です。</span>
		 * <span lang="en"></span>
		 * @param oldData
		 * <span lang="ja">変更前のデータです。</span>
		 * <span lang="en"></span>
		 * @param newData
		 * <span lang="ja">変更後のデータです。</span>
		 * <span lang="en"></span>
		 */
		public function ModelEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false, modelTarget:Model = null, dataName:String = null, oldData:* = null, newData:* = null ) {
			// 親クラスを初期化する
			super( type, bubbles, cancelable );
			
			// 引数を設定する
			_modelTarget = modelTarget;
			_dataName = dataName;
			_oldData = oldData;
			_newData = newData;
		}
		
		
		
		
		
		/**
		 * <span lang="ja">ModelEvent インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an ModelEvent subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい ModelEvent インスタンスです。</span>
		 * <span lang="en">A new ModelEvent object that is identical to the original.</span>
		 */
		override public function clone():Event {
			return new ModelEvent( super.type, super.bubbles, super.cancelable, _modelTarget, _dataName, _oldData, _newData );
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
			return super.formatToString( "ModelEvent", "type", "bubbles", "cancelable", "modelTarget", "dataName", "oldData", "newData" );
		}
	}
}
